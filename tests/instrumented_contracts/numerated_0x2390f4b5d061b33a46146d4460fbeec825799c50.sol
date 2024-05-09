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
74 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * See https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address _who) public view returns (uint256);
84   function transfer(address _to, uint256 _value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address _owner, address _spender)
96     public view returns (uint256);
97 
98   function transferFrom(address _from, address _to, uint256 _value)
99     public returns (bool);
100 
101   function approve(address _spender, uint256 _value) public returns (bool);
102   event Approval(
103     address indexed owner,
104     address indexed spender,
105     uint256 value
106   );
107 }
108 
109 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
110 
111 /**
112  * @title DetailedERC20 token
113  * @dev The decimals are only for visualization purposes.
114  * All the operations are done using the smallest and indivisible token unit,
115  * just as on Ethereum all the operations are done in wei.
116  */
117 contract DetailedERC20 is ERC20 {
118   string public name;
119   string public symbol;
120   uint8 public decimals;
121 
122   constructor(string _name, string _symbol, uint8 _decimals) public {
123     name = _name;
124     symbol = _symbol;
125     decimals = _decimals;
126   }
127 }
128 
129 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
130 
131 /**
132  * @title Ownable
133  * @dev The Ownable contract has an owner address, and provides basic authorization control
134  * functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137   address public owner;
138 
139   event OwnershipRenounced(address indexed previousOwner);
140   event OwnershipTransferred(
141     address indexed previousOwner,
142     address indexed newOwner
143   );
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   constructor() public {
150     owner = msg.sender;
151   }
152 
153   /**
154    * @dev Throws if called by any account other than the owner.
155    */
156   modifier onlyOwner() {
157     require(msg.sender == owner);
158     _;
159   }
160 
161   /**
162    * @dev Allows the current owner to relinquish control of the contract.
163    * @notice Renouncing to ownership will leave the contract without an owner.
164    * It will not be possible to call the functions with the `onlyOwner`
165    * modifier anymore.
166    */
167   function renounceOwnership() public onlyOwner {
168     emit OwnershipRenounced(owner);
169     owner = address(0);
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param _newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address _newOwner) public onlyOwner {
177     _transferOwnership(_newOwner);
178   }
179 
180   /**
181    * @dev Transfers control of the contract to a newOwner.
182    * @param _newOwner The address to transfer ownership to.
183    */
184   function _transferOwnership(address _newOwner) internal {
185     require(_newOwner != address(0));
186     emit OwnershipTransferred(owner, _newOwner);
187     owner = _newOwner;
188   }
189 }
190 
191 // File: openzeppelin-solidity/contracts/math/Math.sol
192 
193 /**
194  * @title Math
195  * @dev Assorted math operations
196  */
197 library Math {
198   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
199     return _a >= _b ? _a : _b;
200   }
201 
202   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
203     return _a < _b ? _a : _b;
204   }
205 
206   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
207     return _a >= _b ? _a : _b;
208   }
209 
210   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
211     return _a < _b ? _a : _b;
212   }
213 }
214 
215 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
216 
217 /**
218  * @title Basic token
219  * @dev Basic version of StandardToken, with no allowances.
220  */
221 contract BasicToken is ERC20Basic {
222   using SafeMath for uint256;
223 
224   mapping(address => uint256) internal balances;
225 
226   uint256 internal totalSupply_;
227 
228   /**
229   * @dev Total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return totalSupply_;
233   }
234 
235   /**
236   * @dev Transfer token for a specified address
237   * @param _to The address to transfer to.
238   * @param _value The amount to be transferred.
239   */
240   function transfer(address _to, uint256 _value) public returns (bool) {
241     require(_value <= balances[msg.sender]);
242     require(_to != address(0));
243 
244     balances[msg.sender] = balances[msg.sender].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     emit Transfer(msg.sender, _to, _value);
247     return true;
248   }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param _owner The address to query the the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address _owner) public view returns (uint256) {
256     return balances[_owner];
257   }
258 
259 }
260 
261 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
262 
263 /**
264  * @title Standard ERC20 token
265  *
266  * @dev Implementation of the basic standard token.
267  * https://github.com/ethereum/EIPs/issues/20
268  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
269  */
270 contract StandardToken is ERC20, BasicToken {
271 
272   mapping (address => mapping (address => uint256)) internal allowed;
273 
274   /**
275    * @dev Transfer tokens from one address to another
276    * @param _from address The address which you want to send tokens from
277    * @param _to address The address which you want to transfer to
278    * @param _value uint256 the amount of tokens to be transferred
279    */
280   function transferFrom(
281     address _from,
282     address _to,
283     uint256 _value
284   )
285     public
286     returns (bool)
287   {
288     require(_value <= balances[_from]);
289     require(_value <= allowed[_from][msg.sender]);
290     require(_to != address(0));
291 
292     balances[_from] = balances[_from].sub(_value);
293     balances[_to] = balances[_to].add(_value);
294     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295     emit Transfer(_from, _to, _value);
296     return true;
297   }
298 
299   /**
300    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
301    * Beware that changing an allowance with this method brings the risk that someone may use both the old
302    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305    * @param _spender The address which will spend the funds.
306    * @param _value The amount of tokens to be spent.
307    */
308   function approve(address _spender, uint256 _value) public returns (bool) {
309     allowed[msg.sender][_spender] = _value;
310     emit Approval(msg.sender, _spender, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Function to check the amount of tokens that an owner allowed to a spender.
316    * @param _owner address The address which owns the funds.
317    * @param _spender address The address which will spend the funds.
318    * @return A uint256 specifying the amount of tokens still available for the spender.
319    */
320   function allowance(
321     address _owner,
322     address _spender
323    )
324     public
325     view
326     returns (uint256)
327   {
328     return allowed[_owner][_spender];
329   }
330 
331   /**
332    * @dev Increase the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed[_spender] == 0. To increment
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param _spender The address which will spend the funds.
338    * @param _addedValue The amount of tokens to increase the allowance by.
339    */
340   function increaseApproval(
341     address _spender,
342     uint256 _addedValue
343   )
344     public
345     returns (bool)
346   {
347     allowed[msg.sender][_spender] = (
348       allowed[msg.sender][_spender].add(_addedValue));
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353   /**
354    * @dev Decrease the amount of tokens that an owner allowed to a spender.
355    * approve should be called when allowed[_spender] == 0. To decrement
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * From MonolithDAO Token.sol
359    * @param _spender The address which will spend the funds.
360    * @param _subtractedValue The amount of tokens to decrease the allowance by.
361    */
362   function decreaseApproval(
363     address _spender,
364     uint256 _subtractedValue
365   )
366     public
367     returns (bool)
368   {
369     uint256 oldValue = allowed[msg.sender][_spender];
370     if (_subtractedValue >= oldValue) {
371       allowed[msg.sender][_spender] = 0;
372     } else {
373       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374     }
375     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376     return true;
377   }
378 
379 }
380 
381 // File: contracts/lib/AccessControlledBase.sol
382 
383 /**
384  * @title AccessControlledBase
385  * @author dYdX
386  *
387  * Base functionality for access control. Requires an implementation to
388  * provide a way to grant and optionally revoke access
389  */
390 contract AccessControlledBase {
391     // ============ State Variables ============
392 
393     mapping (address => bool) public authorized;
394 
395     // ============ Events ============
396 
397     event AccessGranted(
398         address who
399     );
400 
401     event AccessRevoked(
402         address who
403     );
404 
405     // ============ Modifiers ============
406 
407     modifier requiresAuthorization() {
408         require(
409             authorized[msg.sender],
410             "AccessControlledBase#requiresAuthorization: Sender not authorized"
411         );
412         _;
413     }
414 }
415 
416 // File: contracts/lib/StaticAccessControlled.sol
417 
418 /**
419  * @title StaticAccessControlled
420  * @author dYdX
421  *
422  * Allows for functions to be access controled
423  * Permissions cannot be changed after a grace period
424  */
425 contract StaticAccessControlled is AccessControlledBase, Ownable {
426     using SafeMath for uint256;
427 
428     // ============ State Variables ============
429 
430     // Timestamp after which no additional access can be granted
431     uint256 public GRACE_PERIOD_EXPIRATION;
432 
433     // ============ Constructor ============
434 
435     constructor(
436         uint256 gracePeriod
437     )
438         public
439         Ownable()
440     {
441         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
442     }
443 
444     // ============ Owner-Only State-Changing Functions ============
445 
446     function grantAccess(
447         address who
448     )
449         external
450         onlyOwner
451     {
452         require(
453             block.timestamp < GRACE_PERIOD_EXPIRATION,
454             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
455         );
456 
457         emit AccessGranted(who);
458         authorized[who] = true;
459     }
460 }
461 
462 // File: contracts/lib/GeneralERC20.sol
463 
464 /**
465  * @title GeneralERC20
466  * @author dYdX
467  *
468  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
469  * that we dont automatically revert when calling non-compliant tokens that have no return value for
470  * transfer(), transferFrom(), or approve().
471  */
472 interface GeneralERC20 {
473     function totalSupply(
474     )
475         external
476         view
477         returns (uint256);
478 
479     function balanceOf(
480         address who
481     )
482         external
483         view
484         returns (uint256);
485 
486     function allowance(
487         address owner,
488         address spender
489     )
490         external
491         view
492         returns (uint256);
493 
494     function transfer(
495         address to,
496         uint256 value
497     )
498         external;
499 
500     function transferFrom(
501         address from,
502         address to,
503         uint256 value
504     )
505         external;
506 
507     function approve(
508         address spender,
509         uint256 value
510     )
511         external;
512 }
513 
514 // File: contracts/lib/TokenInteract.sol
515 
516 /**
517  * @title TokenInteract
518  * @author dYdX
519  *
520  * This library contains basic functions for interacting with ERC20 tokens
521  */
522 library TokenInteract {
523     function balanceOf(
524         address token,
525         address owner
526     )
527         internal
528         view
529         returns (uint256)
530     {
531         return GeneralERC20(token).balanceOf(owner);
532     }
533 
534     function allowance(
535         address token,
536         address owner,
537         address spender
538     )
539         internal
540         view
541         returns (uint256)
542     {
543         return GeneralERC20(token).allowance(owner, spender);
544     }
545 
546     function approve(
547         address token,
548         address spender,
549         uint256 amount
550     )
551         internal
552     {
553         GeneralERC20(token).approve(spender, amount);
554 
555         require(
556             checkSuccess(),
557             "TokenInteract#approve: Approval failed"
558         );
559     }
560 
561     function transfer(
562         address token,
563         address to,
564         uint256 amount
565     )
566         internal
567     {
568         address from = address(this);
569         if (
570             amount == 0
571             || from == to
572         ) {
573             return;
574         }
575 
576         GeneralERC20(token).transfer(to, amount);
577 
578         require(
579             checkSuccess(),
580             "TokenInteract#transfer: Transfer failed"
581         );
582     }
583 
584     function transferFrom(
585         address token,
586         address from,
587         address to,
588         uint256 amount
589     )
590         internal
591     {
592         if (
593             amount == 0
594             || from == to
595         ) {
596             return;
597         }
598 
599         GeneralERC20(token).transferFrom(from, to, amount);
600 
601         require(
602             checkSuccess(),
603             "TokenInteract#transferFrom: TransferFrom failed"
604         );
605     }
606 
607     // ============ Private Helper-Functions ============
608 
609     /**
610      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
611      * function returned 0 bytes or 32 bytes that are not all-zero.
612      */
613     function checkSuccess(
614     )
615         private
616         pure
617         returns (bool)
618     {
619         uint256 returnValue = 0;
620 
621         /* solium-disable-next-line security/no-inline-assembly */
622         assembly {
623             // check number of bytes returned from last function call
624             switch returndatasize
625 
626             // no bytes returned: assume success
627             case 0x0 {
628                 returnValue := 1
629             }
630 
631             // 32 bytes returned: check if non-zero
632             case 0x20 {
633                 // copy 32 bytes into scratch space
634                 returndatacopy(0x0, 0x0, 0x20)
635 
636                 // load those bytes into returnValue
637                 returnValue := mload(0x0)
638             }
639 
640             // not sure what was returned: dont mark as success
641             default { }
642         }
643 
644         return returnValue != 0;
645     }
646 }
647 
648 // File: contracts/margin/TokenProxy.sol
649 
650 /**
651  * @title TokenProxy
652  * @author dYdX
653  *
654  * Used to transfer tokens between addresses which have set allowance on this contract.
655  */
656 contract TokenProxy is StaticAccessControlled {
657     using SafeMath for uint256;
658 
659     // ============ Constructor ============
660 
661     constructor(
662         uint256 gracePeriod
663     )
664         public
665         StaticAccessControlled(gracePeriod)
666     {}
667 
668     // ============ Authorized-Only State Changing Functions ============
669 
670     /**
671      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
672      *
673      * @param  token  The address of the ERC20 token
674      * @param  from   The address to transfer token from
675      * @param  to     The address to transfer tokens to
676      * @param  value  The number of tokens to transfer
677      */
678     function transferTokens(
679         address token,
680         address from,
681         address to,
682         uint256 value
683     )
684         external
685         requiresAuthorization
686     {
687         TokenInteract.transferFrom(
688             token,
689             from,
690             to,
691             value
692         );
693     }
694 
695     // ============ Public Constant Functions ============
696 
697     /**
698      * Getter function to get the amount of token that the proxy is able to move for a particular
699      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
700      *
701      * @param  who    The owner of the tokens
702      * @param  token  The address of the ERC20 token
703      * @return        The number of tokens able to be moved by the proxy from the address specified
704      */
705     function available(
706         address who,
707         address token
708     )
709         external
710         view
711         returns (uint256)
712     {
713         return Math.min256(
714             TokenInteract.allowance(token, who, address(this)),
715             TokenInteract.balanceOf(token, who)
716         );
717     }
718 }
719 
720 // File: contracts/margin/Vault.sol
721 
722 /**
723  * @title Vault
724  * @author dYdX
725  *
726  * Holds and transfers tokens in vaults denominated by id
727  *
728  * Vault only supports ERC20 tokens, and will not accept any tokens that require
729  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
730  */
731 contract Vault is StaticAccessControlled
732 {
733     using SafeMath for uint256;
734 
735     // ============ Events ============
736 
737     event ExcessTokensWithdrawn(
738         address indexed token,
739         address indexed to,
740         address caller
741     );
742 
743     // ============ State Variables ============
744 
745     // Address of the TokenProxy contract. Used for moving tokens.
746     address public TOKEN_PROXY;
747 
748     // Map from vault ID to map from token address to amount of that token attributed to the
749     // particular vault ID.
750     mapping (bytes32 => mapping (address => uint256)) public balances;
751 
752     // Map from token address to total amount of that token attributed to some account.
753     mapping (address => uint256) public totalBalances;
754 
755     // ============ Constructor ============
756 
757     constructor(
758         address proxy,
759         uint256 gracePeriod
760     )
761         public
762         StaticAccessControlled(gracePeriod)
763     {
764         TOKEN_PROXY = proxy;
765     }
766 
767     // ============ Owner-Only State-Changing Functions ============
768 
769     /**
770      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
771      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
772      * will be accounted for and will not be withdrawable by this function.
773      *
774      * @param  token  ERC20 token address
775      * @param  to     Address to transfer tokens to
776      * @return        Amount of tokens withdrawn
777      */
778     function withdrawExcessToken(
779         address token,
780         address to
781     )
782         external
783         onlyOwner
784         returns (uint256)
785     {
786         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
787         uint256 accountedBalance = totalBalances[token];
788         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
789 
790         require(
791             withdrawableBalance != 0,
792             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
793         );
794 
795         TokenInteract.transfer(token, to, withdrawableBalance);
796 
797         emit ExcessTokensWithdrawn(token, to, msg.sender);
798 
799         return withdrawableBalance;
800     }
801 
802     // ============ Authorized-Only State-Changing Functions ============
803 
804     /**
805      * Transfers tokens from an address (that has approved the proxy) to the vault.
806      *
807      * @param  id      The vault which will receive the tokens
808      * @param  token   ERC20 token address
809      * @param  from    Address from which the tokens will be taken
810      * @param  amount  Number of the token to be sent
811      */
812     function transferToVault(
813         bytes32 id,
814         address token,
815         address from,
816         uint256 amount
817     )
818         external
819         requiresAuthorization
820     {
821         // First send tokens to this contract
822         TokenProxy(TOKEN_PROXY).transferTokens(
823             token,
824             from,
825             address(this),
826             amount
827         );
828 
829         // Then increment balances
830         balances[id][token] = balances[id][token].add(amount);
831         totalBalances[token] = totalBalances[token].add(amount);
832 
833         // This should always be true. If not, something is very wrong
834         assert(totalBalances[token] >= balances[id][token]);
835 
836         validateBalance(token);
837     }
838 
839     /**
840      * Transfers a certain amount of funds to an address.
841      *
842      * @param  id      The vault from which to send the tokens
843      * @param  token   ERC20 token address
844      * @param  to      Address to transfer tokens to
845      * @param  amount  Number of the token to be sent
846      */
847     function transferFromVault(
848         bytes32 id,
849         address token,
850         address to,
851         uint256 amount
852     )
853         external
854         requiresAuthorization
855     {
856         // Next line also asserts that (balances[id][token] >= amount);
857         balances[id][token] = balances[id][token].sub(amount);
858 
859         // Next line also asserts that (totalBalances[token] >= amount);
860         totalBalances[token] = totalBalances[token].sub(amount);
861 
862         // This should always be true. If not, something is very wrong
863         assert(totalBalances[token] >= balances[id][token]);
864 
865         // Do the sending
866         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
867 
868         // Final validation
869         validateBalance(token);
870     }
871 
872     // ============ Private Helper-Functions ============
873 
874     /**
875      * Verifies that this contract is in control of at least as many tokens as accounted for
876      *
877      * @param  token  Address of ERC20 token
878      */
879     function validateBalance(
880         address token
881     )
882         private
883         view
884     {
885         // The actual balance could be greater than totalBalances[token] because anyone
886         // can send tokens to the contract's address which cannot be accounted for
887         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
888     }
889 }
890 
891 // File: contracts/lib/ReentrancyGuard.sol
892 
893 /**
894  * @title ReentrancyGuard
895  * @author dYdX
896  *
897  * Optimized version of the well-known ReentrancyGuard contract
898  */
899 contract ReentrancyGuard {
900     uint256 private _guardCounter = 1;
901 
902     modifier nonReentrant() {
903         uint256 localCounter = _guardCounter + 1;
904         _guardCounter = localCounter;
905         _;
906         require(
907             _guardCounter == localCounter,
908             "Reentrancy check failure"
909         );
910     }
911 }
912 
913 // File: openzeppelin-solidity/contracts/AddressUtils.sol
914 
915 /**
916  * Utility library of inline functions on addresses
917  */
918 library AddressUtils {
919 
920   /**
921    * Returns whether the target address is a contract
922    * @dev This function will return false if invoked during the constructor of a contract,
923    * as the code is not actually created until after the constructor finishes.
924    * @param _addr address to check
925    * @return whether the target address is a contract
926    */
927   function isContract(address _addr) internal view returns (bool) {
928     uint256 size;
929     // XXX Currently there is no better way to check if there is a contract in an address
930     // than to check the size of the code at that address.
931     // See https://ethereum.stackexchange.com/a/14016/36603
932     // for more details about how this works.
933     // TODO Check this again before the Serenity release, because all addresses will be
934     // contracts then.
935     // solium-disable-next-line security/no-inline-assembly
936     assembly { size := extcodesize(_addr) }
937     return size > 0;
938   }
939 
940 }
941 
942 // File: contracts/lib/Fraction.sol
943 
944 /**
945  * @title Fraction
946  * @author dYdX
947  *
948  * This library contains implementations for fraction structs.
949  */
950 library Fraction {
951     struct Fraction128 {
952         uint128 num;
953         uint128 den;
954     }
955 }
956 
957 // File: contracts/lib/FractionMath.sol
958 
959 /**
960  * @title FractionMath
961  * @author dYdX
962  *
963  * This library contains safe math functions for manipulating fractions.
964  */
965 library FractionMath {
966     using SafeMath for uint256;
967     using SafeMath for uint128;
968 
969     /**
970      * Returns a Fraction128 that is equal to a + b
971      *
972      * @param  a  The first Fraction128
973      * @param  b  The second Fraction128
974      * @return    The result (sum)
975      */
976     function add(
977         Fraction.Fraction128 memory a,
978         Fraction.Fraction128 memory b
979     )
980         internal
981         pure
982         returns (Fraction.Fraction128 memory)
983     {
984         uint256 left = a.num.mul(b.den);
985         uint256 right = b.num.mul(a.den);
986         uint256 denominator = a.den.mul(b.den);
987 
988         // if left + right overflows, prevent overflow
989         if (left + right < left) {
990             left = left.div(2);
991             right = right.div(2);
992             denominator = denominator.div(2);
993         }
994 
995         return bound(left.add(right), denominator);
996     }
997 
998     /**
999      * Returns a Fraction128 that is equal to a - (1/2)^d
1000      *
1001      * @param  a  The Fraction128
1002      * @param  d  The power of (1/2)
1003      * @return    The result
1004      */
1005     function sub1Over(
1006         Fraction.Fraction128 memory a,
1007         uint128 d
1008     )
1009         internal
1010         pure
1011         returns (Fraction.Fraction128 memory)
1012     {
1013         if (a.den % d == 0) {
1014             return bound(
1015                 a.num.sub(a.den.div(d)),
1016                 a.den
1017             );
1018         }
1019         return bound(
1020             a.num.mul(d).sub(a.den),
1021             a.den.mul(d)
1022         );
1023     }
1024 
1025     /**
1026      * Returns a Fraction128 that is equal to a / d
1027      *
1028      * @param  a  The first Fraction128
1029      * @param  d  The divisor
1030      * @return    The result (quotient)
1031      */
1032     function div(
1033         Fraction.Fraction128 memory a,
1034         uint128 d
1035     )
1036         internal
1037         pure
1038         returns (Fraction.Fraction128 memory)
1039     {
1040         if (a.num % d == 0) {
1041             return bound(
1042                 a.num.div(d),
1043                 a.den
1044             );
1045         }
1046         return bound(
1047             a.num,
1048             a.den.mul(d)
1049         );
1050     }
1051 
1052     /**
1053      * Returns a Fraction128 that is equal to a * b.
1054      *
1055      * @param  a  The first Fraction128
1056      * @param  b  The second Fraction128
1057      * @return    The result (product)
1058      */
1059     function mul(
1060         Fraction.Fraction128 memory a,
1061         Fraction.Fraction128 memory b
1062     )
1063         internal
1064         pure
1065         returns (Fraction.Fraction128 memory)
1066     {
1067         return bound(
1068             a.num.mul(b.num),
1069             a.den.mul(b.den)
1070         );
1071     }
1072 
1073     /**
1074      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
1075      *
1076      * @param  num  The numerator
1077      * @param  den  The denominator
1078      * @return      The Fraction128 that matches num/den most closely
1079      */
1080     /* solium-disable-next-line security/no-assign-params */
1081     function bound(
1082         uint256 num,
1083         uint256 den
1084     )
1085         internal
1086         pure
1087         returns (Fraction.Fraction128 memory)
1088     {
1089         uint256 max = num > den ? num : den;
1090         uint256 first128Bits = (max >> 128);
1091         if (first128Bits != 0) {
1092             first128Bits += 1;
1093             num /= first128Bits;
1094             den /= first128Bits;
1095         }
1096 
1097         assert(den != 0); // coverage-enable-line
1098         assert(den < 2**128);
1099         assert(num < 2**128);
1100 
1101         return Fraction.Fraction128({
1102             num: uint128(num),
1103             den: uint128(den)
1104         });
1105     }
1106 
1107     /**
1108      * Returns an in-memory copy of a Fraction128
1109      *
1110      * @param  a  The Fraction128 to copy
1111      * @return    A copy of the Fraction128
1112      */
1113     function copy(
1114         Fraction.Fraction128 memory a
1115     )
1116         internal
1117         pure
1118         returns (Fraction.Fraction128 memory)
1119     {
1120         validate(a);
1121         return Fraction.Fraction128({ num: a.num, den: a.den });
1122     }
1123 
1124     // ============ Private Helper-Functions ============
1125 
1126     /**
1127      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
1128      *
1129      * @param  a  The Fraction128 to validate
1130      */
1131     function validate(
1132         Fraction.Fraction128 memory a
1133     )
1134         private
1135         pure
1136     {
1137         assert(a.den != 0); // coverage-enable-line
1138     }
1139 }
1140 
1141 // File: contracts/lib/Exponent.sol
1142 
1143 /**
1144  * @title Exponent
1145  * @author dYdX
1146  *
1147  * This library contains an implementation for calculating e^X for arbitrary fraction X
1148  */
1149 library Exponent {
1150     using SafeMath for uint256;
1151     using FractionMath for Fraction.Fraction128;
1152 
1153     // ============ Constants ============
1154 
1155     // 2**128 - 1
1156     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
1157 
1158     // Number of precomputed integers, X, for E^((1/2)^X)
1159     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
1160 
1161     // Number of precomputed integers, X, for E^X
1162     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
1163 
1164     // ============ Public Implementation Functions ============
1165 
1166     /**
1167      * Returns e^X for any fraction X
1168      *
1169      * @param  X                    The exponent
1170      * @param  precomputePrecision  Accuracy of precomputed terms
1171      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1172      * @return                      e^X
1173      */
1174     function exp(
1175         Fraction.Fraction128 memory X,
1176         uint256 precomputePrecision,
1177         uint256 maclaurinPrecision
1178     )
1179         internal
1180         pure
1181         returns (Fraction.Fraction128 memory)
1182     {
1183         require(
1184             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
1185             "Exponent#exp: Precompute precision over maximum"
1186         );
1187 
1188         Fraction.Fraction128 memory Xcopy = X.copy();
1189         if (Xcopy.num == 0) { // e^0 = 1
1190             return ONE();
1191         }
1192 
1193         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
1194         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
1195 
1196         // if X is less than 1, then just calculate X
1197         if (integerX == 0) {
1198             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
1199         }
1200 
1201         // get e^integerX
1202         Fraction.Fraction128 memory expOfInt =
1203             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
1204         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
1205             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
1206             integerX -= NUM_PRECOMPUTED_INTEGERS;
1207         }
1208 
1209         // multiply e^integerX by e^decimalX
1210         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
1211             num: Xcopy.num % Xcopy.den,
1212             den: Xcopy.den
1213         });
1214         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
1215     }
1216 
1217     /**
1218      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
1219      * Maclaurin Series approximation to reduce error.
1220      *
1221      * @param  X                    Exponent
1222      * @param  precomputePrecision  Accuracy of precomputed terms
1223      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1224      * @return                      e^X
1225      */
1226     function expHybrid(
1227         Fraction.Fraction128 memory X,
1228         uint256 precomputePrecision,
1229         uint256 maclaurinPrecision
1230     )
1231         internal
1232         pure
1233         returns (Fraction.Fraction128 memory)
1234     {
1235         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1236         assert(X.num < X.den);
1237         // will also throw if precomputePrecision is larger than the array length in getDenominator
1238 
1239         Fraction.Fraction128 memory Xtemp = X.copy();
1240         if (Xtemp.num == 0) { // e^0 = 1
1241             return ONE();
1242         }
1243 
1244         Fraction.Fraction128 memory result = ONE();
1245 
1246         uint256 d = 1; // 2^i
1247         for (uint256 i = 1; i <= precomputePrecision; i++) {
1248             d *= 2;
1249 
1250             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1251             if (d.mul(Xtemp.num) >= Xtemp.den) {
1252                 Xtemp = Xtemp.sub1Over(uint128(d));
1253                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1254             }
1255         }
1256         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1257     }
1258 
1259     /**
1260      * Returns e^X for any X, using Maclaurin Series approximation
1261      *
1262      * e^X = SUM(X^n / n!) for n >= 0
1263      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1264      *
1265      * @param  X           Exponent
1266      * @param  precision   Accuracy of Maclaurin terms
1267      * @return             e^X
1268      */
1269     function expMaclaurin(
1270         Fraction.Fraction128 memory X,
1271         uint256 precision
1272     )
1273         internal
1274         pure
1275         returns (Fraction.Fraction128 memory)
1276     {
1277         Fraction.Fraction128 memory Xcopy = X.copy();
1278         if (Xcopy.num == 0) { // e^0 = 1
1279             return ONE();
1280         }
1281 
1282         Fraction.Fraction128 memory result = ONE();
1283         Fraction.Fraction128 memory Xtemp = ONE();
1284         for (uint256 i = 1; i <= precision; i++) {
1285             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1286             result = result.add(Xtemp);
1287         }
1288         return result;
1289     }
1290 
1291     /**
1292      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1293      */
1294     function getPrecomputedEToTheHalfToThe(
1295         uint256 x
1296     )
1297         internal
1298         pure
1299         returns (Fraction.Fraction128 memory)
1300     {
1301         assert(x <= MAX_PRECOMPUTE_PRECISION);
1302 
1303         uint128 denominator = [
1304             125182886983370532117250726298150828301,
1305             206391688497133195273760705512282642279,
1306             265012173823417992016237332255925138361,
1307             300298134811882980317033350418940119802,
1308             319665700530617779809390163992561606014,
1309             329812979126047300897653247035862915816,
1310             335006777809430963166468914297166288162,
1311             337634268532609249517744113622081347950,
1312             338955731696479810470146282672867036734,
1313             339618401537809365075354109784799900812,
1314             339950222128463181389559457827561204959,
1315             340116253979683015278260491021941090650,
1316             340199300311581465057079429423749235412,
1317             340240831081268226777032180141478221816,
1318             340261598367316729254995498374473399540,
1319             340271982485676106947851156443492415142,
1320             340277174663693808406010255284800906112,
1321             340279770782412691177936847400746725466,
1322             340281068849199706686796915841848278311,
1323             340281717884450116236033378667952410919,
1324             340282042402539547492367191008339680733,
1325             340282204661700319870089970029119685699,
1326             340282285791309720262481214385569134454,
1327             340282326356121674011576912006427792656,
1328             340282346638529464274601981200276914173,
1329             340282356779733812753265346086924801364,
1330             340282361850336100329388676752133324799,
1331             340282364385637272451648746721404212564,
1332             340282365653287865596328444437856608255,
1333             340282366287113163939555716675618384724,
1334             340282366604025813553891209601455838559,
1335             340282366762482138471739420386372790954,
1336             340282366841710300958333641874363209044
1337         ][x];
1338         return Fraction.Fraction128({
1339             num: MAX_NUMERATOR,
1340             den: denominator
1341         });
1342     }
1343 
1344     /**
1345      * Returns a fraction roughly equaling E^(x) for integer x
1346      */
1347     function getPrecomputedEToThe(
1348         uint256 x
1349     )
1350         internal
1351         pure
1352         returns (Fraction.Fraction128 memory)
1353     {
1354         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1355 
1356         uint128 denominator = [
1357             340282366920938463463374607431768211455,
1358             125182886983370532117250726298150828301,
1359             46052210507670172419625860892627118820,
1360             16941661466271327126146327822211253888,
1361             6232488952727653950957829210887653621,
1362             2292804553036637136093891217529878878,
1363             843475657686456657683449904934172134,
1364             310297353591408453462393329342695980,
1365             114152017036184782947077973323212575,
1366             41994180235864621538772677139808695,
1367             15448795557622704876497742989562086,
1368             5683294276510101335127414470015662,
1369             2090767122455392675095471286328463,
1370             769150240628514374138961856925097,
1371             282954560699298259527814398449860,
1372             104093165666968799599694528310221,
1373             38293735615330848145349245349513,
1374             14087478058534870382224480725096,
1375             5182493555688763339001418388912,
1376             1906532833141383353974257736699,
1377             701374233231058797338605168652,
1378             258021160973090761055471434334,
1379             94920680509187392077350434438,
1380             34919366901332874995585576427,
1381             12846117181722897538509298435,
1382             4725822410035083116489797150,
1383             1738532907279185132707372378,
1384             639570514388029575350057932,
1385             235284843422800231081973821,
1386             86556456714490055457751527,
1387             31842340925906738090071268,
1388             11714142585413118080082437,
1389             4309392228124372433711936
1390         ][x];
1391         return Fraction.Fraction128({
1392             num: MAX_NUMERATOR,
1393             den: denominator
1394         });
1395     }
1396 
1397     // ============ Private Helper-Functions ============
1398 
1399     function ONE()
1400         private
1401         pure
1402         returns (Fraction.Fraction128 memory)
1403     {
1404         return Fraction.Fraction128({ num: 1, den: 1 });
1405     }
1406 }
1407 
1408 // File: contracts/lib/MathHelpers.sol
1409 
1410 /**
1411  * @title MathHelpers
1412  * @author dYdX
1413  *
1414  * This library helps with common math functions in Solidity
1415  */
1416 library MathHelpers {
1417     using SafeMath for uint256;
1418 
1419     /**
1420      * Calculates partial value given a numerator and denominator.
1421      *
1422      * @param  numerator    Numerator
1423      * @param  denominator  Denominator
1424      * @param  target       Value to calculate partial of
1425      * @return              target * numerator / denominator
1426      */
1427     function getPartialAmount(
1428         uint256 numerator,
1429         uint256 denominator,
1430         uint256 target
1431     )
1432         internal
1433         pure
1434         returns (uint256)
1435     {
1436         return numerator.mul(target).div(denominator);
1437     }
1438 
1439     /**
1440      * Calculates partial value given a numerator and denominator, rounded up.
1441      *
1442      * @param  numerator    Numerator
1443      * @param  denominator  Denominator
1444      * @param  target       Value to calculate partial of
1445      * @return              Rounded-up result of target * numerator / denominator
1446      */
1447     function getPartialAmountRoundedUp(
1448         uint256 numerator,
1449         uint256 denominator,
1450         uint256 target
1451     )
1452         internal
1453         pure
1454         returns (uint256)
1455     {
1456         return divisionRoundedUp(numerator.mul(target), denominator);
1457     }
1458 
1459     /**
1460      * Calculates division given a numerator and denominator, rounded up.
1461      *
1462      * @param  numerator    Numerator.
1463      * @param  denominator  Denominator.
1464      * @return              Rounded-up result of numerator / denominator
1465      */
1466     function divisionRoundedUp(
1467         uint256 numerator,
1468         uint256 denominator
1469     )
1470         internal
1471         pure
1472         returns (uint256)
1473     {
1474         assert(denominator != 0); // coverage-enable-line
1475         if (numerator == 0) {
1476             return 0;
1477         }
1478         return numerator.sub(1).div(denominator).add(1);
1479     }
1480 
1481     /**
1482      * Calculates and returns the maximum value for a uint256 in solidity
1483      *
1484      * @return  The maximum value for uint256
1485      */
1486     function maxUint256(
1487     )
1488         internal
1489         pure
1490         returns (uint256)
1491     {
1492         return 2 ** 256 - 1;
1493     }
1494 
1495     /**
1496      * Calculates and returns the maximum value for a uint256 in solidity
1497      *
1498      * @return  The maximum value for uint256
1499      */
1500     function maxUint32(
1501     )
1502         internal
1503         pure
1504         returns (uint32)
1505     {
1506         return 2 ** 32 - 1;
1507     }
1508 
1509     /**
1510      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1511      *
1512      * @param  n  The uint256 to get the number of bits in
1513      * @return    The number of bits in n
1514      */
1515     function getNumBits(
1516         uint256 n
1517     )
1518         internal
1519         pure
1520         returns (uint256)
1521     {
1522         uint256 first = 0;
1523         uint256 last = 256;
1524         while (first < last) {
1525             uint256 check = (first + last) / 2;
1526             if ((n >> check) == 0) {
1527                 last = check;
1528             } else {
1529                 first = check + 1;
1530             }
1531         }
1532         assert(first <= 256);
1533         return first;
1534     }
1535 }
1536 
1537 // File: contracts/margin/impl/InterestImpl.sol
1538 
1539 /**
1540  * @title InterestImpl
1541  * @author dYdX
1542  *
1543  * A library that calculates continuously compounded interest for principal, time period, and
1544  * interest rate.
1545  */
1546 library InterestImpl {
1547     using SafeMath for uint256;
1548     using FractionMath for Fraction.Fraction128;
1549 
1550     // ============ Constants ============
1551 
1552     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1553 
1554     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1555 
1556     uint256 constant MAXIMUM_EXPONENT = 80;
1557 
1558     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1559 
1560     // ============ Public Implementation Functions ============
1561 
1562     /**
1563      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1564      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1565      * I = P * e^(R*T)
1566      *
1567      * @param  principal           Principal of the interest calculation
1568      * @param  interestRate        Annual nominal interest percentage times 10**6.
1569      *                             (example: 5% = 5e6)
1570      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1571      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1572      */
1573     function getCompoundedInterest(
1574         uint256 principal,
1575         uint256 interestRate,
1576         uint256 secondsOfInterest
1577     )
1578         public
1579         pure
1580         returns (uint256)
1581     {
1582         uint256 numerator = interestRate.mul(secondsOfInterest);
1583         uint128 denominator = (10**8) * (365 * 1 days);
1584 
1585         // interestRate and secondsOfInterest should both be uint32
1586         assert(numerator < 2**128);
1587 
1588         // fraction representing (Rate * Time)
1589         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1590             num: uint128(numerator),
1591             den: denominator
1592         });
1593 
1594         // calculate e^(RT)
1595         Fraction.Fraction128 memory eToRT;
1596         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1597             // degenerate case: cap calculation
1598             eToRT = Fraction.Fraction128({
1599                 num: E_TO_MAXIUMUM_EXPONENT,
1600                 den: 1
1601             });
1602         } else {
1603             // normal case: calculate e^(RT)
1604             eToRT = Exponent.exp(
1605                 rt,
1606                 DEFAULT_PRECOMPUTE_PRECISION,
1607                 DEFAULT_MACLAURIN_PRECISION
1608             );
1609         }
1610 
1611         // e^X for positive X should be greater-than or equal to 1
1612         assert(eToRT.num >= eToRT.den);
1613 
1614         return safeMultiplyUint256ByFraction(principal, eToRT);
1615     }
1616 
1617     // ============ Private Helper-Functions ============
1618 
1619     /**
1620      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1621      * and denominator of f are less than 2**128.
1622      */
1623     function safeMultiplyUint256ByFraction(
1624         uint256 n,
1625         Fraction.Fraction128 memory f
1626     )
1627         private
1628         pure
1629         returns (uint256)
1630     {
1631         uint256 term1 = n.div(2 ** 128); // first 128 bits
1632         uint256 term2 = n % (2 ** 128); // second 128 bits
1633 
1634         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1635         if (term1 > 0) {
1636             term1 = term1.mul(f.num);
1637             uint256 numBits = MathHelpers.getNumBits(term1);
1638 
1639             // reduce rounding error by shifting all the way to the left before dividing
1640             term1 = MathHelpers.divisionRoundedUp(
1641                 term1 << (uint256(256).sub(numBits)),
1642                 f.den);
1643 
1644             // continue shifting or reduce shifting to get the right number
1645             if (numBits > 128) {
1646                 term1 = term1 << (numBits.sub(128));
1647             } else if (numBits < 128) {
1648                 term1 = term1 >> (uint256(128).sub(numBits));
1649             }
1650         }
1651 
1652         // calculates term2 = term2 * f
1653         term2 = MathHelpers.getPartialAmountRoundedUp(
1654             f.num,
1655             f.den,
1656             term2
1657         );
1658 
1659         return term1.add(term2);
1660     }
1661 }
1662 
1663 // File: contracts/margin/impl/MarginState.sol
1664 
1665 /**
1666  * @title MarginState
1667  * @author dYdX
1668  *
1669  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1670  */
1671 library MarginState {
1672     struct State {
1673         // Address of the Vault contract
1674         address VAULT;
1675 
1676         // Address of the TokenProxy contract
1677         address TOKEN_PROXY;
1678 
1679         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1680         // already been filled.
1681         mapping (bytes32 => uint256) loanFills;
1682 
1683         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1684         // already been canceled.
1685         mapping (bytes32 => uint256) loanCancels;
1686 
1687         // Mapping from positionId -> Position, which stores all the open margin positions.
1688         mapping (bytes32 => MarginCommon.Position) positions;
1689 
1690         // Mapping from positionId -> bool, which stores whether the position has previously been
1691         // open, but is now closed.
1692         mapping (bytes32 => bool) closedPositions;
1693 
1694         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1695         // ever been repaid to the lender for each position. Does not reset.
1696         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1697     }
1698 }
1699 
1700 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1701 
1702 /**
1703  * @title LoanOwner
1704  * @author dYdX
1705  *
1706  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1707  *
1708  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1709  *       to these functions
1710  */
1711 interface LoanOwner {
1712 
1713     // ============ Public Interface functions ============
1714 
1715     /**
1716      * Function a contract must implement in order to receive ownership of a loan sell via the
1717      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1718      *
1719      * @param  from        Address of the previous owner
1720      * @param  positionId  Unique ID of the position
1721      * @return             This address to keep ownership, a different address to pass-on ownership
1722      */
1723     function receiveLoanOwnership(
1724         address from,
1725         bytes32 positionId
1726     )
1727         external
1728         /* onlyMargin */
1729         returns (address);
1730 }
1731 
1732 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1733 
1734 /**
1735  * @title PositionOwner
1736  * @author dYdX
1737  *
1738  * Interface that smart contracts must implement in order to own position on behalf of other
1739  * accounts
1740  *
1741  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1742  *       to these functions
1743  */
1744 interface PositionOwner {
1745 
1746     // ============ Public Interface functions ============
1747 
1748     /**
1749      * Function a contract must implement in order to receive ownership of a position via the
1750      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1751      *
1752      * @param  from        Address of the previous owner
1753      * @param  positionId  Unique ID of the position
1754      * @return             This address to keep ownership, a different address to pass-on ownership
1755      */
1756     function receivePositionOwnership(
1757         address from,
1758         bytes32 positionId
1759     )
1760         external
1761         /* onlyMargin */
1762         returns (address);
1763 }
1764 
1765 // File: contracts/margin/impl/TransferInternal.sol
1766 
1767 /**
1768  * @title TransferInternal
1769  * @author dYdX
1770  *
1771  * This library contains the implementation for transferring ownership of loans and positions.
1772  */
1773 library TransferInternal {
1774 
1775     // ============ Events ============
1776 
1777     /**
1778      * Ownership of a loan was transferred to a new address
1779      */
1780     event LoanTransferred(
1781         bytes32 indexed positionId,
1782         address indexed from,
1783         address indexed to
1784     );
1785 
1786     /**
1787      * Ownership of a postion was transferred to a new address
1788      */
1789     event PositionTransferred(
1790         bytes32 indexed positionId,
1791         address indexed from,
1792         address indexed to
1793     );
1794 
1795     // ============ Internal Implementation Functions ============
1796 
1797     /**
1798      * Returns either the address of the new loan owner, or the address to which they wish to
1799      * pass ownership of the loan. This function does not actually set the state of the position
1800      *
1801      * @param  positionId  The Unique ID of the position
1802      * @param  oldOwner    The previous owner of the loan
1803      * @param  newOwner    The intended owner of the loan
1804      * @return             The address that the intended owner wishes to assign the loan to (may be
1805      *                     the same as the intended owner).
1806      */
1807     function grantLoanOwnership(
1808         bytes32 positionId,
1809         address oldOwner,
1810         address newOwner
1811     )
1812         internal
1813         returns (address)
1814     {
1815         // log event except upon position creation
1816         if (oldOwner != address(0)) {
1817             emit LoanTransferred(positionId, oldOwner, newOwner);
1818         }
1819 
1820         if (AddressUtils.isContract(newOwner)) {
1821             address nextOwner =
1822                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1823             if (nextOwner != newOwner) {
1824                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1825             }
1826         }
1827 
1828         require(
1829             newOwner != address(0),
1830             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1831         );
1832 
1833         return newOwner;
1834     }
1835 
1836     /**
1837      * Returns either the address of the new position owner, or the address to which they wish to
1838      * pass ownership of the position. This function does not actually set the state of the position
1839      *
1840      * @param  positionId  The Unique ID of the position
1841      * @param  oldOwner    The previous owner of the position
1842      * @param  newOwner    The intended owner of the position
1843      * @return             The address that the intended owner wishes to assign the position to (may
1844      *                     be the same as the intended owner).
1845      */
1846     function grantPositionOwnership(
1847         bytes32 positionId,
1848         address oldOwner,
1849         address newOwner
1850     )
1851         internal
1852         returns (address)
1853     {
1854         // log event except upon position creation
1855         if (oldOwner != address(0)) {
1856             emit PositionTransferred(positionId, oldOwner, newOwner);
1857         }
1858 
1859         if (AddressUtils.isContract(newOwner)) {
1860             address nextOwner =
1861                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1862             if (nextOwner != newOwner) {
1863                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1864             }
1865         }
1866 
1867         require(
1868             newOwner != address(0),
1869             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1870         );
1871 
1872         return newOwner;
1873     }
1874 }
1875 
1876 // File: contracts/lib/TimestampHelper.sol
1877 
1878 /**
1879  * @title TimestampHelper
1880  * @author dYdX
1881  *
1882  * Helper to get block timestamps in other formats
1883  */
1884 library TimestampHelper {
1885     function getBlockTimestamp32()
1886         internal
1887         view
1888         returns (uint32)
1889     {
1890         // Should not still be in-use in the year 2106
1891         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1892 
1893         assert(block.timestamp > 0);
1894 
1895         return uint32(block.timestamp);
1896     }
1897 }
1898 
1899 // File: contracts/margin/impl/MarginCommon.sol
1900 
1901 /**
1902  * @title MarginCommon
1903  * @author dYdX
1904  *
1905  * This library contains common functions for implementations of public facing Margin functions
1906  */
1907 library MarginCommon {
1908     using SafeMath for uint256;
1909 
1910     // ============ Structs ============
1911 
1912     struct Position {
1913         address owedToken;       // Immutable
1914         address heldToken;       // Immutable
1915         address lender;
1916         address owner;
1917         uint256 principal;
1918         uint256 requiredDeposit;
1919         uint32  callTimeLimit;   // Immutable
1920         uint32  startTimestamp;  // Immutable, cannot be 0
1921         uint32  callTimestamp;
1922         uint32  maxDuration;     // Immutable
1923         uint32  interestRate;    // Immutable
1924         uint32  interestPeriod;  // Immutable
1925     }
1926 
1927     struct LoanOffering {
1928         address   owedToken;
1929         address   heldToken;
1930         address   payer;
1931         address   owner;
1932         address   taker;
1933         address   positionOwner;
1934         address   feeRecipient;
1935         address   lenderFeeToken;
1936         address   takerFeeToken;
1937         LoanRates rates;
1938         uint256   expirationTimestamp;
1939         uint32    callTimeLimit;
1940         uint32    maxDuration;
1941         uint256   salt;
1942         bytes32   loanHash;
1943         bytes     signature;
1944     }
1945 
1946     struct LoanRates {
1947         uint256 maxAmount;
1948         uint256 minAmount;
1949         uint256 minHeldToken;
1950         uint256 lenderFee;
1951         uint256 takerFee;
1952         uint32  interestRate;
1953         uint32  interestPeriod;
1954     }
1955 
1956     // ============ Internal Implementation Functions ============
1957 
1958     function storeNewPosition(
1959         MarginState.State storage state,
1960         bytes32 positionId,
1961         Position memory position,
1962         address loanPayer
1963     )
1964         internal
1965     {
1966         assert(!positionHasExisted(state, positionId));
1967         assert(position.owedToken != address(0));
1968         assert(position.heldToken != address(0));
1969         assert(position.owedToken != position.heldToken);
1970         assert(position.owner != address(0));
1971         assert(position.lender != address(0));
1972         assert(position.maxDuration != 0);
1973         assert(position.interestPeriod <= position.maxDuration);
1974         assert(position.callTimestamp == 0);
1975         assert(position.requiredDeposit == 0);
1976 
1977         state.positions[positionId].owedToken = position.owedToken;
1978         state.positions[positionId].heldToken = position.heldToken;
1979         state.positions[positionId].principal = position.principal;
1980         state.positions[positionId].callTimeLimit = position.callTimeLimit;
1981         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
1982         state.positions[positionId].maxDuration = position.maxDuration;
1983         state.positions[positionId].interestRate = position.interestRate;
1984         state.positions[positionId].interestPeriod = position.interestPeriod;
1985 
1986         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
1987             positionId,
1988             (position.owner != msg.sender) ? msg.sender : address(0),
1989             position.owner
1990         );
1991 
1992         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
1993             positionId,
1994             (position.lender != loanPayer) ? loanPayer : address(0),
1995             position.lender
1996         );
1997     }
1998 
1999     function getPositionIdFromNonce(
2000         uint256 nonce
2001     )
2002         internal
2003         view
2004         returns (bytes32)
2005     {
2006         return keccak256(abi.encodePacked(msg.sender, nonce));
2007     }
2008 
2009     function getUnavailableLoanOfferingAmountImpl(
2010         MarginState.State storage state,
2011         bytes32 loanHash
2012     )
2013         internal
2014         view
2015         returns (uint256)
2016     {
2017         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
2018     }
2019 
2020     function cleanupPosition(
2021         MarginState.State storage state,
2022         bytes32 positionId
2023     )
2024         internal
2025     {
2026         delete state.positions[positionId];
2027         state.closedPositions[positionId] = true;
2028     }
2029 
2030     function calculateOwedAmount(
2031         Position storage position,
2032         uint256 closeAmount,
2033         uint256 endTimestamp
2034     )
2035         internal
2036         view
2037         returns (uint256)
2038     {
2039         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
2040 
2041         return InterestImpl.getCompoundedInterest(
2042             closeAmount,
2043             position.interestRate,
2044             timeElapsed
2045         );
2046     }
2047 
2048     /**
2049      * Calculates time elapsed rounded up to the nearest interestPeriod
2050      */
2051     function calculateEffectiveTimeElapsed(
2052         Position storage position,
2053         uint256 timestamp
2054     )
2055         internal
2056         view
2057         returns (uint256)
2058     {
2059         uint256 elapsed = timestamp.sub(position.startTimestamp);
2060 
2061         // round up to interestPeriod
2062         uint256 period = position.interestPeriod;
2063         if (period > 1) {
2064             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
2065         }
2066 
2067         // bound by maxDuration
2068         return Math.min256(
2069             elapsed,
2070             position.maxDuration
2071         );
2072     }
2073 
2074     function calculateLenderAmountForIncreasePosition(
2075         Position storage position,
2076         uint256 principalToAdd,
2077         uint256 endTimestamp
2078     )
2079         internal
2080         view
2081         returns (uint256)
2082     {
2083         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
2084 
2085         return InterestImpl.getCompoundedInterest(
2086             principalToAdd,
2087             position.interestRate,
2088             timeElapsed
2089         );
2090     }
2091 
2092     function getLoanOfferingHash(
2093         LoanOffering loanOffering
2094     )
2095         internal
2096         view
2097         returns (bytes32)
2098     {
2099         return keccak256(
2100             abi.encodePacked(
2101                 address(this),
2102                 loanOffering.owedToken,
2103                 loanOffering.heldToken,
2104                 loanOffering.payer,
2105                 loanOffering.owner,
2106                 loanOffering.taker,
2107                 loanOffering.positionOwner,
2108                 loanOffering.feeRecipient,
2109                 loanOffering.lenderFeeToken,
2110                 loanOffering.takerFeeToken,
2111                 getValuesHash(loanOffering)
2112             )
2113         );
2114     }
2115 
2116     function getPositionBalanceImpl(
2117         MarginState.State storage state,
2118         bytes32 positionId
2119     )
2120         internal
2121         view
2122         returns(uint256)
2123     {
2124         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
2125     }
2126 
2127     function containsPositionImpl(
2128         MarginState.State storage state,
2129         bytes32 positionId
2130     )
2131         internal
2132         view
2133         returns (bool)
2134     {
2135         return state.positions[positionId].startTimestamp != 0;
2136     }
2137 
2138     function positionHasExisted(
2139         MarginState.State storage state,
2140         bytes32 positionId
2141     )
2142         internal
2143         view
2144         returns (bool)
2145     {
2146         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
2147     }
2148 
2149     function getPositionFromStorage(
2150         MarginState.State storage state,
2151         bytes32 positionId
2152     )
2153         internal
2154         view
2155         returns (Position storage)
2156     {
2157         Position storage position = state.positions[positionId];
2158 
2159         require(
2160             position.startTimestamp != 0,
2161             "MarginCommon#getPositionFromStorage: The position does not exist"
2162         );
2163 
2164         return position;
2165     }
2166 
2167     // ============ Private Helper-Functions ============
2168 
2169     /**
2170      * Calculates time elapsed rounded down to the nearest interestPeriod
2171      */
2172     function calculateEffectiveTimeElapsedForNewLender(
2173         Position storage position,
2174         uint256 timestamp
2175     )
2176         private
2177         view
2178         returns (uint256)
2179     {
2180         uint256 elapsed = timestamp.sub(position.startTimestamp);
2181 
2182         // round down to interestPeriod
2183         uint256 period = position.interestPeriod;
2184         if (period > 1) {
2185             elapsed = elapsed.div(period).mul(period);
2186         }
2187 
2188         // bound by maxDuration
2189         return Math.min256(
2190             elapsed,
2191             position.maxDuration
2192         );
2193     }
2194 
2195     function getValuesHash(
2196         LoanOffering loanOffering
2197     )
2198         private
2199         pure
2200         returns (bytes32)
2201     {
2202         return keccak256(
2203             abi.encodePacked(
2204                 loanOffering.rates.maxAmount,
2205                 loanOffering.rates.minAmount,
2206                 loanOffering.rates.minHeldToken,
2207                 loanOffering.rates.lenderFee,
2208                 loanOffering.rates.takerFee,
2209                 loanOffering.expirationTimestamp,
2210                 loanOffering.salt,
2211                 loanOffering.callTimeLimit,
2212                 loanOffering.maxDuration,
2213                 loanOffering.rates.interestRate,
2214                 loanOffering.rates.interestPeriod
2215             )
2216         );
2217     }
2218 }
2219 
2220 // File: contracts/margin/interfaces/PayoutRecipient.sol
2221 
2222 /**
2223  * @title PayoutRecipient
2224  * @author dYdX
2225  *
2226  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2227  * closePosition transaction.
2228  *
2229  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2230  *       to these functions
2231  */
2232 interface PayoutRecipient {
2233 
2234     // ============ Public Interface functions ============
2235 
2236     /**
2237      * Function a contract must implement in order to receive payout from being the payoutRecipient
2238      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2239      *
2240      * @param  positionId         Unique ID of the position
2241      * @param  closeAmount        Amount of the position that was closed
2242      * @param  closer             Address of the account or contract that closed the position
2243      * @param  positionOwner      Address of the owner of the position
2244      * @param  heldToken          Address of the ERC20 heldToken
2245      * @param  payout             Number of tokens received from the payout
2246      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2247      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2248      * @return                    True if approved by the receiver
2249      */
2250     function receiveClosePositionPayout(
2251         bytes32 positionId,
2252         uint256 closeAmount,
2253         address closer,
2254         address positionOwner,
2255         address heldToken,
2256         uint256 payout,
2257         uint256 totalHeldToken,
2258         bool    payoutInHeldToken
2259     )
2260         external
2261         /* onlyMargin */
2262         returns (bool);
2263 }
2264 
2265 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2266 
2267 /**
2268  * @title CloseLoanDelegator
2269  * @author dYdX
2270  *
2271  * Interface that smart contracts must implement in order to let other addresses close a loan
2272  * owned by the smart contract.
2273  *
2274  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2275  *       to these functions
2276  */
2277 interface CloseLoanDelegator {
2278 
2279     // ============ Public Interface functions ============
2280 
2281     /**
2282      * Function a contract must implement in order to let other addresses call
2283      * closeWithoutCounterparty().
2284      *
2285      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2286      * either revert the entire transaction or that (at most) the specified amount of the loan was
2287      * successfully closed.
2288      *
2289      * @param  closer           Address of the caller of closeWithoutCounterparty()
2290      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2291      * @param  positionId       Unique ID of the position
2292      * @param  requestedAmount  Requested principal amount of the loan to close
2293      * @return                  1) This address to accept, a different address to ask that contract
2294      *                          2) The maximum amount that this contract is allowing
2295      */
2296     function closeLoanOnBehalfOf(
2297         address closer,
2298         address payoutRecipient,
2299         bytes32 positionId,
2300         uint256 requestedAmount
2301     )
2302         external
2303         /* onlyMargin */
2304         returns (address, uint256);
2305 }
2306 
2307 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2308 
2309 /**
2310  * @title ClosePositionDelegator
2311  * @author dYdX
2312  *
2313  * Interface that smart contracts must implement in order to let other addresses close a position
2314  * owned by the smart contract, allowing more complex logic to control positions.
2315  *
2316  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2317  *       to these functions
2318  */
2319 interface ClosePositionDelegator {
2320 
2321     // ============ Public Interface functions ============
2322 
2323     /**
2324      * Function a contract must implement in order to let other addresses call closePosition().
2325      *
2326      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2327      * either revert the entire transaction or that (at-most) the specified amount of the position
2328      * was successfully closed.
2329      *
2330      * @param  closer           Address of the caller of the closePosition() function
2331      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2332      * @param  positionId       Unique ID of the position
2333      * @param  requestedAmount  Requested principal amount of the position to close
2334      * @return                  1) This address to accept, a different address to ask that contract
2335      *                          2) The maximum amount that this contract is allowing
2336      */
2337     function closeOnBehalfOf(
2338         address closer,
2339         address payoutRecipient,
2340         bytes32 positionId,
2341         uint256 requestedAmount
2342     )
2343         external
2344         /* onlyMargin */
2345         returns (address, uint256);
2346 }
2347 
2348 // File: contracts/margin/impl/ClosePositionShared.sol
2349 
2350 /**
2351  * @title ClosePositionShared
2352  * @author dYdX
2353  *
2354  * This library contains shared functionality between ClosePositionImpl and
2355  * CloseWithoutCounterpartyImpl
2356  */
2357 library ClosePositionShared {
2358     using SafeMath for uint256;
2359 
2360     // ============ Structs ============
2361 
2362     struct CloseTx {
2363         bytes32 positionId;
2364         uint256 originalPrincipal;
2365         uint256 closeAmount;
2366         uint256 owedTokenOwed;
2367         uint256 startingHeldTokenBalance;
2368         uint256 availableHeldToken;
2369         address payoutRecipient;
2370         address owedToken;
2371         address heldToken;
2372         address positionOwner;
2373         address positionLender;
2374         address exchangeWrapper;
2375         bool    payoutInHeldToken;
2376     }
2377 
2378     // ============ Internal Implementation Functions ============
2379 
2380     function closePositionStateUpdate(
2381         MarginState.State storage state,
2382         CloseTx memory transaction
2383     )
2384         internal
2385     {
2386         // Delete the position, or just decrease the principal
2387         if (transaction.closeAmount == transaction.originalPrincipal) {
2388             MarginCommon.cleanupPosition(state, transaction.positionId);
2389         } else {
2390             assert(
2391                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2392             );
2393             state.positions[transaction.positionId].principal =
2394                 transaction.originalPrincipal.sub(transaction.closeAmount);
2395         }
2396     }
2397 
2398     function sendTokensToPayoutRecipient(
2399         MarginState.State storage state,
2400         ClosePositionShared.CloseTx memory transaction,
2401         uint256 buybackCostInHeldToken,
2402         uint256 receivedOwedToken
2403     )
2404         internal
2405         returns (uint256)
2406     {
2407         uint256 payout;
2408 
2409         if (transaction.payoutInHeldToken) {
2410             // Send remaining heldToken to payoutRecipient
2411             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2412 
2413             Vault(state.VAULT).transferFromVault(
2414                 transaction.positionId,
2415                 transaction.heldToken,
2416                 transaction.payoutRecipient,
2417                 payout
2418             );
2419         } else {
2420             assert(transaction.exchangeWrapper != address(0));
2421 
2422             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2423 
2424             TokenProxy(state.TOKEN_PROXY).transferTokens(
2425                 transaction.owedToken,
2426                 transaction.exchangeWrapper,
2427                 transaction.payoutRecipient,
2428                 payout
2429             );
2430         }
2431 
2432         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2433             require(
2434                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2435                     transaction.positionId,
2436                     transaction.closeAmount,
2437                     msg.sender,
2438                     transaction.positionOwner,
2439                     transaction.heldToken,
2440                     payout,
2441                     transaction.availableHeldToken,
2442                     transaction.payoutInHeldToken
2443                 ),
2444                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2445             );
2446         }
2447 
2448         // The ending heldToken balance of the vault should be the starting heldToken balance
2449         // minus the available heldToken amount
2450         assert(
2451             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2452             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2453         );
2454 
2455         return payout;
2456     }
2457 
2458     function createCloseTx(
2459         MarginState.State storage state,
2460         bytes32 positionId,
2461         uint256 requestedAmount,
2462         address payoutRecipient,
2463         address exchangeWrapper,
2464         bool payoutInHeldToken,
2465         bool isWithoutCounterparty
2466     )
2467         internal
2468         returns (CloseTx memory)
2469     {
2470         // Validate
2471         require(
2472             payoutRecipient != address(0),
2473             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2474         );
2475         require(
2476             requestedAmount > 0,
2477             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2478         );
2479 
2480         MarginCommon.Position storage position =
2481             MarginCommon.getPositionFromStorage(state, positionId);
2482 
2483         uint256 closeAmount = getApprovedAmount(
2484             position,
2485             positionId,
2486             requestedAmount,
2487             payoutRecipient,
2488             isWithoutCounterparty
2489         );
2490 
2491         return parseCloseTx(
2492             state,
2493             position,
2494             positionId,
2495             closeAmount,
2496             payoutRecipient,
2497             exchangeWrapper,
2498             payoutInHeldToken,
2499             isWithoutCounterparty
2500         );
2501     }
2502 
2503     // ============ Private Helper-Functions ============
2504 
2505     function getApprovedAmount(
2506         MarginCommon.Position storage position,
2507         bytes32 positionId,
2508         uint256 requestedAmount,
2509         address payoutRecipient,
2510         bool requireLenderApproval
2511     )
2512         private
2513         returns (uint256)
2514     {
2515         // Ensure enough principal
2516         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2517 
2518         // Ensure owner consent
2519         allowedAmount = closePositionOnBehalfOfRecurse(
2520             position.owner,
2521             msg.sender,
2522             payoutRecipient,
2523             positionId,
2524             allowedAmount
2525         );
2526 
2527         // Ensure lender consent
2528         if (requireLenderApproval) {
2529             allowedAmount = closeLoanOnBehalfOfRecurse(
2530                 position.lender,
2531                 msg.sender,
2532                 payoutRecipient,
2533                 positionId,
2534                 allowedAmount
2535             );
2536         }
2537 
2538         assert(allowedAmount > 0);
2539         assert(allowedAmount <= position.principal);
2540         assert(allowedAmount <= requestedAmount);
2541 
2542         return allowedAmount;
2543     }
2544 
2545     function closePositionOnBehalfOfRecurse(
2546         address contractAddr,
2547         address closer,
2548         address payoutRecipient,
2549         bytes32 positionId,
2550         uint256 closeAmount
2551     )
2552         private
2553         returns (uint256)
2554     {
2555         // no need to ask for permission
2556         if (closer == contractAddr) {
2557             return closeAmount;
2558         }
2559 
2560         (
2561             address newContractAddr,
2562             uint256 newCloseAmount
2563         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2564             closer,
2565             payoutRecipient,
2566             positionId,
2567             closeAmount
2568         );
2569 
2570         require(
2571             newCloseAmount <= closeAmount,
2572             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2573         );
2574         require(
2575             newCloseAmount > 0,
2576             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2577         );
2578 
2579         if (newContractAddr != contractAddr) {
2580             closePositionOnBehalfOfRecurse(
2581                 newContractAddr,
2582                 closer,
2583                 payoutRecipient,
2584                 positionId,
2585                 newCloseAmount
2586             );
2587         }
2588 
2589         return newCloseAmount;
2590     }
2591 
2592     function closeLoanOnBehalfOfRecurse(
2593         address contractAddr,
2594         address closer,
2595         address payoutRecipient,
2596         bytes32 positionId,
2597         uint256 closeAmount
2598     )
2599         private
2600         returns (uint256)
2601     {
2602         // no need to ask for permission
2603         if (closer == contractAddr) {
2604             return closeAmount;
2605         }
2606 
2607         (
2608             address newContractAddr,
2609             uint256 newCloseAmount
2610         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2611                 closer,
2612                 payoutRecipient,
2613                 positionId,
2614                 closeAmount
2615             );
2616 
2617         require(
2618             newCloseAmount <= closeAmount,
2619             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2620         );
2621         require(
2622             newCloseAmount > 0,
2623             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2624         );
2625 
2626         if (newContractAddr != contractAddr) {
2627             closeLoanOnBehalfOfRecurse(
2628                 newContractAddr,
2629                 closer,
2630                 payoutRecipient,
2631                 positionId,
2632                 newCloseAmount
2633             );
2634         }
2635 
2636         return newCloseAmount;
2637     }
2638 
2639     // ============ Parsing Functions ============
2640 
2641     function parseCloseTx(
2642         MarginState.State storage state,
2643         MarginCommon.Position storage position,
2644         bytes32 positionId,
2645         uint256 closeAmount,
2646         address payoutRecipient,
2647         address exchangeWrapper,
2648         bool payoutInHeldToken,
2649         bool isWithoutCounterparty
2650     )
2651         private
2652         view
2653         returns (CloseTx memory)
2654     {
2655         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2656 
2657         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2658             closeAmount,
2659             position.principal,
2660             startingHeldTokenBalance
2661         );
2662         uint256 owedTokenOwed = 0;
2663 
2664         if (!isWithoutCounterparty) {
2665             owedTokenOwed = MarginCommon.calculateOwedAmount(
2666                 position,
2667                 closeAmount,
2668                 block.timestamp
2669             );
2670         }
2671 
2672         return CloseTx({
2673             positionId: positionId,
2674             originalPrincipal: position.principal,
2675             closeAmount: closeAmount,
2676             owedTokenOwed: owedTokenOwed,
2677             startingHeldTokenBalance: startingHeldTokenBalance,
2678             availableHeldToken: availableHeldToken,
2679             payoutRecipient: payoutRecipient,
2680             owedToken: position.owedToken,
2681             heldToken: position.heldToken,
2682             positionOwner: position.owner,
2683             positionLender: position.lender,
2684             exchangeWrapper: exchangeWrapper,
2685             payoutInHeldToken: payoutInHeldToken
2686         });
2687     }
2688 }
2689 
2690 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2691 
2692 /**
2693  * @title ExchangeWrapper
2694  * @author dYdX
2695  *
2696  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2697  * with other smart contracts through a common interface.
2698  */
2699 interface ExchangeWrapper {
2700 
2701     // ============ Public Functions ============
2702 
2703     /**
2704      * Exchange some amount of takerToken for makerToken.
2705      *
2706      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2707      *                              cannot always be trusted as it is set at the discretion of the
2708      *                              msg.sender)
2709      * @param  receiver             Address to set allowance on once the trade has completed
2710      * @param  makerToken           Address of makerToken, the token to receive
2711      * @param  takerToken           Address of takerToken, the token to pay
2712      * @param  requestedFillAmount  Amount of takerToken being paid
2713      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2714      * @return                      The amount of makerToken received
2715      */
2716     function exchange(
2717         address tradeOriginator,
2718         address receiver,
2719         address makerToken,
2720         address takerToken,
2721         uint256 requestedFillAmount,
2722         bytes orderData
2723     )
2724         external
2725         returns (uint256);
2726 
2727     /**
2728      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2729      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2730      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2731      * than desiredMakerToken
2732      *
2733      * @param  makerToken         Address of makerToken, the token to receive
2734      * @param  takerToken         Address of takerToken, the token to pay
2735      * @param  desiredMakerToken  Amount of makerToken requested
2736      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2737      * @return                    Amount of takerToken the needed to complete the transaction
2738      */
2739     function getExchangeCost(
2740         address makerToken,
2741         address takerToken,
2742         uint256 desiredMakerToken,
2743         bytes orderData
2744     )
2745         external
2746         view
2747         returns (uint256);
2748 }
2749 
2750 // File: contracts/margin/impl/ClosePositionImpl.sol
2751 
2752 /**
2753  * @title ClosePositionImpl
2754  * @author dYdX
2755  *
2756  * This library contains the implementation for the closePosition function of Margin
2757  */
2758 library ClosePositionImpl {
2759     using SafeMath for uint256;
2760 
2761     // ============ Events ============
2762 
2763     /**
2764      * A position was closed or partially closed
2765      */
2766     event PositionClosed(
2767         bytes32 indexed positionId,
2768         address indexed closer,
2769         address indexed payoutRecipient,
2770         uint256 closeAmount,
2771         uint256 remainingAmount,
2772         uint256 owedTokenPaidToLender,
2773         uint256 payoutAmount,
2774         uint256 buybackCostInHeldToken,
2775         bool    payoutInHeldToken
2776     );
2777 
2778     // ============ Public Implementation Functions ============
2779 
2780     function closePositionImpl(
2781         MarginState.State storage state,
2782         bytes32 positionId,
2783         uint256 requestedCloseAmount,
2784         address payoutRecipient,
2785         address exchangeWrapper,
2786         bool payoutInHeldToken,
2787         bytes memory orderData
2788     )
2789         public
2790         returns (uint256, uint256, uint256)
2791     {
2792         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2793             state,
2794             positionId,
2795             requestedCloseAmount,
2796             payoutRecipient,
2797             exchangeWrapper,
2798             payoutInHeldToken,
2799             false
2800         );
2801 
2802         (
2803             uint256 buybackCostInHeldToken,
2804             uint256 receivedOwedToken
2805         ) = returnOwedTokensToLender(
2806             state,
2807             transaction,
2808             orderData
2809         );
2810 
2811         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2812             state,
2813             transaction,
2814             buybackCostInHeldToken,
2815             receivedOwedToken
2816         );
2817 
2818         ClosePositionShared.closePositionStateUpdate(state, transaction);
2819 
2820         logEventOnClose(
2821             transaction,
2822             buybackCostInHeldToken,
2823             payout
2824         );
2825 
2826         return (
2827             transaction.closeAmount,
2828             payout,
2829             transaction.owedTokenOwed
2830         );
2831     }
2832 
2833     // ============ Private Helper-Functions ============
2834 
2835     function returnOwedTokensToLender(
2836         MarginState.State storage state,
2837         ClosePositionShared.CloseTx memory transaction,
2838         bytes memory orderData
2839     )
2840         private
2841         returns (uint256, uint256)
2842     {
2843         uint256 buybackCostInHeldToken = 0;
2844         uint256 receivedOwedToken = 0;
2845         uint256 lenderOwedToken = transaction.owedTokenOwed;
2846 
2847         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2848         // from msg.sender
2849         if (transaction.exchangeWrapper == address(0)) {
2850             require(
2851                 transaction.payoutInHeldToken,
2852                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2853             );
2854 
2855             // No DEX Order; send owedTokens directly from the closer to the lender
2856             TokenProxy(state.TOKEN_PROXY).transferTokens(
2857                 transaction.owedToken,
2858                 msg.sender,
2859                 transaction.positionLender,
2860                 lenderOwedToken
2861             );
2862         } else {
2863             // Buy back owedTokens using DEX Order and send to lender
2864             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2865                 state,
2866                 transaction,
2867                 orderData
2868             );
2869 
2870             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2871             if (transaction.payoutInHeldToken) {
2872                 assert(receivedOwedToken >= lenderOwedToken);
2873                 lenderOwedToken = receivedOwedToken;
2874             }
2875 
2876             // Transfer owedToken from the exchange wrapper to the lender
2877             TokenProxy(state.TOKEN_PROXY).transferTokens(
2878                 transaction.owedToken,
2879                 transaction.exchangeWrapper,
2880                 transaction.positionLender,
2881                 lenderOwedToken
2882             );
2883         }
2884 
2885         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2886             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2887 
2888         return (buybackCostInHeldToken, receivedOwedToken);
2889     }
2890 
2891     function buyBackOwedToken(
2892         MarginState.State storage state,
2893         ClosePositionShared.CloseTx transaction,
2894         bytes memory orderData
2895     )
2896         private
2897         returns (uint256, uint256)
2898     {
2899         // Ask the exchange wrapper the cost in heldToken to buy back the close
2900         // amount of owedToken
2901         uint256 buybackCostInHeldToken;
2902 
2903         if (transaction.payoutInHeldToken) {
2904             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2905                 .getExchangeCost(
2906                     transaction.owedToken,
2907                     transaction.heldToken,
2908                     transaction.owedTokenOwed,
2909                     orderData
2910                 );
2911 
2912             // Require enough available heldToken to pay for the buyback
2913             require(
2914                 buybackCostInHeldToken <= transaction.availableHeldToken,
2915                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2916             );
2917         } else {
2918             buybackCostInHeldToken = transaction.availableHeldToken;
2919         }
2920 
2921         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2922         Vault(state.VAULT).transferFromVault(
2923             transaction.positionId,
2924             transaction.heldToken,
2925             transaction.exchangeWrapper,
2926             buybackCostInHeldToken
2927         );
2928 
2929         // Trade the heldToken for the owedToken
2930         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2931             msg.sender,
2932             state.TOKEN_PROXY,
2933             transaction.owedToken,
2934             transaction.heldToken,
2935             buybackCostInHeldToken,
2936             orderData
2937         );
2938 
2939         require(
2940             receivedOwedToken >= transaction.owedTokenOwed,
2941             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2942         );
2943 
2944         return (buybackCostInHeldToken, receivedOwedToken);
2945     }
2946 
2947     function logEventOnClose(
2948         ClosePositionShared.CloseTx transaction,
2949         uint256 buybackCostInHeldToken,
2950         uint256 payout
2951     )
2952         private
2953     {
2954         emit PositionClosed(
2955             transaction.positionId,
2956             msg.sender,
2957             transaction.payoutRecipient,
2958             transaction.closeAmount,
2959             transaction.originalPrincipal.sub(transaction.closeAmount),
2960             transaction.owedTokenOwed,
2961             payout,
2962             buybackCostInHeldToken,
2963             transaction.payoutInHeldToken
2964         );
2965     }
2966 
2967 }
2968 
2969 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
2970 
2971 /**
2972  * @title CloseWithoutCounterpartyImpl
2973  * @author dYdX
2974  *
2975  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
2976  * Margin
2977  */
2978 library CloseWithoutCounterpartyImpl {
2979     using SafeMath for uint256;
2980 
2981     // ============ Events ============
2982 
2983     /**
2984      * A position was closed or partially closed
2985      */
2986     event PositionClosed(
2987         bytes32 indexed positionId,
2988         address indexed closer,
2989         address indexed payoutRecipient,
2990         uint256 closeAmount,
2991         uint256 remainingAmount,
2992         uint256 owedTokenPaidToLender,
2993         uint256 payoutAmount,
2994         uint256 buybackCostInHeldToken,
2995         bool payoutInHeldToken
2996     );
2997 
2998     // ============ Public Implementation Functions ============
2999 
3000     function closeWithoutCounterpartyImpl(
3001         MarginState.State storage state,
3002         bytes32 positionId,
3003         uint256 requestedCloseAmount,
3004         address payoutRecipient
3005     )
3006         public
3007         returns (uint256, uint256)
3008     {
3009         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
3010             state,
3011             positionId,
3012             requestedCloseAmount,
3013             payoutRecipient,
3014             address(0),
3015             true,
3016             true
3017         );
3018 
3019         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
3020             state,
3021             transaction,
3022             0, // No buyback cost
3023             0  // Did not receive any owedToken
3024         );
3025 
3026         ClosePositionShared.closePositionStateUpdate(state, transaction);
3027 
3028         logEventOnCloseWithoutCounterparty(transaction);
3029 
3030         return (
3031             transaction.closeAmount,
3032             heldTokenPayout
3033         );
3034     }
3035 
3036     // ============ Private Helper-Functions ============
3037 
3038     function logEventOnCloseWithoutCounterparty(
3039         ClosePositionShared.CloseTx transaction
3040     )
3041         private
3042     {
3043         emit PositionClosed(
3044             transaction.positionId,
3045             msg.sender,
3046             transaction.payoutRecipient,
3047             transaction.closeAmount,
3048             transaction.originalPrincipal.sub(transaction.closeAmount),
3049             0,
3050             transaction.availableHeldToken,
3051             0,
3052             true
3053         );
3054     }
3055 }
3056 
3057 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
3058 
3059 /**
3060  * @title DepositCollateralDelegator
3061  * @author dYdX
3062  *
3063  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
3064  * into a position owned by the smart contract.
3065  *
3066  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3067  *       to these functions
3068  */
3069 interface DepositCollateralDelegator {
3070 
3071     // ============ Public Interface functions ============
3072 
3073     /**
3074      * Function a contract must implement in order to let other addresses call depositCollateral().
3075      *
3076      * @param  depositor   Address of the caller of the depositCollateral() function
3077      * @param  positionId  Unique ID of the position
3078      * @param  amount      Requested deposit amount
3079      * @return             This address to accept, a different address to ask that contract
3080      */
3081     function depositCollateralOnBehalfOf(
3082         address depositor,
3083         bytes32 positionId,
3084         uint256 amount
3085     )
3086         external
3087         /* onlyMargin */
3088         returns (address);
3089 }
3090 
3091 // File: contracts/margin/impl/DepositCollateralImpl.sol
3092 
3093 /**
3094  * @title DepositCollateralImpl
3095  * @author dYdX
3096  *
3097  * This library contains the implementation for the deposit function of Margin
3098  */
3099 library DepositCollateralImpl {
3100     using SafeMath for uint256;
3101 
3102     // ============ Events ============
3103 
3104     /**
3105      * Additional collateral for a position was posted by the owner
3106      */
3107     event AdditionalCollateralDeposited(
3108         bytes32 indexed positionId,
3109         uint256 amount,
3110         address depositor
3111     );
3112 
3113     /**
3114      * A margin call was canceled
3115      */
3116     event MarginCallCanceled(
3117         bytes32 indexed positionId,
3118         address indexed lender,
3119         address indexed owner,
3120         uint256 depositAmount
3121     );
3122 
3123     // ============ Public Implementation Functions ============
3124 
3125     function depositCollateralImpl(
3126         MarginState.State storage state,
3127         bytes32 positionId,
3128         uint256 depositAmount
3129     )
3130         public
3131     {
3132         MarginCommon.Position storage position =
3133             MarginCommon.getPositionFromStorage(state, positionId);
3134 
3135         require(
3136             depositAmount > 0,
3137             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
3138         );
3139 
3140         // Ensure owner consent
3141         depositCollateralOnBehalfOfRecurse(
3142             position.owner,
3143             msg.sender,
3144             positionId,
3145             depositAmount
3146         );
3147 
3148         Vault(state.VAULT).transferToVault(
3149             positionId,
3150             position.heldToken,
3151             msg.sender,
3152             depositAmount
3153         );
3154 
3155         // cancel margin call if applicable
3156         bool marginCallCanceled = false;
3157         uint256 requiredDeposit = position.requiredDeposit;
3158         if (position.callTimestamp > 0 && requiredDeposit > 0) {
3159             if (depositAmount >= requiredDeposit) {
3160                 position.requiredDeposit = 0;
3161                 position.callTimestamp = 0;
3162                 marginCallCanceled = true;
3163             } else {
3164                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
3165             }
3166         }
3167 
3168         emit AdditionalCollateralDeposited(
3169             positionId,
3170             depositAmount,
3171             msg.sender
3172         );
3173 
3174         if (marginCallCanceled) {
3175             emit MarginCallCanceled(
3176                 positionId,
3177                 position.lender,
3178                 msg.sender,
3179                 depositAmount
3180             );
3181         }
3182     }
3183 
3184     // ============ Private Helper-Functions ============
3185 
3186     function depositCollateralOnBehalfOfRecurse(
3187         address contractAddr,
3188         address depositor,
3189         bytes32 positionId,
3190         uint256 amount
3191     )
3192         private
3193     {
3194         // no need to ask for permission
3195         if (depositor == contractAddr) {
3196             return;
3197         }
3198 
3199         address newContractAddr =
3200             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
3201                 depositor,
3202                 positionId,
3203                 amount
3204             );
3205 
3206         // if not equal, recurse
3207         if (newContractAddr != contractAddr) {
3208             depositCollateralOnBehalfOfRecurse(
3209                 newContractAddr,
3210                 depositor,
3211                 positionId,
3212                 amount
3213             );
3214         }
3215     }
3216 }
3217 
3218 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
3219 
3220 /**
3221  * @title ForceRecoverCollateralDelegator
3222  * @author dYdX
3223  *
3224  * Interface that smart contracts must implement in order to let other addresses
3225  * forceRecoverCollateral() a loan owned by the smart contract.
3226  *
3227  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3228  *       to these functions
3229  */
3230 interface ForceRecoverCollateralDelegator {
3231 
3232     // ============ Public Interface functions ============
3233 
3234     /**
3235      * Function a contract must implement in order to let other addresses call
3236      * forceRecoverCollateral().
3237      *
3238      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3239      * will either revert the entire transaction or that the collateral was forcibly recovered.
3240      *
3241      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3242      * @param  positionId  Unique ID of the position
3243      * @param  recipient   Address to send the recovered tokens to
3244      * @return             This address to accept, a different address to ask that contract
3245      */
3246     function forceRecoverCollateralOnBehalfOf(
3247         address recoverer,
3248         bytes32 positionId,
3249         address recipient
3250     )
3251         external
3252         /* onlyMargin */
3253         returns (address);
3254 }
3255 
3256 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3257 
3258 /* solium-disable-next-line max-len*/
3259 
3260 /**
3261  * @title ForceRecoverCollateralImpl
3262  * @author dYdX
3263  *
3264  * This library contains the implementation for the forceRecoverCollateral function of Margin
3265  */
3266 library ForceRecoverCollateralImpl {
3267     using SafeMath for uint256;
3268 
3269     // ============ Events ============
3270 
3271     /**
3272      * Collateral for a position was forcibly recovered
3273      */
3274     event CollateralForceRecovered(
3275         bytes32 indexed positionId,
3276         address indexed recipient,
3277         uint256 amount
3278     );
3279 
3280     // ============ Public Implementation Functions ============
3281 
3282     function forceRecoverCollateralImpl(
3283         MarginState.State storage state,
3284         bytes32 positionId,
3285         address recipient
3286     )
3287         public
3288         returns (uint256)
3289     {
3290         MarginCommon.Position storage position =
3291             MarginCommon.getPositionFromStorage(state, positionId);
3292 
3293         // Can only force recover after either:
3294         // 1) The loan was called and the call period has elapsed
3295         // 2) The maxDuration of the position has elapsed
3296         require( /* solium-disable-next-line */
3297             (
3298                 position.callTimestamp > 0
3299                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3300             ) || (
3301                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3302             ),
3303             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3304         );
3305 
3306         // Ensure lender consent
3307         forceRecoverCollateralOnBehalfOfRecurse(
3308             position.lender,
3309             msg.sender,
3310             positionId,
3311             recipient
3312         );
3313 
3314         // Send the tokens
3315         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3316         Vault(state.VAULT).transferFromVault(
3317             positionId,
3318             position.heldToken,
3319             recipient,
3320             heldTokenRecovered
3321         );
3322 
3323         // Delete the position
3324         // NOTE: Since position is a storage pointer, this will also set all fields on
3325         //       the position variable to 0
3326         MarginCommon.cleanupPosition(
3327             state,
3328             positionId
3329         );
3330 
3331         // Log an event
3332         emit CollateralForceRecovered(
3333             positionId,
3334             recipient,
3335             heldTokenRecovered
3336         );
3337 
3338         return heldTokenRecovered;
3339     }
3340 
3341     // ============ Private Helper-Functions ============
3342 
3343     function forceRecoverCollateralOnBehalfOfRecurse(
3344         address contractAddr,
3345         address recoverer,
3346         bytes32 positionId,
3347         address recipient
3348     )
3349         private
3350     {
3351         // no need to ask for permission
3352         if (recoverer == contractAddr) {
3353             return;
3354         }
3355 
3356         address newContractAddr =
3357             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3358                 recoverer,
3359                 positionId,
3360                 recipient
3361             );
3362 
3363         if (newContractAddr != contractAddr) {
3364             forceRecoverCollateralOnBehalfOfRecurse(
3365                 newContractAddr,
3366                 recoverer,
3367                 positionId,
3368                 recipient
3369             );
3370         }
3371     }
3372 }
3373 
3374 // File: contracts/lib/TypedSignature.sol
3375 
3376 /**
3377  * @title TypedSignature
3378  * @author dYdX
3379  *
3380  * Allows for ecrecovery of signed hashes with three different prepended messages:
3381  * 1) ""
3382  * 2) "\x19Ethereum Signed Message:\n32"
3383  * 3) "\x19Ethereum Signed Message:\n\x20"
3384  */
3385 library TypedSignature {
3386 
3387     // Solidity does not offer guarantees about enum values, so we define them explicitly
3388     uint8 private constant SIGTYPE_INVALID = 0;
3389     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3390     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3391     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3392 
3393     // prepended message with the length of the signed hash in hexadecimal
3394     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3395 
3396     // prepended message with the length of the signed hash in decimal
3397     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3398 
3399     /**
3400      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3401      *
3402      * @param  hash               Hash that was signed (does not include prepended message)
3403      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3404      * @return                    address of the signer of the hash
3405      */
3406     function recover(
3407         bytes32 hash,
3408         bytes signatureWithType
3409     )
3410         internal
3411         pure
3412         returns (address)
3413     {
3414         require(
3415             signatureWithType.length == 66,
3416             "SignatureValidator#validateSignature: invalid signature length"
3417         );
3418 
3419         uint8 sigType = uint8(signatureWithType[0]);
3420 
3421         require(
3422             sigType > uint8(SIGTYPE_INVALID),
3423             "SignatureValidator#validateSignature: invalid signature type"
3424         );
3425         require(
3426             sigType < uint8(SIGTYPE_UNSUPPORTED),
3427             "SignatureValidator#validateSignature: unsupported signature type"
3428         );
3429 
3430         uint8 v = uint8(signatureWithType[1]);
3431         bytes32 r;
3432         bytes32 s;
3433 
3434         /* solium-disable-next-line security/no-inline-assembly */
3435         assembly {
3436             r := mload(add(signatureWithType, 34))
3437             s := mload(add(signatureWithType, 66))
3438         }
3439 
3440         bytes32 signedHash;
3441         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3442             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3443         } else {
3444             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3445             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3446         }
3447 
3448         return ecrecover(
3449             signedHash,
3450             v,
3451             r,
3452             s
3453         );
3454     }
3455 }
3456 
3457 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3458 
3459 /**
3460  * @title LoanOfferingVerifier
3461  * @author dYdX
3462  *
3463  * Interface that smart contracts must implement to be able to make off-chain generated
3464  * loan offerings.
3465  *
3466  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3467  *       to these functions
3468  */
3469 interface LoanOfferingVerifier {
3470 
3471     /**
3472      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3473      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3474      * position.
3475      *
3476      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3477      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3478      * state on a loan.
3479      *
3480      * @param  addresses    Array of addresses:
3481      *
3482      *  [0] = owedToken
3483      *  [1] = heldToken
3484      *  [2] = loan payer
3485      *  [3] = loan owner
3486      *  [4] = loan taker
3487      *  [5] = loan positionOwner
3488      *  [6] = loan fee recipient
3489      *  [7] = loan lender fee token
3490      *  [8] = loan taker fee token
3491      *
3492      * @param  values256    Values corresponding to:
3493      *
3494      *  [0] = loan maximum amount
3495      *  [1] = loan minimum amount
3496      *  [2] = loan minimum heldToken
3497      *  [3] = loan lender fee
3498      *  [4] = loan taker fee
3499      *  [5] = loan expiration timestamp (in seconds)
3500      *  [6] = loan salt
3501      *
3502      * @param  values32     Values corresponding to:
3503      *
3504      *  [0] = loan call time limit (in seconds)
3505      *  [1] = loan maxDuration (in seconds)
3506      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3507      *  [3] = loan interest update period (in seconds)
3508      *
3509      * @param  positionId   Unique ID of the position
3510      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3511      * @return              This address to accept, a different address to ask that contract
3512      */
3513     function verifyLoanOffering(
3514         address[9] addresses,
3515         uint256[7] values256,
3516         uint32[4] values32,
3517         bytes32 positionId,
3518         bytes signature
3519     )
3520         external
3521         /* onlyMargin */
3522         returns (address);
3523 }
3524 
3525 // File: contracts/margin/impl/BorrowShared.sol
3526 
3527 /**
3528  * @title BorrowShared
3529  * @author dYdX
3530  *
3531  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3532  * Both use a Loan Offering and a DEX Order to open or increase a position.
3533  */
3534 library BorrowShared {
3535     using SafeMath for uint256;
3536 
3537     // ============ Structs ============
3538 
3539     struct Tx {
3540         bytes32 positionId;
3541         address owner;
3542         uint256 principal;
3543         uint256 lenderAmount;
3544         MarginCommon.LoanOffering loanOffering;
3545         address exchangeWrapper;
3546         bool depositInHeldToken;
3547         uint256 depositAmount;
3548         uint256 collateralAmount;
3549         uint256 heldTokenFromSell;
3550     }
3551 
3552     // ============ Internal Implementation Functions ============
3553 
3554     /**
3555      * Validate the transaction before exchanging heldToken for owedToken
3556      */
3557     function validateTxPreSell(
3558         MarginState.State storage state,
3559         Tx memory transaction
3560     )
3561         internal
3562     {
3563         assert(transaction.lenderAmount >= transaction.principal);
3564 
3565         require(
3566             transaction.principal > 0,
3567             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3568         );
3569 
3570         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3571         if (transaction.loanOffering.taker != address(0)) {
3572             require(
3573                 msg.sender == transaction.loanOffering.taker,
3574                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3575             );
3576         }
3577 
3578         // If the positionOwner is 0x0 then any address can be set as the position owner.
3579         // Otherwise only the specified positionOwner can be set as the position owner.
3580         if (transaction.loanOffering.positionOwner != address(0)) {
3581             require(
3582                 transaction.owner == transaction.loanOffering.positionOwner,
3583                 "BorrowShared#validateTxPreSell: Invalid position owner"
3584             );
3585         }
3586 
3587         // Require the loan offering to be approved by the payer
3588         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3589             getConsentFromSmartContractLender(transaction);
3590         } else {
3591             require(
3592                 transaction.loanOffering.payer == TypedSignature.recover(
3593                     transaction.loanOffering.loanHash,
3594                     transaction.loanOffering.signature
3595                 ),
3596                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3597             );
3598         }
3599 
3600         // Validate the amount is <= than max and >= min
3601         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3602             state,
3603             transaction.loanOffering.loanHash
3604         );
3605         require(
3606             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3607             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3608         );
3609 
3610         require(
3611             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3612             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3613         );
3614 
3615         require(
3616             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3617             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3618         );
3619 
3620         require(
3621             transaction.owner != address(0),
3622             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3623         );
3624 
3625         require(
3626             transaction.loanOffering.owner != address(0),
3627             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3628         );
3629 
3630         require(
3631             transaction.loanOffering.expirationTimestamp > block.timestamp,
3632             "BorrowShared#validateTxPreSell: Loan offering is expired"
3633         );
3634 
3635         require(
3636             transaction.loanOffering.maxDuration > 0,
3637             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3638         );
3639 
3640         require(
3641             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3642             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3643         );
3644 
3645         // The minimum heldToken is validated after executing the sell
3646         // Position and loan ownership is validated in TransferInternal
3647     }
3648 
3649     /**
3650      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3651      * how much of the loan was used.
3652      */
3653     function doPostSell(
3654         MarginState.State storage state,
3655         Tx memory transaction
3656     )
3657         internal
3658     {
3659         validateTxPostSell(transaction);
3660 
3661         // Transfer feeTokens from trader and lender
3662         transferLoanFees(state, transaction);
3663 
3664         // Update global amounts for the loan
3665         state.loanFills[transaction.loanOffering.loanHash] =
3666             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3667     }
3668 
3669     /**
3670      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3671      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3672      * maxHeldTokenToBuy of heldTokens at most.
3673      */
3674     function doSell(
3675         MarginState.State storage state,
3676         Tx transaction,
3677         bytes orderData,
3678         uint256 maxHeldTokenToBuy
3679     )
3680         internal
3681         returns (uint256)
3682     {
3683         // Move owedTokens from lender to exchange wrapper
3684         pullOwedTokensFromLender(state, transaction);
3685 
3686         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3687         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3688         uint256 sellAmount = transaction.depositInHeldToken ?
3689             transaction.lenderAmount :
3690             transaction.lenderAmount.add(transaction.depositAmount);
3691 
3692         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3693         uint256 heldTokenFromSell = Math.min256(
3694             maxHeldTokenToBuy,
3695             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3696                 msg.sender,
3697                 state.TOKEN_PROXY,
3698                 transaction.loanOffering.heldToken,
3699                 transaction.loanOffering.owedToken,
3700                 sellAmount,
3701                 orderData
3702             )
3703         );
3704 
3705         // Move the tokens to the vault
3706         Vault(state.VAULT).transferToVault(
3707             transaction.positionId,
3708             transaction.loanOffering.heldToken,
3709             transaction.exchangeWrapper,
3710             heldTokenFromSell
3711         );
3712 
3713         // Update collateral amount
3714         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3715 
3716         return heldTokenFromSell;
3717     }
3718 
3719     /**
3720      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3721      * be sold for heldToken.
3722      */
3723     function doDepositOwedToken(
3724         MarginState.State storage state,
3725         Tx transaction
3726     )
3727         internal
3728     {
3729         TokenProxy(state.TOKEN_PROXY).transferTokens(
3730             transaction.loanOffering.owedToken,
3731             msg.sender,
3732             transaction.exchangeWrapper,
3733             transaction.depositAmount
3734         );
3735     }
3736 
3737     /**
3738      * Take the heldToken deposit from the trader and move it to the vault.
3739      */
3740     function doDepositHeldToken(
3741         MarginState.State storage state,
3742         Tx transaction
3743     )
3744         internal
3745     {
3746         Vault(state.VAULT).transferToVault(
3747             transaction.positionId,
3748             transaction.loanOffering.heldToken,
3749             msg.sender,
3750             transaction.depositAmount
3751         );
3752 
3753         // Update collateral amount
3754         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3755     }
3756 
3757     // ============ Private Helper-Functions ============
3758 
3759     function validateTxPostSell(
3760         Tx transaction
3761     )
3762         private
3763         pure
3764     {
3765         uint256 expectedCollateral = transaction.depositInHeldToken ?
3766             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3767             transaction.heldTokenFromSell;
3768         assert(transaction.collateralAmount == expectedCollateral);
3769 
3770         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3771             transaction.lenderAmount,
3772             transaction.loanOffering.rates.maxAmount,
3773             transaction.loanOffering.rates.minHeldToken
3774         );
3775         require(
3776             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3777             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3778         );
3779     }
3780 
3781     function getConsentFromSmartContractLender(
3782         Tx transaction
3783     )
3784         private
3785     {
3786         verifyLoanOfferingRecurse(
3787             transaction.loanOffering.payer,
3788             getLoanOfferingAddresses(transaction),
3789             getLoanOfferingValues256(transaction),
3790             getLoanOfferingValues32(transaction),
3791             transaction.positionId,
3792             transaction.loanOffering.signature
3793         );
3794     }
3795 
3796     function verifyLoanOfferingRecurse(
3797         address contractAddr,
3798         address[9] addresses,
3799         uint256[7] values256,
3800         uint32[4] values32,
3801         bytes32 positionId,
3802         bytes signature
3803     )
3804         private
3805     {
3806         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3807             addresses,
3808             values256,
3809             values32,
3810             positionId,
3811             signature
3812         );
3813 
3814         if (newContractAddr != contractAddr) {
3815             verifyLoanOfferingRecurse(
3816                 newContractAddr,
3817                 addresses,
3818                 values256,
3819                 values32,
3820                 positionId,
3821                 signature
3822             );
3823         }
3824     }
3825 
3826     function pullOwedTokensFromLender(
3827         MarginState.State storage state,
3828         Tx transaction
3829     )
3830         private
3831     {
3832         // Transfer owedToken to the exchange wrapper
3833         TokenProxy(state.TOKEN_PROXY).transferTokens(
3834             transaction.loanOffering.owedToken,
3835             transaction.loanOffering.payer,
3836             transaction.exchangeWrapper,
3837             transaction.lenderAmount
3838         );
3839     }
3840 
3841     function transferLoanFees(
3842         MarginState.State storage state,
3843         Tx transaction
3844     )
3845         private
3846     {
3847         // 0 fee address indicates no fees
3848         if (transaction.loanOffering.feeRecipient == address(0)) {
3849             return;
3850         }
3851 
3852         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3853 
3854         uint256 lenderFee = MathHelpers.getPartialAmount(
3855             transaction.lenderAmount,
3856             transaction.loanOffering.rates.maxAmount,
3857             transaction.loanOffering.rates.lenderFee
3858         );
3859         uint256 takerFee = MathHelpers.getPartialAmount(
3860             transaction.lenderAmount,
3861             transaction.loanOffering.rates.maxAmount,
3862             transaction.loanOffering.rates.takerFee
3863         );
3864 
3865         if (lenderFee > 0) {
3866             proxy.transferTokens(
3867                 transaction.loanOffering.lenderFeeToken,
3868                 transaction.loanOffering.payer,
3869                 transaction.loanOffering.feeRecipient,
3870                 lenderFee
3871             );
3872         }
3873 
3874         if (takerFee > 0) {
3875             proxy.transferTokens(
3876                 transaction.loanOffering.takerFeeToken,
3877                 msg.sender,
3878                 transaction.loanOffering.feeRecipient,
3879                 takerFee
3880             );
3881         }
3882     }
3883 
3884     function getLoanOfferingAddresses(
3885         Tx transaction
3886     )
3887         private
3888         pure
3889         returns (address[9])
3890     {
3891         return [
3892             transaction.loanOffering.owedToken,
3893             transaction.loanOffering.heldToken,
3894             transaction.loanOffering.payer,
3895             transaction.loanOffering.owner,
3896             transaction.loanOffering.taker,
3897             transaction.loanOffering.positionOwner,
3898             transaction.loanOffering.feeRecipient,
3899             transaction.loanOffering.lenderFeeToken,
3900             transaction.loanOffering.takerFeeToken
3901         ];
3902     }
3903 
3904     function getLoanOfferingValues256(
3905         Tx transaction
3906     )
3907         private
3908         pure
3909         returns (uint256[7])
3910     {
3911         return [
3912             transaction.loanOffering.rates.maxAmount,
3913             transaction.loanOffering.rates.minAmount,
3914             transaction.loanOffering.rates.minHeldToken,
3915             transaction.loanOffering.rates.lenderFee,
3916             transaction.loanOffering.rates.takerFee,
3917             transaction.loanOffering.expirationTimestamp,
3918             transaction.loanOffering.salt
3919         ];
3920     }
3921 
3922     function getLoanOfferingValues32(
3923         Tx transaction
3924     )
3925         private
3926         pure
3927         returns (uint32[4])
3928     {
3929         return [
3930             transaction.loanOffering.callTimeLimit,
3931             transaction.loanOffering.maxDuration,
3932             transaction.loanOffering.rates.interestRate,
3933             transaction.loanOffering.rates.interestPeriod
3934         ];
3935     }
3936 }
3937 
3938 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3939 
3940 /**
3941  * @title IncreaseLoanDelegator
3942  * @author dYdX
3943  *
3944  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3945  *
3946  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3947  *       to these functions
3948  */
3949 interface IncreaseLoanDelegator {
3950 
3951     // ============ Public Interface functions ============
3952 
3953     /**
3954      * Function a contract must implement in order to allow additional value to be added onto
3955      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3956      *
3957      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3958      * either revert the entire transaction or that the loan size was successfully increased.
3959      *
3960      * @param  payer           Lender adding additional funds to the position
3961      * @param  positionId      Unique ID of the position
3962      * @param  principalAdded  Principal amount to be added to the position
3963      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3964      *                         zero if increaseWithoutCounterparty() is used).
3965      * @return                 This address to accept, a different address to ask that contract
3966      */
3967     function increaseLoanOnBehalfOf(
3968         address payer,
3969         bytes32 positionId,
3970         uint256 principalAdded,
3971         uint256 lentAmount
3972     )
3973         external
3974         /* onlyMargin */
3975         returns (address);
3976 }
3977 
3978 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
3979 
3980 /**
3981  * @title IncreasePositionDelegator
3982  * @author dYdX
3983  *
3984  * Interface that smart contracts must implement in order to own position on behalf of other
3985  * accounts
3986  *
3987  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3988  *       to these functions
3989  */
3990 interface IncreasePositionDelegator {
3991 
3992     // ============ Public Interface functions ============
3993 
3994     /**
3995      * Function a contract must implement in order to allow additional value to be added onto
3996      * an owned position. Margin will call this on the owner of a position during increasePosition()
3997      *
3998      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3999      * either revert the entire transaction or that the position size was successfully increased.
4000      *
4001      * @param  trader          Address initiating the addition of funds to the position
4002      * @param  positionId      Unique ID of the position
4003      * @param  principalAdded  Amount of principal to be added to the position
4004      * @return                 This address to accept, a different address to ask that contract
4005      */
4006     function increasePositionOnBehalfOf(
4007         address trader,
4008         bytes32 positionId,
4009         uint256 principalAdded
4010     )
4011         external
4012         /* onlyMargin */
4013         returns (address);
4014 }
4015 
4016 // File: contracts/margin/impl/IncreasePositionImpl.sol
4017 
4018 /**
4019  * @title IncreasePositionImpl
4020  * @author dYdX
4021  *
4022  * This library contains the implementation for the increasePosition function of Margin
4023  */
4024 library IncreasePositionImpl {
4025     using SafeMath for uint256;
4026 
4027     // ============ Events ============
4028 
4029     /*
4030      * A position was increased
4031      */
4032     event PositionIncreased(
4033         bytes32 indexed positionId,
4034         address indexed trader,
4035         address indexed lender,
4036         address positionOwner,
4037         address loanOwner,
4038         bytes32 loanHash,
4039         address loanFeeRecipient,
4040         uint256 amountBorrowed,
4041         uint256 principalAdded,
4042         uint256 heldTokenFromSell,
4043         uint256 depositAmount,
4044         bool    depositInHeldToken
4045     );
4046 
4047     // ============ Public Implementation Functions ============
4048 
4049     function increasePositionImpl(
4050         MarginState.State storage state,
4051         bytes32 positionId,
4052         address[7] addresses,
4053         uint256[8] values256,
4054         uint32[2] values32,
4055         bool depositInHeldToken,
4056         bytes signature,
4057         bytes orderData
4058     )
4059         public
4060         returns (uint256)
4061     {
4062         // Also ensures that the position exists
4063         MarginCommon.Position storage position =
4064             MarginCommon.getPositionFromStorage(state, positionId);
4065 
4066         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
4067             position,
4068             positionId,
4069             addresses,
4070             values256,
4071             values32,
4072             depositInHeldToken,
4073             signature
4074         );
4075 
4076         validateIncrease(state, transaction, position);
4077 
4078         doBorrowAndSell(state, transaction, orderData);
4079 
4080         updateState(
4081             position,
4082             transaction.positionId,
4083             transaction.principal,
4084             transaction.lenderAmount,
4085             transaction.loanOffering.payer
4086         );
4087 
4088         // LOG EVENT
4089         recordPositionIncreased(transaction, position);
4090 
4091         return transaction.lenderAmount;
4092     }
4093 
4094     function increaseWithoutCounterpartyImpl(
4095         MarginState.State storage state,
4096         bytes32 positionId,
4097         uint256 principalToAdd
4098     )
4099         public
4100         returns (uint256)
4101     {
4102         MarginCommon.Position storage position =
4103             MarginCommon.getPositionFromStorage(state, positionId);
4104 
4105         // Disallow adding 0 principal
4106         require(
4107             principalToAdd > 0,
4108             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
4109         );
4110 
4111         // Disallow additions after maximum duration
4112         require(
4113             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
4114             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
4115         );
4116 
4117         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
4118             state,
4119             position,
4120             positionId,
4121             principalToAdd
4122         );
4123 
4124         Vault(state.VAULT).transferToVault(
4125             positionId,
4126             position.heldToken,
4127             msg.sender,
4128             heldTokenAmount
4129         );
4130 
4131         updateState(
4132             position,
4133             positionId,
4134             principalToAdd,
4135             0, // lent amount
4136             msg.sender
4137         );
4138 
4139         emit PositionIncreased(
4140             positionId,
4141             msg.sender,
4142             msg.sender,
4143             position.owner,
4144             position.lender,
4145             "",
4146             address(0),
4147             0,
4148             principalToAdd,
4149             0,
4150             heldTokenAmount,
4151             true
4152         );
4153 
4154         return heldTokenAmount;
4155     }
4156 
4157     // ============ Private Helper-Functions ============
4158 
4159     function doBorrowAndSell(
4160         MarginState.State storage state,
4161         BorrowShared.Tx memory transaction,
4162         bytes orderData
4163     )
4164         private
4165     {
4166         // Calculate the number of heldTokens to add
4167         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
4168             state,
4169             state.positions[transaction.positionId],
4170             transaction.positionId,
4171             transaction.principal
4172         );
4173 
4174         // Do pre-exchange validations
4175         BorrowShared.validateTxPreSell(state, transaction);
4176 
4177         // Calculate and deposit owedToken
4178         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
4179         if (!transaction.depositInHeldToken) {
4180             transaction.depositAmount =
4181                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
4182             BorrowShared.doDepositOwedToken(state, transaction);
4183             maxHeldTokenFromSell = collateralToAdd;
4184         }
4185 
4186         // Sell owedToken for heldToken using the exchange wrapper
4187         transaction.heldTokenFromSell = BorrowShared.doSell(
4188             state,
4189             transaction,
4190             orderData,
4191             maxHeldTokenFromSell
4192         );
4193 
4194         // Calculate and deposit heldToken
4195         if (transaction.depositInHeldToken) {
4196             require(
4197                 transaction.heldTokenFromSell <= collateralToAdd,
4198                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
4199             );
4200             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
4201             BorrowShared.doDepositHeldToken(state, transaction);
4202         }
4203 
4204         // Make sure the actual added collateral is what is expected
4205         assert(transaction.collateralAmount == collateralToAdd);
4206 
4207         // Do post-exchange validations
4208         BorrowShared.doPostSell(state, transaction);
4209     }
4210 
4211     function getOwedTokenDeposit(
4212         BorrowShared.Tx transaction,
4213         uint256 collateralToAdd,
4214         bytes orderData
4215     )
4216         private
4217         view
4218         returns (uint256)
4219     {
4220         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4221             transaction.loanOffering.heldToken,
4222             transaction.loanOffering.owedToken,
4223             collateralToAdd,
4224             orderData
4225         );
4226 
4227         require(
4228             transaction.lenderAmount <= totalOwedToken,
4229             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4230         );
4231 
4232         return totalOwedToken.sub(transaction.lenderAmount);
4233     }
4234 
4235     function validateIncrease(
4236         MarginState.State storage state,
4237         BorrowShared.Tx transaction,
4238         MarginCommon.Position storage position
4239     )
4240         private
4241         view
4242     {
4243         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4244 
4245         require(
4246             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4247             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4248         );
4249 
4250         // require the position to end no later than the loanOffering's maximum acceptable end time
4251         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4252         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4253         require(
4254             positionEndTimestamp <= offeringEndTimestamp,
4255             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4256         );
4257 
4258         require(
4259             block.timestamp < positionEndTimestamp,
4260             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4261         );
4262     }
4263 
4264     function getCollateralNeededForAddedPrincipal(
4265         MarginState.State storage state,
4266         MarginCommon.Position storage position,
4267         bytes32 positionId,
4268         uint256 principalToAdd
4269     )
4270         private
4271         view
4272         returns (uint256)
4273     {
4274         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4275 
4276         return MathHelpers.getPartialAmountRoundedUp(
4277             principalToAdd,
4278             position.principal,
4279             heldTokenBalance
4280         );
4281     }
4282 
4283     function updateState(
4284         MarginCommon.Position storage position,
4285         bytes32 positionId,
4286         uint256 principalAdded,
4287         uint256 owedTokenLent,
4288         address loanPayer
4289     )
4290         private
4291     {
4292         position.principal = position.principal.add(principalAdded);
4293 
4294         address owner = position.owner;
4295         address lender = position.lender;
4296 
4297         // Ensure owner consent
4298         increasePositionOnBehalfOfRecurse(
4299             owner,
4300             msg.sender,
4301             positionId,
4302             principalAdded
4303         );
4304 
4305         // Ensure lender consent
4306         increaseLoanOnBehalfOfRecurse(
4307             lender,
4308             loanPayer,
4309             positionId,
4310             principalAdded,
4311             owedTokenLent
4312         );
4313     }
4314 
4315     function increasePositionOnBehalfOfRecurse(
4316         address contractAddr,
4317         address trader,
4318         bytes32 positionId,
4319         uint256 principalAdded
4320     )
4321         private
4322     {
4323         // Assume owner approval if not a smart contract and they increased their own position
4324         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4325             return;
4326         }
4327 
4328         address newContractAddr =
4329             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4330                 trader,
4331                 positionId,
4332                 principalAdded
4333             );
4334 
4335         if (newContractAddr != contractAddr) {
4336             increasePositionOnBehalfOfRecurse(
4337                 newContractAddr,
4338                 trader,
4339                 positionId,
4340                 principalAdded
4341             );
4342         }
4343     }
4344 
4345     function increaseLoanOnBehalfOfRecurse(
4346         address contractAddr,
4347         address payer,
4348         bytes32 positionId,
4349         uint256 principalAdded,
4350         uint256 amountLent
4351     )
4352         private
4353     {
4354         // Assume lender approval if not a smart contract and they increased their own loan
4355         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4356             return;
4357         }
4358 
4359         address newContractAddr =
4360             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4361                 payer,
4362                 positionId,
4363                 principalAdded,
4364                 amountLent
4365             );
4366 
4367         if (newContractAddr != contractAddr) {
4368             increaseLoanOnBehalfOfRecurse(
4369                 newContractAddr,
4370                 payer,
4371                 positionId,
4372                 principalAdded,
4373                 amountLent
4374             );
4375         }
4376     }
4377 
4378     function recordPositionIncreased(
4379         BorrowShared.Tx transaction,
4380         MarginCommon.Position storage position
4381     )
4382         private
4383     {
4384         emit PositionIncreased(
4385             transaction.positionId,
4386             msg.sender,
4387             transaction.loanOffering.payer,
4388             position.owner,
4389             position.lender,
4390             transaction.loanOffering.loanHash,
4391             transaction.loanOffering.feeRecipient,
4392             transaction.lenderAmount,
4393             transaction.principal,
4394             transaction.heldTokenFromSell,
4395             transaction.depositAmount,
4396             transaction.depositInHeldToken
4397         );
4398     }
4399 
4400     // ============ Parsing Functions ============
4401 
4402     function parseIncreasePositionTx(
4403         MarginCommon.Position storage position,
4404         bytes32 positionId,
4405         address[7] addresses,
4406         uint256[8] values256,
4407         uint32[2] values32,
4408         bool depositInHeldToken,
4409         bytes signature
4410     )
4411         private
4412         view
4413         returns (BorrowShared.Tx memory)
4414     {
4415         uint256 principal = values256[7];
4416 
4417         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4418             position,
4419             principal,
4420             block.timestamp
4421         );
4422         assert(lenderAmount >= principal);
4423 
4424         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4425             positionId: positionId,
4426             owner: position.owner,
4427             principal: principal,
4428             lenderAmount: lenderAmount,
4429             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4430                 position,
4431                 addresses,
4432                 values256,
4433                 values32,
4434                 signature
4435             ),
4436             exchangeWrapper: addresses[6],
4437             depositInHeldToken: depositInHeldToken,
4438             depositAmount: 0, // set later
4439             collateralAmount: 0, // set later
4440             heldTokenFromSell: 0 // set later
4441         });
4442 
4443         return transaction;
4444     }
4445 
4446     function parseLoanOfferingFromIncreasePositionTx(
4447         MarginCommon.Position storage position,
4448         address[7] addresses,
4449         uint256[8] values256,
4450         uint32[2] values32,
4451         bytes signature
4452     )
4453         private
4454         view
4455         returns (MarginCommon.LoanOffering memory)
4456     {
4457         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4458             owedToken: position.owedToken,
4459             heldToken: position.heldToken,
4460             payer: addresses[0],
4461             owner: position.lender,
4462             taker: addresses[1],
4463             positionOwner: addresses[2],
4464             feeRecipient: addresses[3],
4465             lenderFeeToken: addresses[4],
4466             takerFeeToken: addresses[5],
4467             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4468             expirationTimestamp: values256[5],
4469             callTimeLimit: values32[0],
4470             maxDuration: values32[1],
4471             salt: values256[6],
4472             loanHash: 0,
4473             signature: signature
4474         });
4475 
4476         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4477 
4478         return loanOffering;
4479     }
4480 
4481     function parseLoanOfferingRatesFromIncreasePositionTx(
4482         MarginCommon.Position storage position,
4483         uint256[8] values256
4484     )
4485         private
4486         view
4487         returns (MarginCommon.LoanRates memory)
4488     {
4489         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4490             maxAmount: values256[0],
4491             minAmount: values256[1],
4492             minHeldToken: values256[2],
4493             lenderFee: values256[3],
4494             takerFee: values256[4],
4495             interestRate: position.interestRate,
4496             interestPeriod: position.interestPeriod
4497         });
4498 
4499         return rates;
4500     }
4501 }
4502 
4503 // File: contracts/margin/impl/MarginStorage.sol
4504 
4505 /**
4506  * @title MarginStorage
4507  * @author dYdX
4508  *
4509  * This contract serves as the storage for the entire state of MarginStorage
4510  */
4511 contract MarginStorage {
4512 
4513     MarginState.State state;
4514 
4515 }
4516 
4517 // File: contracts/margin/impl/LoanGetters.sol
4518 
4519 /**
4520  * @title LoanGetters
4521  * @author dYdX
4522  *
4523  * A collection of public constant getter functions that allows reading of the state of any loan
4524  * offering stored in the dYdX protocol.
4525  */
4526 contract LoanGetters is MarginStorage {
4527 
4528     // ============ Public Constant Functions ============
4529 
4530     /**
4531      * Gets the principal amount of a loan offering that is no longer available.
4532      *
4533      * @param  loanHash  Unique hash of the loan offering
4534      * @return           The total unavailable amount of the loan offering, which is equal to the
4535      *                   filled amount plus the canceled amount.
4536      */
4537     function getLoanUnavailableAmount(
4538         bytes32 loanHash
4539     )
4540         external
4541         view
4542         returns (uint256)
4543     {
4544         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4545     }
4546 
4547     /**
4548      * Gets the total amount of owed token lent for a loan.
4549      *
4550      * @param  loanHash  Unique hash of the loan offering
4551      * @return           The total filled amount of the loan offering.
4552      */
4553     function getLoanFilledAmount(
4554         bytes32 loanHash
4555     )
4556         external
4557         view
4558         returns (uint256)
4559     {
4560         return state.loanFills[loanHash];
4561     }
4562 
4563     /**
4564      * Gets the amount of a loan offering that has been canceled.
4565      *
4566      * @param  loanHash  Unique hash of the loan offering
4567      * @return           The total canceled amount of the loan offering.
4568      */
4569     function getLoanCanceledAmount(
4570         bytes32 loanHash
4571     )
4572         external
4573         view
4574         returns (uint256)
4575     {
4576         return state.loanCancels[loanHash];
4577     }
4578 }
4579 
4580 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4581 
4582 /**
4583  * @title CancelMarginCallDelegator
4584  * @author dYdX
4585  *
4586  * Interface that smart contracts must implement in order to let other addresses cancel a
4587  * margin-call for a loan owned by the smart contract.
4588  *
4589  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4590  *       to these functions
4591  */
4592 interface CancelMarginCallDelegator {
4593 
4594     // ============ Public Interface functions ============
4595 
4596     /**
4597      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4598      *
4599      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4600      * either revert the entire transaction or that the margin-call was successfully canceled.
4601      *
4602      * @param  canceler    Address of the caller of the cancelMarginCall function
4603      * @param  positionId  Unique ID of the position
4604      * @return             This address to accept, a different address to ask that contract
4605      */
4606     function cancelMarginCallOnBehalfOf(
4607         address canceler,
4608         bytes32 positionId
4609     )
4610         external
4611         /* onlyMargin */
4612         returns (address);
4613 }
4614 
4615 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4616 
4617 /**
4618  * @title MarginCallDelegator
4619  * @author dYdX
4620  *
4621  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4622  * owned by the smart contract.
4623  *
4624  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4625  *       to these functions
4626  */
4627 interface MarginCallDelegator {
4628 
4629     // ============ Public Interface functions ============
4630 
4631     /**
4632      * Function a contract must implement in order to let other addresses call marginCall().
4633      *
4634      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4635      * either revert the entire transaction or that the loan was successfully margin-called.
4636      *
4637      * @param  caller         Address of the caller of the marginCall function
4638      * @param  positionId     Unique ID of the position
4639      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4640      * @return                This address to accept, a different address to ask that contract
4641      */
4642     function marginCallOnBehalfOf(
4643         address caller,
4644         bytes32 positionId,
4645         uint256 depositAmount
4646     )
4647         external
4648         /* onlyMargin */
4649         returns (address);
4650 }
4651 
4652 // File: contracts/margin/impl/LoanImpl.sol
4653 
4654 /**
4655  * @title LoanImpl
4656  * @author dYdX
4657  *
4658  * This library contains the implementation for the following functions of Margin:
4659  *
4660  *      - marginCall
4661  *      - cancelMarginCallImpl
4662  *      - cancelLoanOffering
4663  */
4664 library LoanImpl {
4665     using SafeMath for uint256;
4666 
4667     // ============ Events ============
4668 
4669     /**
4670      * A position was margin-called
4671      */
4672     event MarginCallInitiated(
4673         bytes32 indexed positionId,
4674         address indexed lender,
4675         address indexed owner,
4676         uint256 requiredDeposit
4677     );
4678 
4679     /**
4680      * A margin call was canceled
4681      */
4682     event MarginCallCanceled(
4683         bytes32 indexed positionId,
4684         address indexed lender,
4685         address indexed owner,
4686         uint256 depositAmount
4687     );
4688 
4689     /**
4690      * A loan offering was canceled before it was used. Any amount less than the
4691      * total for the loan offering can be canceled.
4692      */
4693     event LoanOfferingCanceled(
4694         bytes32 indexed loanHash,
4695         address indexed payer,
4696         address indexed feeRecipient,
4697         uint256 cancelAmount
4698     );
4699 
4700     // ============ Public Implementation Functions ============
4701 
4702     function marginCallImpl(
4703         MarginState.State storage state,
4704         bytes32 positionId,
4705         uint256 requiredDeposit
4706     )
4707         public
4708     {
4709         MarginCommon.Position storage position =
4710             MarginCommon.getPositionFromStorage(state, positionId);
4711 
4712         require(
4713             position.callTimestamp == 0,
4714             "LoanImpl#marginCallImpl: The position has already been margin-called"
4715         );
4716 
4717         // Ensure lender consent
4718         marginCallOnBehalfOfRecurse(
4719             position.lender,
4720             msg.sender,
4721             positionId,
4722             requiredDeposit
4723         );
4724 
4725         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4726         position.requiredDeposit = requiredDeposit;
4727 
4728         emit MarginCallInitiated(
4729             positionId,
4730             position.lender,
4731             position.owner,
4732             requiredDeposit
4733         );
4734     }
4735 
4736     function cancelMarginCallImpl(
4737         MarginState.State storage state,
4738         bytes32 positionId
4739     )
4740         public
4741     {
4742         MarginCommon.Position storage position =
4743             MarginCommon.getPositionFromStorage(state, positionId);
4744 
4745         require(
4746             position.callTimestamp > 0,
4747             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4748         );
4749 
4750         // Ensure lender consent
4751         cancelMarginCallOnBehalfOfRecurse(
4752             position.lender,
4753             msg.sender,
4754             positionId
4755         );
4756 
4757         state.positions[positionId].callTimestamp = 0;
4758         state.positions[positionId].requiredDeposit = 0;
4759 
4760         emit MarginCallCanceled(
4761             positionId,
4762             position.lender,
4763             position.owner,
4764             0
4765         );
4766     }
4767 
4768     function cancelLoanOfferingImpl(
4769         MarginState.State storage state,
4770         address[9] addresses,
4771         uint256[7] values256,
4772         uint32[4]  values32,
4773         uint256    cancelAmount
4774     )
4775         public
4776         returns (uint256)
4777     {
4778         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4779             addresses,
4780             values256,
4781             values32
4782         );
4783 
4784         require(
4785             msg.sender == loanOffering.payer,
4786             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4787         );
4788         require(
4789             loanOffering.expirationTimestamp > block.timestamp,
4790             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4791         );
4792 
4793         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4794             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4795         );
4796         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4797 
4798         // If the loan was already fully canceled, then just return 0 amount was canceled
4799         if (amountToCancel == 0) {
4800             return 0;
4801         }
4802 
4803         state.loanCancels[loanOffering.loanHash] =
4804             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4805 
4806         emit LoanOfferingCanceled(
4807             loanOffering.loanHash,
4808             loanOffering.payer,
4809             loanOffering.feeRecipient,
4810             amountToCancel
4811         );
4812 
4813         return amountToCancel;
4814     }
4815 
4816     // ============ Private Helper-Functions ============
4817 
4818     function marginCallOnBehalfOfRecurse(
4819         address contractAddr,
4820         address who,
4821         bytes32 positionId,
4822         uint256 requiredDeposit
4823     )
4824         private
4825     {
4826         // no need to ask for permission
4827         if (who == contractAddr) {
4828             return;
4829         }
4830 
4831         address newContractAddr =
4832             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4833                 msg.sender,
4834                 positionId,
4835                 requiredDeposit
4836             );
4837 
4838         if (newContractAddr != contractAddr) {
4839             marginCallOnBehalfOfRecurse(
4840                 newContractAddr,
4841                 who,
4842                 positionId,
4843                 requiredDeposit
4844             );
4845         }
4846     }
4847 
4848     function cancelMarginCallOnBehalfOfRecurse(
4849         address contractAddr,
4850         address who,
4851         bytes32 positionId
4852     )
4853         private
4854     {
4855         // no need to ask for permission
4856         if (who == contractAddr) {
4857             return;
4858         }
4859 
4860         address newContractAddr =
4861             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4862                 msg.sender,
4863                 positionId
4864             );
4865 
4866         if (newContractAddr != contractAddr) {
4867             cancelMarginCallOnBehalfOfRecurse(
4868                 newContractAddr,
4869                 who,
4870                 positionId
4871             );
4872         }
4873     }
4874 
4875     // ============ Parsing Functions ============
4876 
4877     function parseLoanOffering(
4878         address[9] addresses,
4879         uint256[7] values256,
4880         uint32[4]  values32
4881     )
4882         private
4883         view
4884         returns (MarginCommon.LoanOffering memory)
4885     {
4886         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4887             owedToken: addresses[0],
4888             heldToken: addresses[1],
4889             payer: addresses[2],
4890             owner: addresses[3],
4891             taker: addresses[4],
4892             positionOwner: addresses[5],
4893             feeRecipient: addresses[6],
4894             lenderFeeToken: addresses[7],
4895             takerFeeToken: addresses[8],
4896             rates: parseLoanOfferRates(values256, values32),
4897             expirationTimestamp: values256[5],
4898             callTimeLimit: values32[0],
4899             maxDuration: values32[1],
4900             salt: values256[6],
4901             loanHash: 0,
4902             signature: new bytes(0)
4903         });
4904 
4905         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4906 
4907         return loanOffering;
4908     }
4909 
4910     function parseLoanOfferRates(
4911         uint256[7] values256,
4912         uint32[4] values32
4913     )
4914         private
4915         pure
4916         returns (MarginCommon.LoanRates memory)
4917     {
4918         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4919             maxAmount: values256[0],
4920             minAmount: values256[1],
4921             minHeldToken: values256[2],
4922             interestRate: values32[2],
4923             lenderFee: values256[3],
4924             takerFee: values256[4],
4925             interestPeriod: values32[3]
4926         });
4927 
4928         return rates;
4929     }
4930 }
4931 
4932 // File: contracts/margin/impl/MarginAdmin.sol
4933 
4934 /**
4935  * @title MarginAdmin
4936  * @author dYdX
4937  *
4938  * Contains admin functions for the Margin contract
4939  * The owner can put Margin into various close-only modes, which will disallow new position creation
4940  */
4941 contract MarginAdmin is Ownable {
4942     // ============ Enums ============
4943 
4944     // All functionality enabled
4945     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4946 
4947     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4948     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4949     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4950 
4951     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4952     // forceRecoverCollateral)
4953     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4954 
4955     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4956     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4957 
4958     // This operation state (and any higher) is invalid
4959     uint8 private constant OPERATION_STATE_INVALID = 4;
4960 
4961     // ============ Events ============
4962 
4963     /**
4964      * Event indicating the operation state has changed
4965      */
4966     event OperationStateChanged(
4967         uint8 from,
4968         uint8 to
4969     );
4970 
4971     // ============ State Variables ============
4972 
4973     uint8 public operationState;
4974 
4975     // ============ Constructor ============
4976 
4977     constructor()
4978         public
4979         Ownable()
4980     {
4981         operationState = OPERATION_STATE_OPERATIONAL;
4982     }
4983 
4984     // ============ Modifiers ============
4985 
4986     modifier onlyWhileOperational() {
4987         require(
4988             operationState == OPERATION_STATE_OPERATIONAL,
4989             "MarginAdmin#onlyWhileOperational: Can only call while operational"
4990         );
4991         _;
4992     }
4993 
4994     modifier cancelLoanOfferingStateControl() {
4995         require(
4996             operationState == OPERATION_STATE_OPERATIONAL
4997             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
4998             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
4999         );
5000         _;
5001     }
5002 
5003     modifier closePositionStateControl() {
5004         require(
5005             operationState == OPERATION_STATE_OPERATIONAL
5006             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
5007             || operationState == OPERATION_STATE_CLOSE_ONLY,
5008             "MarginAdmin#closePositionStateControl: Invalid operation state"
5009         );
5010         _;
5011     }
5012 
5013     modifier closePositionDirectlyStateControl() {
5014         _;
5015     }
5016 
5017     // ============ Owner-Only State-Changing Functions ============
5018 
5019     function setOperationState(
5020         uint8 newState
5021     )
5022         external
5023         onlyOwner
5024     {
5025         require(
5026             newState < OPERATION_STATE_INVALID,
5027             "MarginAdmin#setOperationState: newState is not a valid operation state"
5028         );
5029 
5030         if (newState != operationState) {
5031             emit OperationStateChanged(
5032                 operationState,
5033                 newState
5034             );
5035             operationState = newState;
5036         }
5037     }
5038 }
5039 
5040 // File: contracts/margin/impl/MarginEvents.sol
5041 
5042 /**
5043  * @title MarginEvents
5044  * @author dYdX
5045  *
5046  * Contains events for the Margin contract.
5047  *
5048  * NOTE: Any Margin function libraries that use events will need to both define the event here
5049  *       and copy the event into the library itself as libraries don't support sharing events
5050  */
5051 contract MarginEvents {
5052     // ============ Events ============
5053 
5054     /**
5055      * A position was opened
5056      */
5057     event PositionOpened(
5058         bytes32 indexed positionId,
5059         address indexed trader,
5060         address indexed lender,
5061         bytes32 loanHash,
5062         address owedToken,
5063         address heldToken,
5064         address loanFeeRecipient,
5065         uint256 principal,
5066         uint256 heldTokenFromSell,
5067         uint256 depositAmount,
5068         uint256 interestRate,
5069         uint32  callTimeLimit,
5070         uint32  maxDuration,
5071         bool    depositInHeldToken
5072     );
5073 
5074     /*
5075      * A position was increased
5076      */
5077     event PositionIncreased(
5078         bytes32 indexed positionId,
5079         address indexed trader,
5080         address indexed lender,
5081         address positionOwner,
5082         address loanOwner,
5083         bytes32 loanHash,
5084         address loanFeeRecipient,
5085         uint256 amountBorrowed,
5086         uint256 principalAdded,
5087         uint256 heldTokenFromSell,
5088         uint256 depositAmount,
5089         bool    depositInHeldToken
5090     );
5091 
5092     /**
5093      * A position was closed or partially closed
5094      */
5095     event PositionClosed(
5096         bytes32 indexed positionId,
5097         address indexed closer,
5098         address indexed payoutRecipient,
5099         uint256 closeAmount,
5100         uint256 remainingAmount,
5101         uint256 owedTokenPaidToLender,
5102         uint256 payoutAmount,
5103         uint256 buybackCostInHeldToken,
5104         bool payoutInHeldToken
5105     );
5106 
5107     /**
5108      * Collateral for a position was forcibly recovered
5109      */
5110     event CollateralForceRecovered(
5111         bytes32 indexed positionId,
5112         address indexed recipient,
5113         uint256 amount
5114     );
5115 
5116     /**
5117      * A position was margin-called
5118      */
5119     event MarginCallInitiated(
5120         bytes32 indexed positionId,
5121         address indexed lender,
5122         address indexed owner,
5123         uint256 requiredDeposit
5124     );
5125 
5126     /**
5127      * A margin call was canceled
5128      */
5129     event MarginCallCanceled(
5130         bytes32 indexed positionId,
5131         address indexed lender,
5132         address indexed owner,
5133         uint256 depositAmount
5134     );
5135 
5136     /**
5137      * A loan offering was canceled before it was used. Any amount less than the
5138      * total for the loan offering can be canceled.
5139      */
5140     event LoanOfferingCanceled(
5141         bytes32 indexed loanHash,
5142         address indexed payer,
5143         address indexed feeRecipient,
5144         uint256 cancelAmount
5145     );
5146 
5147     /**
5148      * Additional collateral for a position was posted by the owner
5149      */
5150     event AdditionalCollateralDeposited(
5151         bytes32 indexed positionId,
5152         uint256 amount,
5153         address depositor
5154     );
5155 
5156     /**
5157      * Ownership of a loan was transferred to a new address
5158      */
5159     event LoanTransferred(
5160         bytes32 indexed positionId,
5161         address indexed from,
5162         address indexed to
5163     );
5164 
5165     /**
5166      * Ownership of a position was transferred to a new address
5167      */
5168     event PositionTransferred(
5169         bytes32 indexed positionId,
5170         address indexed from,
5171         address indexed to
5172     );
5173 }
5174 
5175 // File: contracts/margin/impl/OpenPositionImpl.sol
5176 
5177 /**
5178  * @title OpenPositionImpl
5179  * @author dYdX
5180  *
5181  * This library contains the implementation for the openPosition function of Margin
5182  */
5183 library OpenPositionImpl {
5184     using SafeMath for uint256;
5185 
5186     // ============ Events ============
5187 
5188     /**
5189      * A position was opened
5190      */
5191     event PositionOpened(
5192         bytes32 indexed positionId,
5193         address indexed trader,
5194         address indexed lender,
5195         bytes32 loanHash,
5196         address owedToken,
5197         address heldToken,
5198         address loanFeeRecipient,
5199         uint256 principal,
5200         uint256 heldTokenFromSell,
5201         uint256 depositAmount,
5202         uint256 interestRate,
5203         uint32  callTimeLimit,
5204         uint32  maxDuration,
5205         bool    depositInHeldToken
5206     );
5207 
5208     // ============ Public Implementation Functions ============
5209 
5210     function openPositionImpl(
5211         MarginState.State storage state,
5212         address[11] addresses,
5213         uint256[10] values256,
5214         uint32[4] values32,
5215         bool depositInHeldToken,
5216         bytes signature,
5217         bytes orderData
5218     )
5219         public
5220         returns (bytes32)
5221     {
5222         BorrowShared.Tx memory transaction = parseOpenTx(
5223             addresses,
5224             values256,
5225             values32,
5226             depositInHeldToken,
5227             signature
5228         );
5229 
5230         require(
5231             !MarginCommon.positionHasExisted(state, transaction.positionId),
5232             "OpenPositionImpl#openPositionImpl: positionId already exists"
5233         );
5234 
5235         doBorrowAndSell(state, transaction, orderData);
5236 
5237         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5238         recordPositionOpened(
5239             transaction
5240         );
5241 
5242         doStoreNewPosition(
5243             state,
5244             transaction
5245         );
5246 
5247         return transaction.positionId;
5248     }
5249 
5250     // ============ Private Helper-Functions ============
5251 
5252     function doBorrowAndSell(
5253         MarginState.State storage state,
5254         BorrowShared.Tx memory transaction,
5255         bytes orderData
5256     )
5257         private
5258     {
5259         BorrowShared.validateTxPreSell(state, transaction);
5260 
5261         if (transaction.depositInHeldToken) {
5262             BorrowShared.doDepositHeldToken(state, transaction);
5263         } else {
5264             BorrowShared.doDepositOwedToken(state, transaction);
5265         }
5266 
5267         transaction.heldTokenFromSell = BorrowShared.doSell(
5268             state,
5269             transaction,
5270             orderData,
5271             MathHelpers.maxUint256()
5272         );
5273 
5274         BorrowShared.doPostSell(state, transaction);
5275     }
5276 
5277     function doStoreNewPosition(
5278         MarginState.State storage state,
5279         BorrowShared.Tx memory transaction
5280     )
5281         private
5282     {
5283         MarginCommon.storeNewPosition(
5284             state,
5285             transaction.positionId,
5286             MarginCommon.Position({
5287                 owedToken: transaction.loanOffering.owedToken,
5288                 heldToken: transaction.loanOffering.heldToken,
5289                 lender: transaction.loanOffering.owner,
5290                 owner: transaction.owner,
5291                 principal: transaction.principal,
5292                 requiredDeposit: 0,
5293                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5294                 startTimestamp: 0,
5295                 callTimestamp: 0,
5296                 maxDuration: transaction.loanOffering.maxDuration,
5297                 interestRate: transaction.loanOffering.rates.interestRate,
5298                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5299             }),
5300             transaction.loanOffering.payer
5301         );
5302     }
5303 
5304     function recordPositionOpened(
5305         BorrowShared.Tx transaction
5306     )
5307         private
5308     {
5309         emit PositionOpened(
5310             transaction.positionId,
5311             msg.sender,
5312             transaction.loanOffering.payer,
5313             transaction.loanOffering.loanHash,
5314             transaction.loanOffering.owedToken,
5315             transaction.loanOffering.heldToken,
5316             transaction.loanOffering.feeRecipient,
5317             transaction.principal,
5318             transaction.heldTokenFromSell,
5319             transaction.depositAmount,
5320             transaction.loanOffering.rates.interestRate,
5321             transaction.loanOffering.callTimeLimit,
5322             transaction.loanOffering.maxDuration,
5323             transaction.depositInHeldToken
5324         );
5325     }
5326 
5327     // ============ Parsing Functions ============
5328 
5329     function parseOpenTx(
5330         address[11] addresses,
5331         uint256[10] values256,
5332         uint32[4] values32,
5333         bool depositInHeldToken,
5334         bytes signature
5335     )
5336         private
5337         view
5338         returns (BorrowShared.Tx memory)
5339     {
5340         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5341             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5342             owner: addresses[0],
5343             principal: values256[7],
5344             lenderAmount: values256[7],
5345             loanOffering: parseLoanOffering(
5346                 addresses,
5347                 values256,
5348                 values32,
5349                 signature
5350             ),
5351             exchangeWrapper: addresses[10],
5352             depositInHeldToken: depositInHeldToken,
5353             depositAmount: values256[8],
5354             collateralAmount: 0, // set later
5355             heldTokenFromSell: 0 // set later
5356         });
5357 
5358         return transaction;
5359     }
5360 
5361     function parseLoanOffering(
5362         address[11] addresses,
5363         uint256[10] values256,
5364         uint32[4]   values32,
5365         bytes       signature
5366     )
5367         private
5368         view
5369         returns (MarginCommon.LoanOffering memory)
5370     {
5371         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5372             owedToken: addresses[1],
5373             heldToken: addresses[2],
5374             payer: addresses[3],
5375             owner: addresses[4],
5376             taker: addresses[5],
5377             positionOwner: addresses[6],
5378             feeRecipient: addresses[7],
5379             lenderFeeToken: addresses[8],
5380             takerFeeToken: addresses[9],
5381             rates: parseLoanOfferRates(values256, values32),
5382             expirationTimestamp: values256[5],
5383             callTimeLimit: values32[0],
5384             maxDuration: values32[1],
5385             salt: values256[6],
5386             loanHash: 0,
5387             signature: signature
5388         });
5389 
5390         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5391 
5392         return loanOffering;
5393     }
5394 
5395     function parseLoanOfferRates(
5396         uint256[10] values256,
5397         uint32[4] values32
5398     )
5399         private
5400         pure
5401         returns (MarginCommon.LoanRates memory)
5402     {
5403         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5404             maxAmount: values256[0],
5405             minAmount: values256[1],
5406             minHeldToken: values256[2],
5407             lenderFee: values256[3],
5408             takerFee: values256[4],
5409             interestRate: values32[2],
5410             interestPeriod: values32[3]
5411         });
5412 
5413         return rates;
5414     }
5415 }
5416 
5417 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5418 
5419 /**
5420  * @title OpenWithoutCounterpartyImpl
5421  * @author dYdX
5422  *
5423  * This library contains the implementation for the openWithoutCounterparty
5424  * function of Margin
5425  */
5426 library OpenWithoutCounterpartyImpl {
5427 
5428     // ============ Structs ============
5429 
5430     struct Tx {
5431         bytes32 positionId;
5432         address positionOwner;
5433         address owedToken;
5434         address heldToken;
5435         address loanOwner;
5436         uint256 principal;
5437         uint256 deposit;
5438         uint32 callTimeLimit;
5439         uint32 maxDuration;
5440         uint32 interestRate;
5441         uint32 interestPeriod;
5442     }
5443 
5444     // ============ Events ============
5445 
5446     /**
5447      * A position was opened
5448      */
5449     event PositionOpened(
5450         bytes32 indexed positionId,
5451         address indexed trader,
5452         address indexed lender,
5453         bytes32 loanHash,
5454         address owedToken,
5455         address heldToken,
5456         address loanFeeRecipient,
5457         uint256 principal,
5458         uint256 heldTokenFromSell,
5459         uint256 depositAmount,
5460         uint256 interestRate,
5461         uint32  callTimeLimit,
5462         uint32  maxDuration,
5463         bool    depositInHeldToken
5464     );
5465 
5466     // ============ Public Implementation Functions ============
5467 
5468     function openWithoutCounterpartyImpl(
5469         MarginState.State storage state,
5470         address[4] addresses,
5471         uint256[3] values256,
5472         uint32[4]  values32
5473     )
5474         public
5475         returns (bytes32)
5476     {
5477         Tx memory openTx = parseTx(
5478             addresses,
5479             values256,
5480             values32
5481         );
5482 
5483         validate(
5484             state,
5485             openTx
5486         );
5487 
5488         Vault(state.VAULT).transferToVault(
5489             openTx.positionId,
5490             openTx.heldToken,
5491             msg.sender,
5492             openTx.deposit
5493         );
5494 
5495         recordPositionOpened(
5496             openTx
5497         );
5498 
5499         doStoreNewPosition(
5500             state,
5501             openTx
5502         );
5503 
5504         return openTx.positionId;
5505     }
5506 
5507     // ============ Private Helper-Functions ============
5508 
5509     function doStoreNewPosition(
5510         MarginState.State storage state,
5511         Tx memory openTx
5512     )
5513         private
5514     {
5515         MarginCommon.storeNewPosition(
5516             state,
5517             openTx.positionId,
5518             MarginCommon.Position({
5519                 owedToken: openTx.owedToken,
5520                 heldToken: openTx.heldToken,
5521                 lender: openTx.loanOwner,
5522                 owner: openTx.positionOwner,
5523                 principal: openTx.principal,
5524                 requiredDeposit: 0,
5525                 callTimeLimit: openTx.callTimeLimit,
5526                 startTimestamp: 0,
5527                 callTimestamp: 0,
5528                 maxDuration: openTx.maxDuration,
5529                 interestRate: openTx.interestRate,
5530                 interestPeriod: openTx.interestPeriod
5531             }),
5532             msg.sender
5533         );
5534     }
5535 
5536     function validate(
5537         MarginState.State storage state,
5538         Tx memory openTx
5539     )
5540         private
5541         view
5542     {
5543         require(
5544             !MarginCommon.positionHasExisted(state, openTx.positionId),
5545             "openWithoutCounterpartyImpl#validate: positionId already exists"
5546         );
5547 
5548         require(
5549             openTx.principal > 0,
5550             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5551         );
5552 
5553         require(
5554             openTx.owedToken != address(0),
5555             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5556         );
5557 
5558         require(
5559             openTx.owedToken != openTx.heldToken,
5560             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5561         );
5562 
5563         require(
5564             openTx.positionOwner != address(0),
5565             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5566         );
5567 
5568         require(
5569             openTx.loanOwner != address(0),
5570             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5571         );
5572 
5573         require(
5574             openTx.maxDuration > 0,
5575             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5576         );
5577 
5578         require(
5579             openTx.interestPeriod <= openTx.maxDuration,
5580             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5581         );
5582     }
5583 
5584     function recordPositionOpened(
5585         Tx memory openTx
5586     )
5587         private
5588     {
5589         emit PositionOpened(
5590             openTx.positionId,
5591             msg.sender,
5592             msg.sender,
5593             bytes32(0),
5594             openTx.owedToken,
5595             openTx.heldToken,
5596             address(0),
5597             openTx.principal,
5598             0,
5599             openTx.deposit,
5600             openTx.interestRate,
5601             openTx.callTimeLimit,
5602             openTx.maxDuration,
5603             true
5604         );
5605     }
5606 
5607     // ============ Parsing Functions ============
5608 
5609     function parseTx(
5610         address[4] addresses,
5611         uint256[3] values256,
5612         uint32[4]  values32
5613     )
5614         private
5615         view
5616         returns (Tx memory)
5617     {
5618         Tx memory openTx = Tx({
5619             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5620             positionOwner: addresses[0],
5621             owedToken: addresses[1],
5622             heldToken: addresses[2],
5623             loanOwner: addresses[3],
5624             principal: values256[0],
5625             deposit: values256[1],
5626             callTimeLimit: values32[0],
5627             maxDuration: values32[1],
5628             interestRate: values32[2],
5629             interestPeriod: values32[3]
5630         });
5631 
5632         return openTx;
5633     }
5634 }
5635 
5636 // File: contracts/margin/impl/PositionGetters.sol
5637 
5638 /**
5639  * @title PositionGetters
5640  * @author dYdX
5641  *
5642  * A collection of public constant getter functions that allows reading of the state of any position
5643  * stored in the dYdX protocol.
5644  */
5645 contract PositionGetters is MarginStorage {
5646     using SafeMath for uint256;
5647 
5648     // ============ Public Constant Functions ============
5649 
5650     /**
5651      * Gets if a position is currently open.
5652      *
5653      * @param  positionId  Unique ID of the position
5654      * @return             True if the position is exists and is open
5655      */
5656     function containsPosition(
5657         bytes32 positionId
5658     )
5659         external
5660         view
5661         returns (bool)
5662     {
5663         return MarginCommon.containsPositionImpl(state, positionId);
5664     }
5665 
5666     /**
5667      * Gets if a position is currently margin-called.
5668      *
5669      * @param  positionId  Unique ID of the position
5670      * @return             True if the position is margin-called
5671      */
5672     function isPositionCalled(
5673         bytes32 positionId
5674     )
5675         external
5676         view
5677         returns (bool)
5678     {
5679         return (state.positions[positionId].callTimestamp > 0);
5680     }
5681 
5682     /**
5683      * Gets if a position was previously open and is now closed.
5684      *
5685      * @param  positionId  Unique ID of the position
5686      * @return             True if the position is now closed
5687      */
5688     function isPositionClosed(
5689         bytes32 positionId
5690     )
5691         external
5692         view
5693         returns (bool)
5694     {
5695         return state.closedPositions[positionId];
5696     }
5697 
5698     /**
5699      * Gets the total amount of owedToken ever repaid to the lender for a position.
5700      *
5701      * @param  positionId  Unique ID of the position
5702      * @return             Total amount of owedToken ever repaid
5703      */
5704     function getTotalOwedTokenRepaidToLender(
5705         bytes32 positionId
5706     )
5707         external
5708         view
5709         returns (uint256)
5710     {
5711         return state.totalOwedTokenRepaidToLender[positionId];
5712     }
5713 
5714     /**
5715      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5716      *
5717      * @param  positionId  Unique ID of the position
5718      * @return             The amount of heldToken
5719      */
5720     function getPositionBalance(
5721         bytes32 positionId
5722     )
5723         external
5724         view
5725         returns (uint256)
5726     {
5727         return MarginCommon.getPositionBalanceImpl(state, positionId);
5728     }
5729 
5730     /**
5731      * Gets the time until the interest fee charged for the position will increase.
5732      * Returns 1 if the interest fee increases every second.
5733      * Returns 0 if the interest fee will never increase again.
5734      *
5735      * @param  positionId  Unique ID of the position
5736      * @return             The number of seconds until the interest fee will increase
5737      */
5738     function getTimeUntilInterestIncrease(
5739         bytes32 positionId
5740     )
5741         external
5742         view
5743         returns (uint256)
5744     {
5745         MarginCommon.Position storage position =
5746             MarginCommon.getPositionFromStorage(state, positionId);
5747 
5748         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5749             position,
5750             block.timestamp
5751         );
5752 
5753         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5754         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5755             return 0;
5756         } else {
5757             // nextStep is the final second at which the calculated interest fee is the same as it
5758             // is currently, so add 1 to get the correct value
5759             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5760         }
5761     }
5762 
5763     /**
5764      * Gets the amount of owedTokens currently needed to close the position completely, including
5765      * interest fees.
5766      *
5767      * @param  positionId  Unique ID of the position
5768      * @return             The number of owedTokens
5769      */
5770     function getPositionOwedAmount(
5771         bytes32 positionId
5772     )
5773         external
5774         view
5775         returns (uint256)
5776     {
5777         MarginCommon.Position storage position =
5778             MarginCommon.getPositionFromStorage(state, positionId);
5779 
5780         return MarginCommon.calculateOwedAmount(
5781             position,
5782             position.principal,
5783             block.timestamp
5784         );
5785     }
5786 
5787     /**
5788      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5789      * given time, including interest fees.
5790      *
5791      * @param  positionId         Unique ID of the position
5792      * @param  principalToClose   Amount of principal being closed
5793      * @param  timestamp          Block timestamp in seconds of close
5794      * @return                    The number of owedTokens owed
5795      */
5796     function getPositionOwedAmountAtTime(
5797         bytes32 positionId,
5798         uint256 principalToClose,
5799         uint32  timestamp
5800     )
5801         external
5802         view
5803         returns (uint256)
5804     {
5805         MarginCommon.Position storage position =
5806             MarginCommon.getPositionFromStorage(state, positionId);
5807 
5808         require(
5809             timestamp >= position.startTimestamp,
5810             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5811         );
5812 
5813         return MarginCommon.calculateOwedAmount(
5814             position,
5815             principalToClose,
5816             timestamp
5817         );
5818     }
5819 
5820     /**
5821      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5822      * amount to the position at a given time.
5823      *
5824      * @param  positionId      Unique ID of the position
5825      * @param  principalToAdd  Amount being added to principal
5826      * @param  timestamp       Block timestamp in seconds of addition
5827      * @return                 The number of owedTokens that will be borrowed
5828      */
5829     function getLenderAmountForIncreasePositionAtTime(
5830         bytes32 positionId,
5831         uint256 principalToAdd,
5832         uint32  timestamp
5833     )
5834         external
5835         view
5836         returns (uint256)
5837     {
5838         MarginCommon.Position storage position =
5839             MarginCommon.getPositionFromStorage(state, positionId);
5840 
5841         require(
5842             timestamp >= position.startTimestamp,
5843             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5844         );
5845 
5846         return MarginCommon.calculateLenderAmountForIncreasePosition(
5847             position,
5848             principalToAdd,
5849             timestamp
5850         );
5851     }
5852 
5853     // ============ All Properties ============
5854 
5855     /**
5856      * Get a Position by id. This does not validate the position exists. If the position does not
5857      * exist, all 0's will be returned.
5858      *
5859      * @param  positionId  Unique ID of the position
5860      * @return             Addresses corresponding to:
5861      *
5862      *                     [0] = owedToken
5863      *                     [1] = heldToken
5864      *                     [2] = lender
5865      *                     [3] = owner
5866      *
5867      *                     Values corresponding to:
5868      *
5869      *                     [0] = principal
5870      *                     [1] = requiredDeposit
5871      *
5872      *                     Values corresponding to:
5873      *
5874      *                     [0] = callTimeLimit
5875      *                     [1] = startTimestamp
5876      *                     [2] = callTimestamp
5877      *                     [3] = maxDuration
5878      *                     [4] = interestRate
5879      *                     [5] = interestPeriod
5880      */
5881     function getPosition(
5882         bytes32 positionId
5883     )
5884         external
5885         view
5886         returns (
5887             address[4],
5888             uint256[2],
5889             uint32[6]
5890         )
5891     {
5892         MarginCommon.Position storage position = state.positions[positionId];
5893 
5894         return (
5895             [
5896                 position.owedToken,
5897                 position.heldToken,
5898                 position.lender,
5899                 position.owner
5900             ],
5901             [
5902                 position.principal,
5903                 position.requiredDeposit
5904             ],
5905             [
5906                 position.callTimeLimit,
5907                 position.startTimestamp,
5908                 position.callTimestamp,
5909                 position.maxDuration,
5910                 position.interestRate,
5911                 position.interestPeriod
5912             ]
5913         );
5914     }
5915 
5916     // ============ Individual Properties ============
5917 
5918     function getPositionLender(
5919         bytes32 positionId
5920     )
5921         external
5922         view
5923         returns (address)
5924     {
5925         return state.positions[positionId].lender;
5926     }
5927 
5928     function getPositionOwner(
5929         bytes32 positionId
5930     )
5931         external
5932         view
5933         returns (address)
5934     {
5935         return state.positions[positionId].owner;
5936     }
5937 
5938     function getPositionHeldToken(
5939         bytes32 positionId
5940     )
5941         external
5942         view
5943         returns (address)
5944     {
5945         return state.positions[positionId].heldToken;
5946     }
5947 
5948     function getPositionOwedToken(
5949         bytes32 positionId
5950     )
5951         external
5952         view
5953         returns (address)
5954     {
5955         return state.positions[positionId].owedToken;
5956     }
5957 
5958     function getPositionPrincipal(
5959         bytes32 positionId
5960     )
5961         external
5962         view
5963         returns (uint256)
5964     {
5965         return state.positions[positionId].principal;
5966     }
5967 
5968     function getPositionInterestRate(
5969         bytes32 positionId
5970     )
5971         external
5972         view
5973         returns (uint256)
5974     {
5975         return state.positions[positionId].interestRate;
5976     }
5977 
5978     function getPositionRequiredDeposit(
5979         bytes32 positionId
5980     )
5981         external
5982         view
5983         returns (uint256)
5984     {
5985         return state.positions[positionId].requiredDeposit;
5986     }
5987 
5988     function getPositionStartTimestamp(
5989         bytes32 positionId
5990     )
5991         external
5992         view
5993         returns (uint32)
5994     {
5995         return state.positions[positionId].startTimestamp;
5996     }
5997 
5998     function getPositionCallTimestamp(
5999         bytes32 positionId
6000     )
6001         external
6002         view
6003         returns (uint32)
6004     {
6005         return state.positions[positionId].callTimestamp;
6006     }
6007 
6008     function getPositionCallTimeLimit(
6009         bytes32 positionId
6010     )
6011         external
6012         view
6013         returns (uint32)
6014     {
6015         return state.positions[positionId].callTimeLimit;
6016     }
6017 
6018     function getPositionMaxDuration(
6019         bytes32 positionId
6020     )
6021         external
6022         view
6023         returns (uint32)
6024     {
6025         return state.positions[positionId].maxDuration;
6026     }
6027 
6028     function getPositioninterestPeriod(
6029         bytes32 positionId
6030     )
6031         external
6032         view
6033         returns (uint32)
6034     {
6035         return state.positions[positionId].interestPeriod;
6036     }
6037 }
6038 
6039 // File: contracts/margin/impl/TransferImpl.sol
6040 
6041 /**
6042  * @title TransferImpl
6043  * @author dYdX
6044  *
6045  * This library contains the implementation for the transferPosition and transferLoan functions of
6046  * Margin
6047  */
6048 library TransferImpl {
6049 
6050     // ============ Public Implementation Functions ============
6051 
6052     function transferLoanImpl(
6053         MarginState.State storage state,
6054         bytes32 positionId,
6055         address newLender
6056     )
6057         public
6058     {
6059         require(
6060             MarginCommon.containsPositionImpl(state, positionId),
6061             "TransferImpl#transferLoanImpl: Position does not exist"
6062         );
6063 
6064         address originalLender = state.positions[positionId].lender;
6065 
6066         require(
6067             msg.sender == originalLender,
6068             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
6069         );
6070         require(
6071             newLender != originalLender,
6072             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
6073         );
6074 
6075         // Doesn't change the state of positionId; figures out the final owner of loan.
6076         // That is, newLender may pass ownership to a different address.
6077         address finalLender = TransferInternal.grantLoanOwnership(
6078             positionId,
6079             originalLender,
6080             newLender);
6081 
6082         require(
6083             finalLender != originalLender,
6084             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
6085         );
6086 
6087         // Set state only after resolving the new owner (to reduce the number of storage calls)
6088         state.positions[positionId].lender = finalLender;
6089     }
6090 
6091     function transferPositionImpl(
6092         MarginState.State storage state,
6093         bytes32 positionId,
6094         address newOwner
6095     )
6096         public
6097     {
6098         require(
6099             MarginCommon.containsPositionImpl(state, positionId),
6100             "TransferImpl#transferPositionImpl: Position does not exist"
6101         );
6102 
6103         address originalOwner = state.positions[positionId].owner;
6104 
6105         require(
6106             msg.sender == originalOwner,
6107             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
6108         );
6109         require(
6110             newOwner != originalOwner,
6111             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
6112         );
6113 
6114         // Doesn't change the state of positionId; figures out the final owner of position.
6115         // That is, newOwner may pass ownership to a different address.
6116         address finalOwner = TransferInternal.grantPositionOwnership(
6117             positionId,
6118             originalOwner,
6119             newOwner);
6120 
6121         require(
6122             finalOwner != originalOwner,
6123             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
6124         );
6125 
6126         // Set state only after resolving the new owner (to reduce the number of storage calls)
6127         state.positions[positionId].owner = finalOwner;
6128     }
6129 }
6130 
6131 // File: contracts/margin/Margin.sol
6132 
6133 /**
6134  * @title Margin
6135  * @author dYdX
6136  *
6137  * This contract is used to facilitate margin trading as per the dYdX protocol
6138  */
6139 contract Margin is
6140     ReentrancyGuard,
6141     MarginStorage,
6142     MarginEvents,
6143     MarginAdmin,
6144     LoanGetters,
6145     PositionGetters
6146 {
6147 
6148     using SafeMath for uint256;
6149 
6150     // ============ Constructor ============
6151 
6152     constructor(
6153         address vault,
6154         address proxy
6155     )
6156         public
6157         MarginAdmin()
6158     {
6159         state = MarginState.State({
6160             VAULT: vault,
6161             TOKEN_PROXY: proxy
6162         });
6163     }
6164 
6165     // ============ Public State Changing Functions ============
6166 
6167     /**
6168      * Open a margin position. Called by the margin trader who must provide both a
6169      * signed loan offering as well as a DEX Order with which to sell the owedToken.
6170      *
6171      * @param  addresses           Addresses corresponding to:
6172      *
6173      *  [0]  = position owner
6174      *  [1]  = owedToken
6175      *  [2]  = heldToken
6176      *  [3]  = loan payer
6177      *  [4]  = loan owner
6178      *  [5]  = loan taker
6179      *  [6]  = loan position owner
6180      *  [7]  = loan fee recipient
6181      *  [8]  = loan lender fee token
6182      *  [9]  = loan taker fee token
6183      *  [10]  = exchange wrapper address
6184      *
6185      * @param  values256           Values corresponding to:
6186      *
6187      *  [0]  = loan maximum amount
6188      *  [1]  = loan minimum amount
6189      *  [2]  = loan minimum heldToken
6190      *  [3]  = loan lender fee
6191      *  [4]  = loan taker fee
6192      *  [5]  = loan expiration timestamp (in seconds)
6193      *  [6]  = loan salt
6194      *  [7]  = position amount of principal
6195      *  [8]  = deposit amount
6196      *  [9]  = nonce (used to calculate positionId)
6197      *
6198      * @param  values32            Values corresponding to:
6199      *
6200      *  [0] = loan call time limit (in seconds)
6201      *  [1] = loan maxDuration (in seconds)
6202      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6203      *  [3] = loan interest update period (in seconds)
6204      *
6205      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6206      *                             False if the margin deposit will be in owedToken
6207      *                             and then sold along with the owedToken borrowed from the lender
6208      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6209      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6210      *                             is a smart contract, these are arbitrary bytes that the contract
6211      *                             will recieve when choosing whether to approve the loan.
6212      * @param  order               Order object to be passed to the exchange wrapper
6213      * @return                     Unique ID for the new position
6214      */
6215     function openPosition(
6216         address[11] addresses,
6217         uint256[10] values256,
6218         uint32[4]   values32,
6219         bool        depositInHeldToken,
6220         bytes       signature,
6221         bytes       order
6222     )
6223         external
6224         onlyWhileOperational
6225         nonReentrant
6226         returns (bytes32)
6227     {
6228         return OpenPositionImpl.openPositionImpl(
6229             state,
6230             addresses,
6231             values256,
6232             values32,
6233             depositInHeldToken,
6234             signature,
6235             order
6236         );
6237     }
6238 
6239     /**
6240      * Open a margin position without a counterparty. The caller will serve as both the
6241      * lender and the position owner
6242      *
6243      * @param  addresses    Addresses corresponding to:
6244      *
6245      *  [0]  = position owner
6246      *  [1]  = owedToken
6247      *  [2]  = heldToken
6248      *  [3]  = loan owner
6249      *
6250      * @param  values256    Values corresponding to:
6251      *
6252      *  [0]  = principal
6253      *  [1]  = deposit amount
6254      *  [2]  = nonce (used to calculate positionId)
6255      *
6256      * @param  values32     Values corresponding to:
6257      *
6258      *  [0] = call time limit (in seconds)
6259      *  [1] = maxDuration (in seconds)
6260      *  [2] = interest rate (annual nominal percentage times 10**6)
6261      *  [3] = interest update period (in seconds)
6262      *
6263      * @return              Unique ID for the new position
6264      */
6265     function openWithoutCounterparty(
6266         address[4] addresses,
6267         uint256[3] values256,
6268         uint32[4]  values32
6269     )
6270         external
6271         onlyWhileOperational
6272         nonReentrant
6273         returns (bytes32)
6274     {
6275         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6276             state,
6277             addresses,
6278             values256,
6279             values32
6280         );
6281     }
6282 
6283     /**
6284      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6285      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6286      * principal added, as it will incorporate interest already earned by the position so far.
6287      *
6288      * @param  positionId          Unique ID of the position
6289      * @param  addresses           Addresses corresponding to:
6290      *
6291      *  [0]  = loan payer
6292      *  [1]  = loan taker
6293      *  [2]  = loan position owner
6294      *  [3]  = loan fee recipient
6295      *  [4]  = loan lender fee token
6296      *  [5]  = loan taker fee token
6297      *  [6]  = exchange wrapper address
6298      *
6299      * @param  values256           Values corresponding to:
6300      *
6301      *  [0]  = loan maximum amount
6302      *  [1]  = loan minimum amount
6303      *  [2]  = loan minimum heldToken
6304      *  [3]  = loan lender fee
6305      *  [4]  = loan taker fee
6306      *  [5]  = loan expiration timestamp (in seconds)
6307      *  [6]  = loan salt
6308      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6309      *                                                           will be >= this amount)
6310      *
6311      * @param  values32            Values corresponding to:
6312      *
6313      *  [0] = loan call time limit (in seconds)
6314      *  [1] = loan maxDuration (in seconds)
6315      *
6316      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6317      *                             False if the margin deposit will be pulled in owedToken
6318      *                             and then sold along with the owedToken borrowed from the lender
6319      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6320      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6321      *                             is a smart contract, these are arbitrary bytes that the contract
6322      *                             will recieve when choosing whether to approve the loan.
6323      * @param  order               Order object to be passed to the exchange wrapper
6324      * @return                     Amount of owedTokens pulled from the lender
6325      */
6326     function increasePosition(
6327         bytes32    positionId,
6328         address[7] addresses,
6329         uint256[8] values256,
6330         uint32[2]  values32,
6331         bool       depositInHeldToken,
6332         bytes      signature,
6333         bytes      order
6334     )
6335         external
6336         onlyWhileOperational
6337         nonReentrant
6338         returns (uint256)
6339     {
6340         return IncreasePositionImpl.increasePositionImpl(
6341             state,
6342             positionId,
6343             addresses,
6344             values256,
6345             values32,
6346             depositInHeldToken,
6347             signature,
6348             order
6349         );
6350     }
6351 
6352     /**
6353      * Increase a position directly by putting up heldToken. The caller will serve as both the
6354      * lender and the position owner
6355      *
6356      * @param  positionId      Unique ID of the position
6357      * @param  principalToAdd  Principal amount to add to the position
6358      * @return                 Amount of heldToken pulled from the msg.sender
6359      */
6360     function increaseWithoutCounterparty(
6361         bytes32 positionId,
6362         uint256 principalToAdd
6363     )
6364         external
6365         onlyWhileOperational
6366         nonReentrant
6367         returns (uint256)
6368     {
6369         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6370             state,
6371             positionId,
6372             principalToAdd
6373         );
6374     }
6375 
6376     /**
6377      * Close a position. May be called by the owner or with the approval of the owner. May provide
6378      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6379      * is sent the resulting payout.
6380      *
6381      * @param  positionId            Unique ID of the position
6382      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6383      *                               closed is also bounded by:
6384      *                               1) The principal of the position
6385      *                               2) The amount allowed by the owner if closer != owner
6386      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6387      * @param  exchangeWrapper       Address of the exchange wrapper
6388      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6389      *                               False to pay out the payoutRecipient in owedToken
6390      * @param  order                 Order object to be passed to the exchange wrapper
6391      * @return                       Values corresponding to:
6392      *                               1) Principal of position closed
6393      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6394      *                                  owedToken otherwise) received by the payoutRecipient
6395      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6396      */
6397     function closePosition(
6398         bytes32 positionId,
6399         uint256 requestedCloseAmount,
6400         address payoutRecipient,
6401         address exchangeWrapper,
6402         bool    payoutInHeldToken,
6403         bytes   order
6404     )
6405         external
6406         closePositionStateControl
6407         nonReentrant
6408         returns (uint256, uint256, uint256)
6409     {
6410         return ClosePositionImpl.closePositionImpl(
6411             state,
6412             positionId,
6413             requestedCloseAmount,
6414             payoutRecipient,
6415             exchangeWrapper,
6416             payoutInHeldToken,
6417             order
6418         );
6419     }
6420 
6421     /**
6422      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6423      *
6424      * @param  positionId            Unique ID of the position
6425      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6426      *                               closed is also bounded by:
6427      *                               1) The principal of the position
6428      *                               2) The amount allowed by the owner if closer != owner
6429      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6430      * @return                       Values corresponding to:
6431      *                               1) Principal amount of position closed
6432      *                               2) Amount of heldToken received by the payoutRecipient
6433      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6434      */
6435     function closePositionDirectly(
6436         bytes32 positionId,
6437         uint256 requestedCloseAmount,
6438         address payoutRecipient
6439     )
6440         external
6441         closePositionDirectlyStateControl
6442         nonReentrant
6443         returns (uint256, uint256, uint256)
6444     {
6445         return ClosePositionImpl.closePositionImpl(
6446             state,
6447             positionId,
6448             requestedCloseAmount,
6449             payoutRecipient,
6450             address(0),
6451             true,
6452             new bytes(0)
6453         );
6454     }
6455 
6456     /**
6457      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6458      * Must be approved by both the position owner and lender.
6459      *
6460      * @param  positionId            Unique ID of the position
6461      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6462      *                               closed is also bounded by:
6463      *                               1) The principal of the position
6464      *                               2) The amount allowed by the owner if closer != owner
6465      *                               3) The amount allowed by the lender if closer != lender
6466      * @return                       Values corresponding to:
6467      *                               1) Principal amount of position closed
6468      *                               2) Amount of heldToken received by the msg.sender
6469      */
6470     function closeWithoutCounterparty(
6471         bytes32 positionId,
6472         uint256 requestedCloseAmount,
6473         address payoutRecipient
6474     )
6475         external
6476         closePositionStateControl
6477         nonReentrant
6478         returns (uint256, uint256)
6479     {
6480         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6481             state,
6482             positionId,
6483             requestedCloseAmount,
6484             payoutRecipient
6485         );
6486     }
6487 
6488     /**
6489      * Margin-call a position. Only callable with the approval of the position lender. After the
6490      * call, the position owner will have time equal to the callTimeLimit of the position to close
6491      * the position. If the owner does not close the position, the lender can recover the collateral
6492      * in the position.
6493      *
6494      * @param  positionId       Unique ID of the position
6495      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6496      *                          the margin-call. Passing in 0 means the margin call cannot be
6497      *                          canceled by depositing
6498      */
6499     function marginCall(
6500         bytes32 positionId,
6501         uint256 requiredDeposit
6502     )
6503         external
6504         nonReentrant
6505     {
6506         LoanImpl.marginCallImpl(
6507             state,
6508             positionId,
6509             requiredDeposit
6510         );
6511     }
6512 
6513     /**
6514      * Cancel a margin-call. Only callable with the approval of the position lender.
6515      *
6516      * @param  positionId  Unique ID of the position
6517      */
6518     function cancelMarginCall(
6519         bytes32 positionId
6520     )
6521         external
6522         onlyWhileOperational
6523         nonReentrant
6524     {
6525         LoanImpl.cancelMarginCallImpl(state, positionId);
6526     }
6527 
6528     /**
6529      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6530      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6531      * but remains unclosed. Only callable with the approval of the position lender.
6532      *
6533      * @param  positionId  Unique ID of the position
6534      * @param  recipient   Address to send the recovered tokens to
6535      * @return             Amount of heldToken recovered
6536      */
6537     function forceRecoverCollateral(
6538         bytes32 positionId,
6539         address recipient
6540     )
6541         external
6542         nonReentrant
6543         returns (uint256)
6544     {
6545         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6546             state,
6547             positionId,
6548             recipient
6549         );
6550     }
6551 
6552     /**
6553      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6554      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6555      *
6556      * @param  positionId       Unique ID of the position
6557      * @param  depositAmount    Additional amount in heldToken to deposit
6558      */
6559     function depositCollateral(
6560         bytes32 positionId,
6561         uint256 depositAmount
6562     )
6563         external
6564         onlyWhileOperational
6565         nonReentrant
6566     {
6567         DepositCollateralImpl.depositCollateralImpl(
6568             state,
6569             positionId,
6570             depositAmount
6571         );
6572     }
6573 
6574     /**
6575      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6576      *
6577      * @param  addresses     Array of addresses:
6578      *
6579      *  [0] = owedToken
6580      *  [1] = heldToken
6581      *  [2] = loan payer
6582      *  [3] = loan owner
6583      *  [4] = loan taker
6584      *  [5] = loan position owner
6585      *  [6] = loan fee recipient
6586      *  [7] = loan lender fee token
6587      *  [8] = loan taker fee token
6588      *
6589      * @param  values256     Values corresponding to:
6590      *
6591      *  [0] = loan maximum amount
6592      *  [1] = loan minimum amount
6593      *  [2] = loan minimum heldToken
6594      *  [3] = loan lender fee
6595      *  [4] = loan taker fee
6596      *  [5] = loan expiration timestamp (in seconds)
6597      *  [6] = loan salt
6598      *
6599      * @param  values32      Values corresponding to:
6600      *
6601      *  [0] = loan call time limit (in seconds)
6602      *  [1] = loan maxDuration (in seconds)
6603      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6604      *  [3] = loan interest update period (in seconds)
6605      *
6606      * @param  cancelAmount  Amount to cancel
6607      * @return               Amount that was canceled
6608      */
6609     function cancelLoanOffering(
6610         address[9] addresses,
6611         uint256[7]  values256,
6612         uint32[4]   values32,
6613         uint256     cancelAmount
6614     )
6615         external
6616         cancelLoanOfferingStateControl
6617         nonReentrant
6618         returns (uint256)
6619     {
6620         return LoanImpl.cancelLoanOfferingImpl(
6621             state,
6622             addresses,
6623             values256,
6624             values32,
6625             cancelAmount
6626         );
6627     }
6628 
6629     /**
6630      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6631      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6632      * must implement the LoanOwner interface.
6633      *
6634      * @param  positionId  Unique ID of the position
6635      * @param  who         New owner of the loan
6636      */
6637     function transferLoan(
6638         bytes32 positionId,
6639         address who
6640     )
6641         external
6642         nonReentrant
6643     {
6644         TransferImpl.transferLoanImpl(
6645             state,
6646             positionId,
6647             who);
6648     }
6649 
6650     /**
6651      * Transfer ownership of a position to a new address. This new address will be entitled to all
6652      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6653      * the PositionOwner interface.
6654      *
6655      * @param  positionId  Unique ID of the position
6656      * @param  who         New owner of the position
6657      */
6658     function transferPosition(
6659         bytes32 positionId,
6660         address who
6661     )
6662         external
6663         nonReentrant
6664     {
6665         TransferImpl.transferPositionImpl(
6666             state,
6667             positionId,
6668             who);
6669     }
6670 
6671     // ============ Public Constant Functions ============
6672 
6673     /**
6674      * Gets the address of the Vault contract that holds and accounts for tokens.
6675      *
6676      * @return  The address of the Vault contract
6677      */
6678     function getVaultAddress()
6679         external
6680         view
6681         returns (address)
6682     {
6683         return state.VAULT;
6684     }
6685 
6686     /**
6687      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6688      * make loans or open/close positions.
6689      *
6690      * @return  The address of the TokenProxy contract
6691      */
6692     function getTokenProxyAddress()
6693         external
6694         view
6695         returns (address)
6696     {
6697         return state.TOKEN_PROXY;
6698     }
6699 }
6700 
6701 // File: contracts/margin/interfaces/OnlyMargin.sol
6702 
6703 /**
6704  * @title OnlyMargin
6705  * @author dYdX
6706  *
6707  * Contract to store the address of the main Margin contract and trust only that address to call
6708  * certain functions.
6709  */
6710 contract OnlyMargin {
6711 
6712     // ============ Constants ============
6713 
6714     // Address of the known and trusted Margin contract on the blockchain
6715     address public DYDX_MARGIN;
6716 
6717     // ============ Constructor ============
6718 
6719     constructor(
6720         address margin
6721     )
6722         public
6723     {
6724         DYDX_MARGIN = margin;
6725     }
6726 
6727     // ============ Modifiers ============
6728 
6729     modifier onlyMargin()
6730     {
6731         require(
6732             msg.sender == DYDX_MARGIN,
6733             "OnlyMargin#onlyMargin: Only Margin can call"
6734         );
6735 
6736         _;
6737     }
6738 }
6739 
6740 // File: contracts/margin/external/interfaces/PositionCustodian.sol
6741 
6742 /**
6743  * @title PositionCustodian
6744  * @author dYdX
6745  *
6746  * Interface to interact with other second-layer contracts. For contracts that own positions as a
6747  * proxy for other addresses.
6748  */
6749 interface PositionCustodian {
6750 
6751     /**
6752      * Function that is intended to be called by external contracts to see where to pay any fees or
6753      * tokens as a result of closing a position on behalf of another contract.
6754      *
6755      * @param  positionId   Unique ID of the position
6756      * @return              Address of the true owner of the position
6757      */
6758     function getPositionDeedHolder(
6759         bytes32 positionId
6760     )
6761         external
6762         view
6763         returns (address);
6764 }
6765 
6766 // File: contracts/margin/external/lib/MarginHelper.sol
6767 
6768 /**
6769  * @title MarginHelper
6770  * @author dYdX
6771  *
6772  * This library contains helper functions for interacting with Margin
6773  */
6774 library MarginHelper {
6775     function getPosition(
6776         address DYDX_MARGIN,
6777         bytes32 positionId
6778     )
6779         internal
6780         view
6781         returns (MarginCommon.Position memory)
6782     {
6783         (
6784             address[4] memory addresses,
6785             uint256[2] memory values256,
6786             uint32[6]  memory values32
6787         ) = Margin(DYDX_MARGIN).getPosition(positionId);
6788 
6789         return MarginCommon.Position({
6790             owedToken: addresses[0],
6791             heldToken: addresses[1],
6792             lender: addresses[2],
6793             owner: addresses[3],
6794             principal: values256[0],
6795             requiredDeposit: values256[1],
6796             callTimeLimit: values32[0],
6797             startTimestamp: values32[1],
6798             callTimestamp: values32[2],
6799             maxDuration: values32[3],
6800             interestRate: values32[4],
6801             interestPeriod: values32[5]
6802         });
6803     }
6804 }
6805 
6806 // File: contracts/margin/external/ERC20/ERC20Position.sol
6807 
6808 /**
6809  * @title ERC20Position
6810  * @author dYdX
6811  *
6812  * Shared code for ERC20Short and ERC20Long
6813  */
6814 contract ERC20Position is
6815     ReentrancyGuard,
6816     StandardToken,
6817     OnlyMargin,
6818     PositionOwner,
6819     IncreasePositionDelegator,
6820     ClosePositionDelegator,
6821     PositionCustodian
6822 {
6823     using SafeMath for uint256;
6824 
6825     // ============ Enums ============
6826 
6827     enum State {
6828         UNINITIALIZED,
6829         OPEN,
6830         CLOSED
6831     }
6832 
6833     // ============ Events ============
6834 
6835     /**
6836      * This ERC20 was successfully initialized
6837      */
6838     event Initialized(
6839         bytes32 positionId,
6840         uint256 initialSupply
6841     );
6842 
6843     /**
6844      * The position was completely closed by a trusted third-party and tokens can be withdrawn
6845      */
6846     event ClosedByTrustedParty(
6847         address closer,
6848         uint256 tokenAmount,
6849         address payoutRecipient
6850     );
6851 
6852     /**
6853      * The position was completely closed and tokens can be withdrawn
6854      */
6855     event CompletelyClosed();
6856 
6857     /**
6858      * A user burned tokens to withdraw heldTokens from this contract after the position was closed
6859      */
6860     event Withdraw(
6861         address indexed redeemer,
6862         uint256 tokensRedeemed,
6863         uint256 heldTokenPayout
6864     );
6865 
6866     /**
6867      * A user burned tokens in order to partially close the position
6868      */
6869     event Close(
6870         address indexed redeemer,
6871         uint256 closeAmount
6872     );
6873 
6874     // ============ State Variables ============
6875 
6876     // All tokens will initially be allocated to this address
6877     address public INITIAL_TOKEN_HOLDER;
6878 
6879     // Unique ID of the position this contract is tokenizing
6880     bytes32 public POSITION_ID;
6881 
6882     // Recipients that will fairly verify and redistribute funds from closing the position
6883     mapping (address => bool) public TRUSTED_RECIPIENTS;
6884 
6885     // Withdrawers that will fairly withdraw funds after the position has been closed
6886     mapping (address => bool) public TRUSTED_WITHDRAWERS;
6887 
6888     // Current State of this contract. See State enum
6889     State public state;
6890 
6891     // Address of the position's heldToken. Cached for convenience and lower-cost withdrawals
6892     address public heldToken;
6893 
6894     // Position has been closed using a trusted recipient
6895     bool public closedUsingTrustedRecipient;
6896 
6897     // ============ Modifiers ============
6898 
6899     modifier onlyPosition(bytes32 positionId) {
6900         require(
6901             POSITION_ID == positionId,
6902             "ERC20Position#onlyPosition: Incorrect position"
6903         );
6904         _;
6905     }
6906 
6907     modifier onlyState(State specificState) {
6908         require(
6909             state == specificState,
6910             "ERC20Position#onlyState: Incorrect State"
6911         );
6912         _;
6913     }
6914 
6915     // ============ Constructor ============
6916 
6917     constructor(
6918         bytes32 positionId,
6919         address margin,
6920         address initialTokenHolder,
6921         address[] trustedRecipients,
6922         address[] trustedWithdrawers
6923     )
6924         public
6925         OnlyMargin(margin)
6926     {
6927         POSITION_ID = positionId;
6928         state = State.UNINITIALIZED;
6929         INITIAL_TOKEN_HOLDER = initialTokenHolder;
6930         closedUsingTrustedRecipient = false;
6931 
6932         uint256 i;
6933         for (i = 0; i < trustedRecipients.length; i++) {
6934             TRUSTED_RECIPIENTS[trustedRecipients[i]] = true;
6935         }
6936         for (i = 0; i < trustedWithdrawers.length; i++) {
6937             TRUSTED_WITHDRAWERS[trustedWithdrawers[i]] = true;
6938         }
6939     }
6940 
6941     // ============ Margin-Only Functions ============
6942 
6943     /**
6944      * Called by Margin when anyone transfers ownership of a position to this contract.
6945      * This function initializes the tokenization of the position given and returns this address to
6946      * indicate to Margin that it is willing to take ownership of the position.
6947      *
6948      *  param  (unused)
6949      * @param  positionId  Unique ID of the position
6950      * @return             This address on success, throw otherwise
6951      */
6952     function receivePositionOwnership(
6953         address /* from */,
6954         bytes32 positionId
6955     )
6956         external
6957         onlyMargin
6958         nonReentrant
6959         onlyState(State.UNINITIALIZED)
6960         onlyPosition(positionId)
6961         returns (address)
6962     {
6963         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
6964         assert(position.principal > 0);
6965 
6966         // set relevant constants
6967         state = State.OPEN;
6968         heldToken = position.heldToken;
6969 
6970         uint256 tokenAmount = getTokenAmountOnAdd(position.principal);
6971 
6972         emit Initialized(POSITION_ID, tokenAmount);
6973 
6974         mint(INITIAL_TOKEN_HOLDER, tokenAmount);
6975 
6976         return address(this); // returning own address retains ownership of position
6977     }
6978 
6979     /**
6980      * Called by Margin when additional value is added onto the position this contract
6981      * owns. Tokens are minted and assigned to the address that added the value.
6982      *
6983      * @param  trader          Address that added the value to the position
6984      * @param  positionId      Unique ID of the position
6985      * @param  principalAdded  Amount that was added to the position
6986      * @return                 This address on success, throw otherwise
6987      */
6988     function increasePositionOnBehalfOf(
6989         address trader,
6990         bytes32 positionId,
6991         uint256 principalAdded
6992     )
6993         external
6994         onlyMargin
6995         nonReentrant
6996         onlyState(State.OPEN)
6997         onlyPosition(positionId)
6998         returns (address)
6999     {
7000         require(
7001             !Margin(DYDX_MARGIN).isPositionCalled(POSITION_ID),
7002             "ERC20Position#increasePositionOnBehalfOf: Position is margin-called"
7003         );
7004         require(
7005             !closedUsingTrustedRecipient,
7006             "ERC20Position#increasePositionOnBehalfOf: Position closed using trusted recipient"
7007         );
7008 
7009         uint256 tokenAmount = getTokenAmountOnAdd(principalAdded);
7010 
7011         mint(trader, tokenAmount);
7012 
7013         return address(this);
7014     }
7015 
7016     /**
7017      * Called by Margin when an owner of this token is attempting to close some of the
7018      * position. Implementation is required per PositionOwner contract in order to be used by
7019      * Margin to approve closing parts of a position.
7020      *
7021      * @param  closer           Address of the caller of the close function
7022      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
7023      * @param  positionId       Unique ID of the position
7024      * @param  requestedAmount  Amount (in principal) of the position being closed
7025      * @return                  1) This address to accept, a different address to ask that contract
7026      *                          2) The maximum amount that this contract is allowing
7027      */
7028     function closeOnBehalfOf(
7029         address closer,
7030         address payoutRecipient,
7031         bytes32 positionId,
7032         uint256 requestedAmount
7033     )
7034         external
7035         onlyMargin
7036         nonReentrant
7037         onlyState(State.OPEN)
7038         onlyPosition(positionId)
7039         returns (address, uint256)
7040     {
7041         uint256 positionPrincipal = Margin(DYDX_MARGIN).getPositionPrincipal(positionId);
7042 
7043         assert(requestedAmount <= positionPrincipal);
7044 
7045         uint256 allowedAmount;
7046         if (TRUSTED_RECIPIENTS[payoutRecipient]) {
7047             allowedAmount = closeUsingTrustedRecipient(
7048                 closer,
7049                 payoutRecipient,
7050                 requestedAmount
7051             );
7052         } else {
7053             allowedAmount = close(
7054                 closer,
7055                 requestedAmount,
7056                 positionPrincipal
7057             );
7058         }
7059 
7060         assert(allowedAmount > 0);
7061         assert(allowedAmount <= requestedAmount);
7062 
7063         if (allowedAmount == positionPrincipal) {
7064             state = State.CLOSED;
7065             emit CompletelyClosed();
7066         }
7067 
7068         return (address(this), allowedAmount);
7069     }
7070 
7071     // ============ Public State Changing Functions ============
7072 
7073     /**
7074      * Withdraw heldTokens from this contract for any of the position that was closed via external
7075      * means (such as an auction-closing mechanism)
7076      *
7077      * NOTE: It is possible that this contract could be sent heldToken by external sources
7078      * other than from the Margin contract. In this case the payout for token holders
7079      * would be greater than just that from the normal payout. This is fine because
7080      * nobody has incentive to send this contract extra funds, and if they do then it's
7081      * also fine just to let the token holders have it.
7082      *
7083      * NOTE: If there are significant rounding errors, then it is possible that withdrawing later is
7084      * more advantageous. An "attack" could involve withdrawing for others before withdrawing for
7085      * yourself. Likely, rounding error will be small enough to not properly incentivize people to
7086      * carry out such an attack.
7087      *
7088      * @param  onBehalfOf  Address of the account to withdraw for
7089      * @return             The amount of heldToken withdrawn
7090      */
7091     function withdraw(
7092         address onBehalfOf
7093     )
7094         external
7095         nonReentrant
7096         returns (uint256)
7097     {
7098         setStateClosedIfClosed();
7099         require(
7100             state == State.CLOSED,
7101             "ERC20Position#withdraw: Position has not yet been closed"
7102         );
7103 
7104         if (msg.sender != onBehalfOf) {
7105             require(
7106                 TRUSTED_WITHDRAWERS[msg.sender],
7107                 "ERC20Position#withdraw: Only trusted withdrawers can withdraw on behalf of others"
7108             );
7109         }
7110 
7111         return withdrawImpl(msg.sender, onBehalfOf);
7112     }
7113 
7114     // ============ Public Constant Functions ============
7115 
7116     /**
7117      * ERC20 name function
7118      *
7119      * @return  The name of the Margin Token
7120      */
7121     function name()
7122         external
7123         view
7124         returns (string);
7125 
7126     /**
7127      * ERC20 symbol function
7128      *
7129      * @return  The symbol of the Margin Token
7130      */
7131     function symbol()
7132         external
7133         view
7134         returns (string);
7135 
7136     /**
7137      * ERC20 decimals function
7138      *
7139      * @return  The number of decimal places
7140      */
7141     function decimals()
7142         external
7143         view
7144         returns (uint8);
7145 
7146     /**
7147      * Implements PositionCustodian functionality. Called by external contracts to see where to pay
7148      * tokens as a result of closing a position on behalf of this contract
7149      *
7150      * @param  positionId  Unique ID of the position
7151      * @return             Address of this contract. Indicates funds should be sent to this contract
7152      */
7153     function getPositionDeedHolder(
7154         bytes32 positionId
7155     )
7156         external
7157         view
7158         onlyPosition(positionId)
7159         returns (address)
7160     {
7161         // Claim ownership of deed and allow token holders to withdraw funds from this contract
7162         return address(this);
7163     }
7164 
7165     // ============ Internal Helper-Functions ============
7166 
7167     /**
7168      * Tokens are not burned when a trusted recipient is used, but we require the position to be
7169      * completely closed. All token holders are then entitled to the heldTokens in the contract
7170      */
7171     function closeUsingTrustedRecipient(
7172         address closer,
7173         address payoutRecipient,
7174         uint256 requestedAmount
7175     )
7176         internal
7177         returns (uint256)
7178     {
7179         assert(requestedAmount > 0);
7180 
7181         // remember that a trusted recipient was used
7182         if (!closedUsingTrustedRecipient) {
7183             closedUsingTrustedRecipient = true;
7184         }
7185 
7186         emit ClosedByTrustedParty(closer, requestedAmount, payoutRecipient);
7187 
7188         return requestedAmount;
7189     }
7190 
7191     // ============ Private Helper-Functions ============
7192 
7193     function withdrawImpl(
7194         address receiver,
7195         address onBehalfOf
7196     )
7197         private
7198         returns (uint256)
7199     {
7200         uint256 value = balanceOf(onBehalfOf);
7201 
7202         if (value == 0) {
7203             return 0;
7204         }
7205 
7206         uint256 heldTokenBalance = TokenInteract.balanceOf(heldToken, address(this));
7207 
7208         // NOTE the payout must be calculated before decrementing the totalSupply below
7209         uint256 heldTokenPayout = MathHelpers.getPartialAmount(
7210             value,
7211             totalSupply_,
7212             heldTokenBalance
7213         );
7214 
7215         // Destroy the margin tokens
7216         burn(onBehalfOf, value);
7217         emit Withdraw(onBehalfOf, value, heldTokenPayout);
7218 
7219         // Send the redeemer their proportion of heldToken
7220         TokenInteract.transfer(heldToken, receiver, heldTokenPayout);
7221 
7222         return heldTokenPayout;
7223     }
7224 
7225     function setStateClosedIfClosed(
7226     )
7227         private
7228     {
7229         // If in OPEN state, but the position is closed, set to CLOSED state
7230         if (state == State.OPEN && Margin(DYDX_MARGIN).isPositionClosed(POSITION_ID)) {
7231             state = State.CLOSED;
7232             emit CompletelyClosed();
7233         }
7234     }
7235 
7236     function close(
7237         address closer,
7238         uint256 requestedAmount,
7239         uint256 positionPrincipal
7240     )
7241         private
7242         returns (uint256)
7243     {
7244         uint256 balance = balances[closer];
7245 
7246         (
7247             uint256 tokenAmount,
7248             uint256 allowedCloseAmount
7249         ) = getCloseAmounts(
7250             requestedAmount,
7251             balance,
7252             positionPrincipal
7253         );
7254 
7255         require(
7256             tokenAmount > 0 && allowedCloseAmount > 0,
7257             "ERC20Position#close: Cannot close 0 amount"
7258         );
7259 
7260         assert(allowedCloseAmount <= requestedAmount);
7261 
7262         burn(closer, tokenAmount);
7263 
7264         emit Close(closer, tokenAmount);
7265 
7266         return allowedCloseAmount;
7267     }
7268 
7269     function burn(
7270         address from,
7271         uint256 amount
7272     )
7273         private
7274     {
7275         assert(from != address(0));
7276         totalSupply_ = totalSupply_.sub(amount);
7277         balances[from] = balances[from].sub(amount);
7278         emit Transfer(from, address(0), amount);
7279     }
7280 
7281     function mint(
7282         address to,
7283         uint256 amount
7284     )
7285         private
7286     {
7287         assert(to != address(0));
7288         totalSupply_ = totalSupply_.add(amount);
7289         balances[to] = balances[to].add(amount);
7290         emit Transfer(address(0), to, amount);
7291     }
7292 
7293     // ============ Private Abstract Functions ============
7294 
7295     function getTokenAmountOnAdd(
7296         uint256 principalAdded
7297     )
7298         internal
7299         view
7300         returns (uint256);
7301 
7302     function getCloseAmounts(
7303         uint256 requestedCloseAmount,
7304         uint256 balance,
7305         uint256 positionPrincipal
7306     )
7307         private
7308         view
7309         returns (
7310             uint256 /* tokenAmount */,
7311             uint256 /* allowedCloseAmount */
7312         );
7313 }
7314 
7315 // File: contracts/margin/external/ERC20/ERC20CappedPosition.sol
7316 
7317 /**
7318  * @title ERC20CappedPosition
7319  * @author dYdX
7320  *
7321  * ERC20 Position with a limit on the number of tokens that can be minted, and a restriction on
7322  * which addreses can close the position after it is force-recoverable.
7323  */
7324 contract ERC20CappedPosition is
7325     ERC20Position,
7326     Ownable
7327 {
7328     using SafeMath for uint256;
7329 
7330     // ============ Events ============
7331 
7332     event TokenCapSet(
7333         uint256 tokenCap
7334     );
7335 
7336     event TrustedCloserSet(
7337         address closer,
7338         bool allowed
7339     );
7340 
7341     // ============ State Variables ============
7342 
7343     mapping(address => bool) public TRUSTED_LATE_CLOSERS;
7344 
7345     uint256 public tokenCap;
7346 
7347     // ============ Constructor ============
7348 
7349     constructor(
7350         address[] trustedLateClosers,
7351         uint256 cap
7352     )
7353         public
7354         Ownable()
7355     {
7356         for (uint256 i = 0; i < trustedLateClosers.length; i++) {
7357             TRUSTED_LATE_CLOSERS[trustedLateClosers[i]] = true;
7358         }
7359         tokenCap = cap;
7360     }
7361 
7362     // ============ Owner-Only Functions ============
7363 
7364     function setTokenCap(
7365         uint256 newCap
7366     )
7367         external
7368         onlyOwner
7369     {
7370         // We do not need to require that the tokenCap is >= totalSupply_ because the cap is only
7371         // checked when increasing the position. It does not prevent any other functionality
7372         tokenCap = newCap;
7373         emit TokenCapSet(newCap);
7374     }
7375 
7376     function setTrustedLateCloser(
7377         address closer,
7378         bool allowed
7379     )
7380         external
7381         onlyOwner
7382     {
7383         TRUSTED_LATE_CLOSERS[closer] = allowed;
7384         emit TrustedCloserSet(closer, allowed);
7385     }
7386 
7387     // ============ Internal Overriding Functions ============
7388 
7389     // overrides the function in ERC20Position
7390     function closeUsingTrustedRecipient(
7391         address closer,
7392         address payoutRecipient,
7393         uint256 requestedAmount
7394     )
7395         internal
7396         returns (uint256)
7397     {
7398         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
7399 
7400         bool afterEnd =
7401             block.timestamp > uint256(position.startTimestamp).add(position.maxDuration);
7402         bool afterCall =
7403             position.callTimestamp > 0 &&
7404             block.timestamp > uint256(position.callTimestamp).add(position.callTimeLimit);
7405 
7406         if (afterCall || afterEnd) {
7407             require (
7408                 TRUSTED_LATE_CLOSERS[closer],
7409                 "ERC20CappedPosition#closeUsingTrustedRecipient: closer not in TRUSTED_LATE_CLOSERS"
7410             );
7411         }
7412 
7413         return super.closeUsingTrustedRecipient(closer, payoutRecipient, requestedAmount);
7414     }
7415 }
7416 
7417 // File: contracts/lib/StringHelpers.sol
7418 
7419 /**
7420  * @title StringHelpers
7421  * @author dYdX
7422  *
7423  * This library helps with string manipulation in Solidity
7424  */
7425 library StringHelpers {
7426     /**
7427      * Translates a bytes32 to an ascii hexadecimal representation starting with "0x"
7428      *
7429      * @param  input  The bytes to convert to hexadecimal
7430      * @return        A representation of the bytes in ascii hexadecimal
7431      */
7432     function bytes32ToHex(
7433         bytes32 input
7434     )
7435         internal
7436         pure
7437         returns (bytes)
7438     {
7439         uint256 number = uint256(input);
7440         bytes memory numberAsString = new bytes(66); // "0x" and then 2 chars per byte
7441         numberAsString[0] = byte(48);  // '0'
7442         numberAsString[1] = byte(120); // 'x'
7443 
7444         for (uint256 n = 0; n < 32; n++) {
7445             uint256 nthByte = number / uint256(uint256(2) ** uint256(248 - 8 * n));
7446 
7447             // 1 byte to 2 hexadecimal numbers
7448             uint8 hex1 = uint8(nthByte) / uint8(16);
7449             uint8 hex2 = uint8(nthByte) % uint8(16);
7450 
7451             // 87 is ascii for '0', 48 is ascii for 'a'
7452             hex1 += (hex1 > 9) ? 87 : 48; // shift into proper ascii value
7453             hex2 += (hex2 > 9) ? 87 : 48; // shift into proper ascii value
7454             numberAsString[2 * n + 2] = byte(hex1);
7455             numberAsString[2 * n + 3] = byte(hex2);
7456         }
7457         return numberAsString;
7458     }
7459 }
7460 
7461 // File: contracts/margin/external/ERC20/ERC20Short.sol
7462 
7463 /**
7464  * @title ERC20Short
7465  * @author dYdX
7466  *
7467  * Contract used to tokenize short positions and allow them to be used as ERC20-compliant
7468  * tokens. Holding the tokens allows the holder to close a piece of the short position, or be
7469  * entitled to some amount of heldTokens after settlement.
7470  *
7471  * The total supply of short tokens is always exactly equal to the amount of principal in
7472  * the backing position
7473  */
7474 contract ERC20Short is ERC20Position {
7475     constructor(
7476         bytes32 positionId,
7477         address margin,
7478         address initialTokenHolder,
7479         address[] trustedRecipients,
7480         address[] trustedWithdrawers
7481     )
7482         public
7483         ERC20Position(
7484             positionId,
7485             margin,
7486             initialTokenHolder,
7487             trustedRecipients,
7488             trustedWithdrawers
7489         )
7490     {}
7491 
7492     // ============ Public Constant Functions ============
7493 
7494     function decimals()
7495         external
7496         view
7497         returns (uint8)
7498     {
7499         address owedToken = Margin(DYDX_MARGIN).getPositionOwedToken(POSITION_ID);
7500         return DetailedERC20(owedToken).decimals();
7501     }
7502 
7503     function symbol()
7504         external
7505         view
7506         returns (string)
7507     {
7508         if (state == State.UNINITIALIZED) {
7509             return "s[UNINITIALIZED]";
7510         }
7511         address owedToken = Margin(DYDX_MARGIN).getPositionOwedToken(POSITION_ID);
7512         return string(
7513             abi.encodePacked(
7514                 "s",
7515                 bytes(DetailedERC20(owedToken).symbol())
7516             )
7517         );
7518     }
7519 
7520     function name()
7521         external
7522         view
7523         returns (string)
7524     {
7525         if (state == State.UNINITIALIZED) {
7526             return "dYdX Short Token [UNINITIALIZED]";
7527         }
7528         return string(
7529             abi.encodePacked(
7530                 "dYdX Short Token ",
7531                 StringHelpers.bytes32ToHex(POSITION_ID)
7532             )
7533         );
7534     }
7535 
7536     // ============ Private Functions ============
7537 
7538     function getTokenAmountOnAdd(
7539         uint256 principalAdded
7540     )
7541         internal
7542         view
7543         returns (uint256)
7544     {
7545         return principalAdded;
7546     }
7547 
7548     function getCloseAmounts(
7549         uint256 requestedCloseAmount,
7550         uint256 balance,
7551         uint256 positionPrincipal
7552     )
7553         private
7554         view
7555         returns (
7556             uint256 /* tokenAmount */,
7557             uint256 /* allowedCloseAmount */
7558         )
7559     {
7560         // positionPrincipal < totalSupply_ if position was closed by a trusted closer
7561         assert(positionPrincipal <= totalSupply_);
7562 
7563         uint256 amount = Math.min256(balance, requestedCloseAmount);
7564 
7565         return (amount, amount);
7566     }
7567 }
7568 
7569 // File: contracts/margin/external/ERC20/ERC20CappedShort.sol
7570 
7571 /**
7572  * @title ERC20CappedShort
7573  * @author dYdX
7574  *
7575  * ERC20Short with a limit on the number of tokens that can be minted, and a restriction on
7576  * which addreses can close the position after it is force-recoverable.
7577  */
7578 contract ERC20CappedShort is
7579     ERC20Short,
7580     ERC20CappedPosition,
7581     DetailedERC20
7582 {
7583     using SafeMath for uint256;
7584 
7585     // ============ Constructor ============
7586 
7587     constructor(
7588         bytes32 positionId,
7589         address margin,
7590         address initialTokenHolder,
7591         address[] trustedRecipients,
7592         address[] trustedWithdrawers,
7593         address[] trustedLateClosers,
7594         uint256 cap,
7595         string name,
7596         string symbol,
7597         uint8 decimals
7598     )
7599         public
7600         ERC20Short(
7601             positionId,
7602             margin,
7603             initialTokenHolder,
7604             trustedRecipients,
7605             trustedWithdrawers
7606         )
7607         ERC20CappedPosition(
7608             trustedLateClosers,
7609             cap
7610         )
7611         DetailedERC20(
7612             name,
7613             symbol,
7614             decimals
7615         )
7616     {
7617     }
7618 
7619     // ============ Internal Overriding Functions ============
7620 
7621     function getTokenAmountOnAdd(
7622         uint256 principalAdded
7623     )
7624         internal
7625         view
7626         returns (uint256)
7627     {
7628         uint256 tokenAmount = super.getTokenAmountOnAdd(principalAdded);
7629 
7630         require(
7631             totalSupply_.add(tokenAmount) <= tokenCap,
7632             "ERC20CappedShort#getTokenAmountOnAdd: Adding tokenAmount would exceed cap"
7633         );
7634 
7635         return tokenAmount;
7636     }
7637 }