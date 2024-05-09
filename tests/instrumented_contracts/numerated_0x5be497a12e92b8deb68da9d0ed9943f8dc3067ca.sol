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
85 // File: openzeppelin-solidity/contracts/math/Math.sol
86 
87 /**
88  * @title Math
89  * @dev Assorted math operations
90  */
91 library Math {
92   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
93     return _a >= _b ? _a : _b;
94   }
95 
96   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
97     return _a < _b ? _a : _b;
98   }
99 
100   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     return _a >= _b ? _a : _b;
102   }
103 
104   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     return _a < _b ? _a : _b;
106   }
107 }
108 
109 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, throws on overflow.
119   */
120   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
121     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
122     // benefit is lost if 'b' is also tested.
123     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
124     if (_a == 0) {
125       return 0;
126     }
127 
128     c = _a * _b;
129     assert(c / _a == _b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     // assert(_b > 0); // Solidity automatically throws when dividing by 0
138     // uint256 c = _a / _b;
139     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
140     return _a / _b;
141   }
142 
143   /**
144   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
147     assert(_b <= _a);
148     return _a - _b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
155     c = _a + _b;
156     assert(c >= _a);
157     return c;
158   }
159 }
160 
161 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
162 
163 /**
164  * @title ERC20Basic
165  * @dev Simpler version of ERC20 interface
166  * See https://github.com/ethereum/EIPs/issues/179
167  */
168 contract ERC20Basic {
169   function totalSupply() public view returns (uint256);
170   function balanceOf(address _who) public view returns (uint256);
171   function transfer(address _to, uint256 _value) public returns (bool);
172   event Transfer(address indexed from, address indexed to, uint256 value);
173 }
174 
175 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
176 
177 /**
178  * @title Basic token
179  * @dev Basic version of StandardToken, with no allowances.
180  */
181 contract BasicToken is ERC20Basic {
182   using SafeMath for uint256;
183 
184   mapping(address => uint256) internal balances;
185 
186   uint256 internal totalSupply_;
187 
188   /**
189   * @dev Total number of tokens in existence
190   */
191   function totalSupply() public view returns (uint256) {
192     return totalSupply_;
193   }
194 
195   /**
196   * @dev Transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) public returns (bool) {
201     require(_value <= balances[msg.sender]);
202     require(_to != address(0));
203 
204     balances[msg.sender] = balances[msg.sender].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     emit Transfer(msg.sender, _to, _value);
207     return true;
208   }
209 
210   /**
211   * @dev Gets the balance of the specified address.
212   * @param _owner The address to query the the balance of.
213   * @return An uint256 representing the amount owned by the passed address.
214   */
215   function balanceOf(address _owner) public view returns (uint256) {
216     return balances[_owner];
217   }
218 
219 }
220 
221 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
222 
223 /**
224  * @title ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 contract ERC20 is ERC20Basic {
228   function allowance(address _owner, address _spender)
229     public view returns (uint256);
230 
231   function transferFrom(address _from, address _to, uint256 _value)
232     public returns (bool);
233 
234   function approve(address _spender, uint256 _value) public returns (bool);
235   event Approval(
236     address indexed owner,
237     address indexed spender,
238     uint256 value
239   );
240 }
241 
242 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
243 
244 /**
245  * @title Standard ERC20 token
246  *
247  * @dev Implementation of the basic standard token.
248  * https://github.com/ethereum/EIPs/issues/20
249  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
250  */
251 contract StandardToken is ERC20, BasicToken {
252 
253   mapping (address => mapping (address => uint256)) internal allowed;
254 
255   /**
256    * @dev Transfer tokens from one address to another
257    * @param _from address The address which you want to send tokens from
258    * @param _to address The address which you want to transfer to
259    * @param _value uint256 the amount of tokens to be transferred
260    */
261   function transferFrom(
262     address _from,
263     address _to,
264     uint256 _value
265   )
266     public
267     returns (bool)
268   {
269     require(_value <= balances[_from]);
270     require(_value <= allowed[_from][msg.sender]);
271     require(_to != address(0));
272 
273     balances[_from] = balances[_from].sub(_value);
274     balances[_to] = balances[_to].add(_value);
275     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276     emit Transfer(_from, _to, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282    * Beware that changing an allowance with this method brings the risk that someone may use both the old
283    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
284    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
285    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286    * @param _spender The address which will spend the funds.
287    * @param _value The amount of tokens to be spent.
288    */
289   function approve(address _spender, uint256 _value) public returns (bool) {
290     allowed[msg.sender][_spender] = _value;
291     emit Approval(msg.sender, _spender, _value);
292     return true;
293   }
294 
295   /**
296    * @dev Function to check the amount of tokens that an owner allowed to a spender.
297    * @param _owner address The address which owns the funds.
298    * @param _spender address The address which will spend the funds.
299    * @return A uint256 specifying the amount of tokens still available for the spender.
300    */
301   function allowance(
302     address _owner,
303     address _spender
304    )
305     public
306     view
307     returns (uint256)
308   {
309     return allowed[_owner][_spender];
310   }
311 
312   /**
313    * @dev Increase the amount of tokens that an owner allowed to a spender.
314    * approve should be called when allowed[_spender] == 0. To increment
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _addedValue The amount of tokens to increase the allowance by.
320    */
321   function increaseApproval(
322     address _spender,
323     uint256 _addedValue
324   )
325     public
326     returns (bool)
327   {
328     allowed[msg.sender][_spender] = (
329       allowed[msg.sender][_spender].add(_addedValue));
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334   /**
335    * @dev Decrease the amount of tokens that an owner allowed to a spender.
336    * approve should be called when allowed[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseApproval(
344     address _spender,
345     uint256 _subtractedValue
346   )
347     public
348     returns (bool)
349   {
350     uint256 oldValue = allowed[msg.sender][_spender];
351     if (_subtractedValue >= oldValue) {
352       allowed[msg.sender][_spender] = 0;
353     } else {
354       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355     }
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360 }
361 
362 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
363 
364 /**
365  * @title Ownable
366  * @dev The Ownable contract has an owner address, and provides basic authorization control
367  * functions, this simplifies the implementation of "user permissions".
368  */
369 contract Ownable {
370   address public owner;
371 
372   event OwnershipRenounced(address indexed previousOwner);
373   event OwnershipTransferred(
374     address indexed previousOwner,
375     address indexed newOwner
376   );
377 
378   /**
379    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
380    * account.
381    */
382   constructor() public {
383     owner = msg.sender;
384   }
385 
386   /**
387    * @dev Throws if called by any account other than the owner.
388    */
389   modifier onlyOwner() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394   /**
395    * @dev Allows the current owner to relinquish control of the contract.
396    * @notice Renouncing to ownership will leave the contract without an owner.
397    * It will not be possible to call the functions with the `onlyOwner`
398    * modifier anymore.
399    */
400   function renounceOwnership() public onlyOwner {
401     emit OwnershipRenounced(owner);
402     owner = address(0);
403   }
404 
405   /**
406    * @dev Allows the current owner to transfer control of the contract to a newOwner.
407    * @param _newOwner The address to transfer ownership to.
408    */
409   function transferOwnership(address _newOwner) public onlyOwner {
410     _transferOwnership(_newOwner);
411   }
412 
413   /**
414    * @dev Transfers control of the contract to a newOwner.
415    * @param _newOwner The address to transfer ownership to.
416    */
417   function _transferOwnership(address _newOwner) internal {
418     require(_newOwner != address(0));
419     emit OwnershipTransferred(owner, _newOwner);
420     owner = _newOwner;
421   }
422 }
423 
424 // File: contracts/lib/AccessControlledBase.sol
425 
426 /**
427  * @title AccessControlledBase
428  * @author dYdX
429  *
430  * Base functionality for access control. Requires an implementation to
431  * provide a way to grant and optionally revoke access
432  */
433 contract AccessControlledBase {
434     // ============ State Variables ============
435 
436     mapping (address => bool) public authorized;
437 
438     // ============ Events ============
439 
440     event AccessGranted(
441         address who
442     );
443 
444     event AccessRevoked(
445         address who
446     );
447 
448     // ============ Modifiers ============
449 
450     modifier requiresAuthorization() {
451         require(
452             authorized[msg.sender],
453             "AccessControlledBase#requiresAuthorization: Sender not authorized"
454         );
455         _;
456     }
457 }
458 
459 // File: contracts/lib/StaticAccessControlled.sol
460 
461 /**
462  * @title StaticAccessControlled
463  * @author dYdX
464  *
465  * Allows for functions to be access controled
466  * Permissions cannot be changed after a grace period
467  */
468 contract StaticAccessControlled is AccessControlledBase, Ownable {
469     using SafeMath for uint256;
470 
471     // ============ State Variables ============
472 
473     // Timestamp after which no additional access can be granted
474     uint256 public GRACE_PERIOD_EXPIRATION;
475 
476     // ============ Constructor ============
477 
478     constructor(
479         uint256 gracePeriod
480     )
481         public
482         Ownable()
483     {
484         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
485     }
486 
487     // ============ Owner-Only State-Changing Functions ============
488 
489     function grantAccess(
490         address who
491     )
492         external
493         onlyOwner
494     {
495         require(
496             block.timestamp < GRACE_PERIOD_EXPIRATION,
497             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
498         );
499 
500         emit AccessGranted(who);
501         authorized[who] = true;
502     }
503 }
504 
505 // File: contracts/lib/GeneralERC20.sol
506 
507 /**
508  * @title GeneralERC20
509  * @author dYdX
510  *
511  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
512  * that we dont automatically revert when calling non-compliant tokens that have no return value for
513  * transfer(), transferFrom(), or approve().
514  */
515 interface GeneralERC20 {
516     function totalSupply(
517     )
518         external
519         view
520         returns (uint256);
521 
522     function balanceOf(
523         address who
524     )
525         external
526         view
527         returns (uint256);
528 
529     function allowance(
530         address owner,
531         address spender
532     )
533         external
534         view
535         returns (uint256);
536 
537     function transfer(
538         address to,
539         uint256 value
540     )
541         external;
542 
543     function transferFrom(
544         address from,
545         address to,
546         uint256 value
547     )
548         external;
549 
550     function approve(
551         address spender,
552         uint256 value
553     )
554         external;
555 }
556 
557 // File: contracts/lib/TokenInteract.sol
558 
559 /**
560  * @title TokenInteract
561  * @author dYdX
562  *
563  * This library contains functions for interacting with ERC20 tokens
564  */
565 library TokenInteract {
566     function balanceOf(
567         address token,
568         address owner
569     )
570         internal
571         view
572         returns (uint256)
573     {
574         return GeneralERC20(token).balanceOf(owner);
575     }
576 
577     function allowance(
578         address token,
579         address owner,
580         address spender
581     )
582         internal
583         view
584         returns (uint256)
585     {
586         return GeneralERC20(token).allowance(owner, spender);
587     }
588 
589     function approve(
590         address token,
591         address spender,
592         uint256 amount
593     )
594         internal
595     {
596         GeneralERC20(token).approve(spender, amount);
597 
598         require(
599             checkSuccess(),
600             "TokenInteract#approve: Approval failed"
601         );
602     }
603 
604     function transfer(
605         address token,
606         address to,
607         uint256 amount
608     )
609         internal
610     {
611         address from = address(this);
612         if (
613             amount == 0
614             || from == to
615         ) {
616             return;
617         }
618 
619         GeneralERC20(token).transfer(to, amount);
620 
621         require(
622             checkSuccess(),
623             "TokenInteract#transfer: Transfer failed"
624         );
625     }
626 
627     function transferFrom(
628         address token,
629         address from,
630         address to,
631         uint256 amount
632     )
633         internal
634     {
635         if (
636             amount == 0
637             || from == to
638         ) {
639             return;
640         }
641 
642         GeneralERC20(token).transferFrom(from, to, amount);
643 
644         require(
645             checkSuccess(),
646             "TokenInteract#transferFrom: TransferFrom failed"
647         );
648     }
649 
650     // ============ Private Helper-Functions ============
651 
652     /**
653      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
654      * function returned 0 bytes or 32 bytes that are not all-zero.
655      */
656     function checkSuccess(
657     )
658         private
659         pure
660         returns (bool)
661     {
662         uint256 returnValue = 0;
663 
664         /* solium-disable-next-line security/no-inline-assembly */
665         assembly {
666             // check number of bytes returned from last function call
667             switch returndatasize
668 
669             // no bytes returned: assume success
670             case 0x0 {
671                 returnValue := 1
672             }
673 
674             // 32 bytes returned: check if non-zero
675             case 0x20 {
676                 // copy 32 bytes into scratch space
677                 returndatacopy(0x0, 0x0, 0x20)
678 
679                 // load those bytes into returnValue
680                 returnValue := mload(0x0)
681             }
682 
683             // not sure what was returned: dont mark as success
684             default { }
685         }
686 
687         return returnValue != 0;
688     }
689 }
690 
691 // File: contracts/margin/TokenProxy.sol
692 
693 /**
694  * @title TokenProxy
695  * @author dYdX
696  *
697  * Used to transfer tokens between addresses which have set allowance on this contract.
698  */
699 contract TokenProxy is StaticAccessControlled {
700     using SafeMath for uint256;
701 
702     // ============ Constructor ============
703 
704     constructor(
705         uint256 gracePeriod
706     )
707         public
708         StaticAccessControlled(gracePeriod)
709     {}
710 
711     // ============ Authorized-Only State Changing Functions ============
712 
713     /**
714      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
715      *
716      * @param  token  The address of the ERC20 token
717      * @param  from   The address to transfer token from
718      * @param  to     The address to transfer tokens to
719      * @param  value  The number of tokens to transfer
720      */
721     function transferTokens(
722         address token,
723         address from,
724         address to,
725         uint256 value
726     )
727         external
728         requiresAuthorization
729     {
730         TokenInteract.transferFrom(
731             token,
732             from,
733             to,
734             value
735         );
736     }
737 
738     // ============ Public Constant Functions ============
739 
740     /**
741      * Getter function to get the amount of token that the proxy is able to move for a particular
742      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
743      *
744      * @param  who    The owner of the tokens
745      * @param  token  The address of the ERC20 token
746      * @return        The number of tokens able to be moved by the proxy from the address specified
747      */
748     function available(
749         address who,
750         address token
751     )
752         external
753         view
754         returns (uint256)
755     {
756         return Math.min256(
757             TokenInteract.allowance(token, who, address(this)),
758             TokenInteract.balanceOf(token, who)
759         );
760     }
761 }
762 
763 // File: contracts/margin/Vault.sol
764 
765 /**
766  * @title Vault
767  * @author dYdX
768  *
769  * Holds and transfers tokens in vaults denominated by id
770  *
771  * Vault only supports ERC20 tokens, and will not accept any tokens that require
772  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
773  */
774 contract Vault is StaticAccessControlled
775 {
776     using SafeMath for uint256;
777 
778     // ============ Events ============
779 
780     event ExcessTokensWithdrawn(
781         address indexed token,
782         address indexed to,
783         address caller
784     );
785 
786     // ============ State Variables ============
787 
788     // Address of the TokenProxy contract. Used for moving tokens.
789     address public TOKEN_PROXY;
790 
791     // Map from vault ID to map from token address to amount of that token attributed to the
792     // particular vault ID.
793     mapping (bytes32 => mapping (address => uint256)) public balances;
794 
795     // Map from token address to total amount of that token attributed to some account.
796     mapping (address => uint256) public totalBalances;
797 
798     // ============ Constructor ============
799 
800     constructor(
801         address proxy,
802         uint256 gracePeriod
803     )
804         public
805         StaticAccessControlled(gracePeriod)
806     {
807         TOKEN_PROXY = proxy;
808     }
809 
810     // ============ Owner-Only State-Changing Functions ============
811 
812     /**
813      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
814      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
815      * will be accounted for and will not be withdrawable by this function.
816      *
817      * @param  token  ERC20 token address
818      * @param  to     Address to transfer tokens to
819      * @return        Amount of tokens withdrawn
820      */
821     function withdrawExcessToken(
822         address token,
823         address to
824     )
825         external
826         onlyOwner
827         returns (uint256)
828     {
829         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
830         uint256 accountedBalance = totalBalances[token];
831         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
832 
833         require(
834             withdrawableBalance != 0,
835             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
836         );
837 
838         TokenInteract.transfer(token, to, withdrawableBalance);
839 
840         emit ExcessTokensWithdrawn(token, to, msg.sender);
841 
842         return withdrawableBalance;
843     }
844 
845     // ============ Authorized-Only State-Changing Functions ============
846 
847     /**
848      * Transfers tokens from an address (that has approved the proxy) to the vault.
849      *
850      * @param  id      The vault which will receive the tokens
851      * @param  token   ERC20 token address
852      * @param  from    Address from which the tokens will be taken
853      * @param  amount  Number of the token to be sent
854      */
855     function transferToVault(
856         bytes32 id,
857         address token,
858         address from,
859         uint256 amount
860     )
861         external
862         requiresAuthorization
863     {
864         // First send tokens to this contract
865         TokenProxy(TOKEN_PROXY).transferTokens(
866             token,
867             from,
868             address(this),
869             amount
870         );
871 
872         // Then increment balances
873         balances[id][token] = balances[id][token].add(amount);
874         totalBalances[token] = totalBalances[token].add(amount);
875 
876         // This should always be true. If not, something is very wrong
877         assert(totalBalances[token] >= balances[id][token]);
878 
879         validateBalance(token);
880     }
881 
882     /**
883      * Transfers a certain amount of funds to an address.
884      *
885      * @param  id      The vault from which to send the tokens
886      * @param  token   ERC20 token address
887      * @param  to      Address to transfer tokens to
888      * @param  amount  Number of the token to be sent
889      */
890     function transferFromVault(
891         bytes32 id,
892         address token,
893         address to,
894         uint256 amount
895     )
896         external
897         requiresAuthorization
898     {
899         // Next line also asserts that (balances[id][token] >= amount);
900         balances[id][token] = balances[id][token].sub(amount);
901 
902         // Next line also asserts that (totalBalances[token] >= amount);
903         totalBalances[token] = totalBalances[token].sub(amount);
904 
905         // This should always be true. If not, something is very wrong
906         assert(totalBalances[token] >= balances[id][token]);
907 
908         // Do the sending
909         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
910 
911         // Final validation
912         validateBalance(token);
913     }
914 
915     // ============ Private Helper-Functions ============
916 
917     /**
918      * Verifies that this contract is in control of at least as many tokens as accounted for
919      *
920      * @param  token  Address of ERC20 token
921      */
922     function validateBalance(
923         address token
924     )
925         private
926         view
927     {
928         // The actual balance could be greater than totalBalances[token] because anyone
929         // can send tokens to the contract's address which cannot be accounted for
930         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
931     }
932 }
933 
934 // File: contracts/lib/ReentrancyGuard.sol
935 
936 /**
937  * @title ReentrancyGuard
938  * @author dYdX
939  *
940  * Optimized version of the well-known ReentrancyGuard contract
941  */
942 contract ReentrancyGuard {
943     uint256 private _guardCounter = 1;
944 
945     modifier nonReentrant() {
946         uint256 localCounter = _guardCounter + 1;
947         _guardCounter = localCounter;
948         _;
949         require(
950             _guardCounter == localCounter,
951             "Reentrancy check failure"
952         );
953     }
954 }
955 
956 // File: openzeppelin-solidity/contracts/AddressUtils.sol
957 
958 /**
959  * Utility library of inline functions on addresses
960  */
961 library AddressUtils {
962 
963   /**
964    * Returns whether the target address is a contract
965    * @dev This function will return false if invoked during the constructor of a contract,
966    * as the code is not actually created until after the constructor finishes.
967    * @param _addr address to check
968    * @return whether the target address is a contract
969    */
970   function isContract(address _addr) internal view returns (bool) {
971     uint256 size;
972     // XXX Currently there is no better way to check if there is a contract in an address
973     // than to check the size of the code at that address.
974     // See https://ethereum.stackexchange.com/a/14016/36603
975     // for more details about how this works.
976     // TODO Check this again before the Serenity release, because all addresses will be
977     // contracts then.
978     // solium-disable-next-line security/no-inline-assembly
979     assembly { size := extcodesize(_addr) }
980     return size > 0;
981   }
982 
983 }
984 
985 // File: contracts/lib/Fraction.sol
986 
987 /**
988  * @title Fraction
989  * @author dYdX
990  *
991  * This library contains implementations for fraction structs.
992  */
993 library Fraction {
994     struct Fraction128 {
995         uint128 num;
996         uint128 den;
997     }
998 }
999 
1000 // File: contracts/lib/FractionMath.sol
1001 
1002 /**
1003  * @title FractionMath
1004  * @author dYdX
1005  *
1006  * This library contains safe math functions for manipulating fractions.
1007  */
1008 library FractionMath {
1009     using SafeMath for uint256;
1010     using SafeMath for uint128;
1011 
1012     /**
1013      * Returns a Fraction128 that is equal to a + b
1014      *
1015      * @param  a  The first Fraction128
1016      * @param  b  The second Fraction128
1017      * @return    The result (sum)
1018      */
1019     function add(
1020         Fraction.Fraction128 memory a,
1021         Fraction.Fraction128 memory b
1022     )
1023         internal
1024         pure
1025         returns (Fraction.Fraction128 memory)
1026     {
1027         uint256 left = a.num.mul(b.den);
1028         uint256 right = b.num.mul(a.den);
1029         uint256 denominator = a.den.mul(b.den);
1030 
1031         // if left + right overflows, prevent overflow
1032         if (left + right < left) {
1033             left = left.div(2);
1034             right = right.div(2);
1035             denominator = denominator.div(2);
1036         }
1037 
1038         return bound(left.add(right), denominator);
1039     }
1040 
1041     /**
1042      * Returns a Fraction128 that is equal to a - (1/2)^d
1043      *
1044      * @param  a  The Fraction128
1045      * @param  d  The power of (1/2)
1046      * @return    The result
1047      */
1048     function sub1Over(
1049         Fraction.Fraction128 memory a,
1050         uint128 d
1051     )
1052         internal
1053         pure
1054         returns (Fraction.Fraction128 memory)
1055     {
1056         if (a.den % d == 0) {
1057             return bound(
1058                 a.num.sub(a.den.div(d)),
1059                 a.den
1060             );
1061         }
1062         return bound(
1063             a.num.mul(d).sub(a.den),
1064             a.den.mul(d)
1065         );
1066     }
1067 
1068     /**
1069      * Returns a Fraction128 that is equal to a / d
1070      *
1071      * @param  a  The first Fraction128
1072      * @param  d  The divisor
1073      * @return    The result (quotient)
1074      */
1075     function div(
1076         Fraction.Fraction128 memory a,
1077         uint128 d
1078     )
1079         internal
1080         pure
1081         returns (Fraction.Fraction128 memory)
1082     {
1083         if (a.num % d == 0) {
1084             return bound(
1085                 a.num.div(d),
1086                 a.den
1087             );
1088         }
1089         return bound(
1090             a.num,
1091             a.den.mul(d)
1092         );
1093     }
1094 
1095     /**
1096      * Returns a Fraction128 that is equal to a * b.
1097      *
1098      * @param  a  The first Fraction128
1099      * @param  b  The second Fraction128
1100      * @return    The result (product)
1101      */
1102     function mul(
1103         Fraction.Fraction128 memory a,
1104         Fraction.Fraction128 memory b
1105     )
1106         internal
1107         pure
1108         returns (Fraction.Fraction128 memory)
1109     {
1110         return bound(
1111             a.num.mul(b.num),
1112             a.den.mul(b.den)
1113         );
1114     }
1115 
1116     /**
1117      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
1118      *
1119      * @param  num  The numerator
1120      * @param  den  The denominator
1121      * @return      The Fraction128 that matches num/den most closely
1122      */
1123     /* solium-disable-next-line security/no-assign-params */
1124     function bound(
1125         uint256 num,
1126         uint256 den
1127     )
1128         internal
1129         pure
1130         returns (Fraction.Fraction128 memory)
1131     {
1132         uint256 max = num > den ? num : den;
1133         uint256 first128Bits = (max >> 128);
1134         if (first128Bits != 0) {
1135             first128Bits += 1;
1136             num /= first128Bits;
1137             den /= first128Bits;
1138         }
1139 
1140         assert(den != 0); // coverage-enable-line
1141         assert(den < 2**128);
1142         assert(num < 2**128);
1143 
1144         return Fraction.Fraction128({
1145             num: uint128(num),
1146             den: uint128(den)
1147         });
1148     }
1149 
1150     /**
1151      * Returns an in-memory copy of a Fraction128
1152      *
1153      * @param  a  The Fraction128 to copy
1154      * @return    A copy of the Fraction128
1155      */
1156     function copy(
1157         Fraction.Fraction128 memory a
1158     )
1159         internal
1160         pure
1161         returns (Fraction.Fraction128 memory)
1162     {
1163         validate(a);
1164         return Fraction.Fraction128({ num: a.num, den: a.den });
1165     }
1166 
1167     // ============ Private Helper-Functions ============
1168 
1169     /**
1170      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
1171      *
1172      * @param  a  The Fraction128 to validate
1173      */
1174     function validate(
1175         Fraction.Fraction128 memory a
1176     )
1177         private
1178         pure
1179     {
1180         assert(a.den != 0); // coverage-enable-line
1181     }
1182 }
1183 
1184 // File: contracts/lib/Exponent.sol
1185 
1186 /**
1187  * @title Exponent
1188  * @author dYdX
1189  *
1190  * This library contains an implementation for calculating e^X for arbitrary fraction X
1191  */
1192 library Exponent {
1193     using SafeMath for uint256;
1194     using FractionMath for Fraction.Fraction128;
1195 
1196     // ============ Constants ============
1197 
1198     // 2**128 - 1
1199     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
1200 
1201     // Number of precomputed integers, X, for E^((1/2)^X)
1202     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
1203 
1204     // Number of precomputed integers, X, for E^X
1205     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
1206 
1207     // ============ Public Implementation Functions ============
1208 
1209     /**
1210      * Returns e^X for any fraction X
1211      *
1212      * @param  X                    The exponent
1213      * @param  precomputePrecision  Accuracy of precomputed terms
1214      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1215      * @return                      e^X
1216      */
1217     function exp(
1218         Fraction.Fraction128 memory X,
1219         uint256 precomputePrecision,
1220         uint256 maclaurinPrecision
1221     )
1222         internal
1223         pure
1224         returns (Fraction.Fraction128 memory)
1225     {
1226         require(
1227             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
1228             "Exponent#exp: Precompute precision over maximum"
1229         );
1230 
1231         Fraction.Fraction128 memory Xcopy = X.copy();
1232         if (Xcopy.num == 0) { // e^0 = 1
1233             return ONE();
1234         }
1235 
1236         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
1237         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
1238 
1239         // if X is less than 1, then just calculate X
1240         if (integerX == 0) {
1241             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
1242         }
1243 
1244         // get e^integerX
1245         Fraction.Fraction128 memory expOfInt =
1246             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
1247         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
1248             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
1249             integerX -= NUM_PRECOMPUTED_INTEGERS;
1250         }
1251 
1252         // multiply e^integerX by e^decimalX
1253         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
1254             num: Xcopy.num % Xcopy.den,
1255             den: Xcopy.den
1256         });
1257         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
1258     }
1259 
1260     /**
1261      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
1262      * Maclaurin Series approximation to reduce error.
1263      *
1264      * @param  X                    Exponent
1265      * @param  precomputePrecision  Accuracy of precomputed terms
1266      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1267      * @return                      e^X
1268      */
1269     function expHybrid(
1270         Fraction.Fraction128 memory X,
1271         uint256 precomputePrecision,
1272         uint256 maclaurinPrecision
1273     )
1274         internal
1275         pure
1276         returns (Fraction.Fraction128 memory)
1277     {
1278         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1279         assert(X.num < X.den);
1280         // will also throw if precomputePrecision is larger than the array length in getDenominator
1281 
1282         Fraction.Fraction128 memory Xtemp = X.copy();
1283         if (Xtemp.num == 0) { // e^0 = 1
1284             return ONE();
1285         }
1286 
1287         Fraction.Fraction128 memory result = ONE();
1288 
1289         uint256 d = 1; // 2^i
1290         for (uint256 i = 1; i <= precomputePrecision; i++) {
1291             d *= 2;
1292 
1293             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1294             if (d.mul(Xtemp.num) >= Xtemp.den) {
1295                 Xtemp = Xtemp.sub1Over(uint128(d));
1296                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1297             }
1298         }
1299         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1300     }
1301 
1302     /**
1303      * Returns e^X for any X, using Maclaurin Series approximation
1304      *
1305      * e^X = SUM(X^n / n!) for n >= 0
1306      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1307      *
1308      * @param  X           Exponent
1309      * @param  precision   Accuracy of Maclaurin terms
1310      * @return             e^X
1311      */
1312     function expMaclaurin(
1313         Fraction.Fraction128 memory X,
1314         uint256 precision
1315     )
1316         internal
1317         pure
1318         returns (Fraction.Fraction128 memory)
1319     {
1320         Fraction.Fraction128 memory Xcopy = X.copy();
1321         if (Xcopy.num == 0) { // e^0 = 1
1322             return ONE();
1323         }
1324 
1325         Fraction.Fraction128 memory result = ONE();
1326         Fraction.Fraction128 memory Xtemp = ONE();
1327         for (uint256 i = 1; i <= precision; i++) {
1328             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1329             result = result.add(Xtemp);
1330         }
1331         return result;
1332     }
1333 
1334     /**
1335      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1336      */
1337     function getPrecomputedEToTheHalfToThe(
1338         uint256 x
1339     )
1340         internal
1341         pure
1342         returns (Fraction.Fraction128 memory)
1343     {
1344         assert(x <= MAX_PRECOMPUTE_PRECISION);
1345 
1346         uint128 denominator = [
1347             125182886983370532117250726298150828301,
1348             206391688497133195273760705512282642279,
1349             265012173823417992016237332255925138361,
1350             300298134811882980317033350418940119802,
1351             319665700530617779809390163992561606014,
1352             329812979126047300897653247035862915816,
1353             335006777809430963166468914297166288162,
1354             337634268532609249517744113622081347950,
1355             338955731696479810470146282672867036734,
1356             339618401537809365075354109784799900812,
1357             339950222128463181389559457827561204959,
1358             340116253979683015278260491021941090650,
1359             340199300311581465057079429423749235412,
1360             340240831081268226777032180141478221816,
1361             340261598367316729254995498374473399540,
1362             340271982485676106947851156443492415142,
1363             340277174663693808406010255284800906112,
1364             340279770782412691177936847400746725466,
1365             340281068849199706686796915841848278311,
1366             340281717884450116236033378667952410919,
1367             340282042402539547492367191008339680733,
1368             340282204661700319870089970029119685699,
1369             340282285791309720262481214385569134454,
1370             340282326356121674011576912006427792656,
1371             340282346638529464274601981200276914173,
1372             340282356779733812753265346086924801364,
1373             340282361850336100329388676752133324799,
1374             340282364385637272451648746721404212564,
1375             340282365653287865596328444437856608255,
1376             340282366287113163939555716675618384724,
1377             340282366604025813553891209601455838559,
1378             340282366762482138471739420386372790954,
1379             340282366841710300958333641874363209044
1380         ][x];
1381         return Fraction.Fraction128({
1382             num: MAX_NUMERATOR,
1383             den: denominator
1384         });
1385     }
1386 
1387     /**
1388      * Returns a fraction roughly equaling E^(x) for integer x
1389      */
1390     function getPrecomputedEToThe(
1391         uint256 x
1392     )
1393         internal
1394         pure
1395         returns (Fraction.Fraction128 memory)
1396     {
1397         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1398 
1399         uint128 denominator = [
1400             340282366920938463463374607431768211455,
1401             125182886983370532117250726298150828301,
1402             46052210507670172419625860892627118820,
1403             16941661466271327126146327822211253888,
1404             6232488952727653950957829210887653621,
1405             2292804553036637136093891217529878878,
1406             843475657686456657683449904934172134,
1407             310297353591408453462393329342695980,
1408             114152017036184782947077973323212575,
1409             41994180235864621538772677139808695,
1410             15448795557622704876497742989562086,
1411             5683294276510101335127414470015662,
1412             2090767122455392675095471286328463,
1413             769150240628514374138961856925097,
1414             282954560699298259527814398449860,
1415             104093165666968799599694528310221,
1416             38293735615330848145349245349513,
1417             14087478058534870382224480725096,
1418             5182493555688763339001418388912,
1419             1906532833141383353974257736699,
1420             701374233231058797338605168652,
1421             258021160973090761055471434334,
1422             94920680509187392077350434438,
1423             34919366901332874995585576427,
1424             12846117181722897538509298435,
1425             4725822410035083116489797150,
1426             1738532907279185132707372378,
1427             639570514388029575350057932,
1428             235284843422800231081973821,
1429             86556456714490055457751527,
1430             31842340925906738090071268,
1431             11714142585413118080082437,
1432             4309392228124372433711936
1433         ][x];
1434         return Fraction.Fraction128({
1435             num: MAX_NUMERATOR,
1436             den: denominator
1437         });
1438     }
1439 
1440     // ============ Private Helper-Functions ============
1441 
1442     function ONE()
1443         private
1444         pure
1445         returns (Fraction.Fraction128 memory)
1446     {
1447         return Fraction.Fraction128({ num: 1, den: 1 });
1448     }
1449 }
1450 
1451 // File: contracts/lib/MathHelpers.sol
1452 
1453 /**
1454  * @title MathHelpers
1455  * @author dYdX
1456  *
1457  * This library helps with common math functions in Solidity
1458  */
1459 library MathHelpers {
1460     using SafeMath for uint256;
1461 
1462     /**
1463      * Calculates partial value given a numerator and denominator.
1464      *
1465      * @param  numerator    Numerator
1466      * @param  denominator  Denominator
1467      * @param  target       Value to calculate partial of
1468      * @return              target * numerator / denominator
1469      */
1470     function getPartialAmount(
1471         uint256 numerator,
1472         uint256 denominator,
1473         uint256 target
1474     )
1475         internal
1476         pure
1477         returns (uint256)
1478     {
1479         return numerator.mul(target).div(denominator);
1480     }
1481 
1482     /**
1483      * Calculates partial value given a numerator and denominator, rounded up.
1484      *
1485      * @param  numerator    Numerator
1486      * @param  denominator  Denominator
1487      * @param  target       Value to calculate partial of
1488      * @return              Rounded-up result of target * numerator / denominator
1489      */
1490     function getPartialAmountRoundedUp(
1491         uint256 numerator,
1492         uint256 denominator,
1493         uint256 target
1494     )
1495         internal
1496         pure
1497         returns (uint256)
1498     {
1499         return divisionRoundedUp(numerator.mul(target), denominator);
1500     }
1501 
1502     /**
1503      * Calculates division given a numerator and denominator, rounded up.
1504      *
1505      * @param  numerator    Numerator.
1506      * @param  denominator  Denominator.
1507      * @return              Rounded-up result of numerator / denominator
1508      */
1509     function divisionRoundedUp(
1510         uint256 numerator,
1511         uint256 denominator
1512     )
1513         internal
1514         pure
1515         returns (uint256)
1516     {
1517         assert(denominator != 0); // coverage-enable-line
1518         if (numerator == 0) {
1519             return 0;
1520         }
1521         return numerator.sub(1).div(denominator).add(1);
1522     }
1523 
1524     /**
1525      * Calculates and returns the maximum value for a uint256 in solidity
1526      *
1527      * @return  The maximum value for uint256
1528      */
1529     function maxUint256(
1530     )
1531         internal
1532         pure
1533         returns (uint256)
1534     {
1535         return 2 ** 256 - 1;
1536     }
1537 
1538     /**
1539      * Calculates and returns the maximum value for a uint256 in solidity
1540      *
1541      * @return  The maximum value for uint256
1542      */
1543     function maxUint32(
1544     )
1545         internal
1546         pure
1547         returns (uint32)
1548     {
1549         return 2 ** 32 - 1;
1550     }
1551 
1552     /**
1553      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1554      *
1555      * @param  n  The uint256 to get the number of bits in
1556      * @return    The number of bits in n
1557      */
1558     function getNumBits(
1559         uint256 n
1560     )
1561         internal
1562         pure
1563         returns (uint256)
1564     {
1565         uint256 first = 0;
1566         uint256 last = 256;
1567         while (first < last) {
1568             uint256 check = (first + last) / 2;
1569             if ((n >> check) == 0) {
1570                 last = check;
1571             } else {
1572                 first = check + 1;
1573             }
1574         }
1575         assert(first <= 256);
1576         return first;
1577     }
1578 }
1579 
1580 // File: contracts/margin/impl/InterestImpl.sol
1581 
1582 /**
1583  * @title InterestImpl
1584  * @author dYdX
1585  *
1586  * A library that calculates continuously compounded interest for principal, time period, and
1587  * interest rate.
1588  */
1589 library InterestImpl {
1590     using SafeMath for uint256;
1591     using FractionMath for Fraction.Fraction128;
1592 
1593     // ============ Constants ============
1594 
1595     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1596 
1597     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1598 
1599     uint256 constant MAXIMUM_EXPONENT = 80;
1600 
1601     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1602 
1603     // ============ Public Implementation Functions ============
1604 
1605     /**
1606      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1607      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1608      * I = P * e^(R*T)
1609      *
1610      * @param  principal           Principal of the interest calculation
1611      * @param  interestRate        Annual nominal interest percentage times 10**6.
1612      *                             (example: 5% = 5e6)
1613      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1614      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1615      */
1616     function getCompoundedInterest(
1617         uint256 principal,
1618         uint256 interestRate,
1619         uint256 secondsOfInterest
1620     )
1621         public
1622         pure
1623         returns (uint256)
1624     {
1625         uint256 numerator = interestRate.mul(secondsOfInterest);
1626         uint128 denominator = (10**8) * (365 * 1 days);
1627 
1628         // interestRate and secondsOfInterest should both be uint32
1629         assert(numerator < 2**128);
1630 
1631         // fraction representing (Rate * Time)
1632         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1633             num: uint128(numerator),
1634             den: denominator
1635         });
1636 
1637         // calculate e^(RT)
1638         Fraction.Fraction128 memory eToRT;
1639         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1640             // degenerate case: cap calculation
1641             eToRT = Fraction.Fraction128({
1642                 num: E_TO_MAXIUMUM_EXPONENT,
1643                 den: 1
1644             });
1645         } else {
1646             // normal case: calculate e^(RT)
1647             eToRT = Exponent.exp(
1648                 rt,
1649                 DEFAULT_PRECOMPUTE_PRECISION,
1650                 DEFAULT_MACLAURIN_PRECISION
1651             );
1652         }
1653 
1654         // e^X for positive X should be greater-than or equal to 1
1655         assert(eToRT.num >= eToRT.den);
1656 
1657         return safeMultiplyUint256ByFraction(principal, eToRT);
1658     }
1659 
1660     // ============ Private Helper-Functions ============
1661 
1662     /**
1663      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1664      * and denominator of f are less than 2**128.
1665      */
1666     function safeMultiplyUint256ByFraction(
1667         uint256 n,
1668         Fraction.Fraction128 memory f
1669     )
1670         private
1671         pure
1672         returns (uint256)
1673     {
1674         uint256 term1 = n.div(2 ** 128); // first 128 bits
1675         uint256 term2 = n % (2 ** 128); // second 128 bits
1676 
1677         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1678         if (term1 > 0) {
1679             term1 = term1.mul(f.num);
1680             uint256 numBits = MathHelpers.getNumBits(term1);
1681 
1682             // reduce rounding error by shifting all the way to the left before dividing
1683             term1 = MathHelpers.divisionRoundedUp(
1684                 term1 << (uint256(256).sub(numBits)),
1685                 f.den);
1686 
1687             // continue shifting or reduce shifting to get the right number
1688             if (numBits > 128) {
1689                 term1 = term1 << (numBits.sub(128));
1690             } else if (numBits < 128) {
1691                 term1 = term1 >> (uint256(128).sub(numBits));
1692             }
1693         }
1694 
1695         // calculates term2 = term2 * f
1696         term2 = MathHelpers.getPartialAmountRoundedUp(
1697             f.num,
1698             f.den,
1699             term2
1700         );
1701 
1702         return term1.add(term2);
1703     }
1704 }
1705 
1706 // File: contracts/margin/impl/MarginState.sol
1707 
1708 /**
1709  * @title MarginState
1710  * @author dYdX
1711  *
1712  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1713  */
1714 library MarginState {
1715     struct State {
1716         // Address of the Vault contract
1717         address VAULT;
1718 
1719         // Address of the TokenProxy contract
1720         address TOKEN_PROXY;
1721 
1722         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1723         // already been filled.
1724         mapping (bytes32 => uint256) loanFills;
1725 
1726         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1727         // already been canceled.
1728         mapping (bytes32 => uint256) loanCancels;
1729 
1730         // Mapping from positionId -> Position, which stores all the open margin positions.
1731         mapping (bytes32 => MarginCommon.Position) positions;
1732 
1733         // Mapping from positionId -> bool, which stores whether the position has previously been
1734         // open, but is now closed.
1735         mapping (bytes32 => bool) closedPositions;
1736 
1737         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1738         // ever been repaid to the lender for each position. Does not reset.
1739         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1740     }
1741 }
1742 
1743 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1744 
1745 /**
1746  * @title LoanOwner
1747  * @author dYdX
1748  *
1749  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1750  *
1751  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1752  *       to these functions
1753  */
1754 interface LoanOwner {
1755 
1756     // ============ Public Interface functions ============
1757 
1758     /**
1759      * Function a contract must implement in order to receive ownership of a loan sell via the
1760      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1761      *
1762      * @param  from        Address of the previous owner
1763      * @param  positionId  Unique ID of the position
1764      * @return             This address to keep ownership, a different address to pass-on ownership
1765      */
1766     function receiveLoanOwnership(
1767         address from,
1768         bytes32 positionId
1769     )
1770         external
1771         /* onlyMargin */
1772         returns (address);
1773 }
1774 
1775 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1776 
1777 /**
1778  * @title PositionOwner
1779  * @author dYdX
1780  *
1781  * Interface that smart contracts must implement in order to own position on behalf of other
1782  * accounts
1783  *
1784  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1785  *       to these functions
1786  */
1787 interface PositionOwner {
1788 
1789     // ============ Public Interface functions ============
1790 
1791     /**
1792      * Function a contract must implement in order to receive ownership of a position via the
1793      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1794      *
1795      * @param  from        Address of the previous owner
1796      * @param  positionId  Unique ID of the position
1797      * @return             This address to keep ownership, a different address to pass-on ownership
1798      */
1799     function receivePositionOwnership(
1800         address from,
1801         bytes32 positionId
1802     )
1803         external
1804         /* onlyMargin */
1805         returns (address);
1806 }
1807 
1808 // File: contracts/margin/impl/TransferInternal.sol
1809 
1810 /**
1811  * @title TransferInternal
1812  * @author dYdX
1813  *
1814  * This library contains the implementation for transferring ownership of loans and positions.
1815  */
1816 library TransferInternal {
1817 
1818     // ============ Events ============
1819 
1820     /**
1821      * Ownership of a loan was transferred to a new address
1822      */
1823     event LoanTransferred(
1824         bytes32 indexed positionId,
1825         address indexed from,
1826         address indexed to
1827     );
1828 
1829     /**
1830      * Ownership of a postion was transferred to a new address
1831      */
1832     event PositionTransferred(
1833         bytes32 indexed positionId,
1834         address indexed from,
1835         address indexed to
1836     );
1837 
1838     // ============ Internal Implementation Functions ============
1839 
1840     /**
1841      * Returns either the address of the new loan owner, or the address to which they wish to
1842      * pass ownership of the loan. This function does not actually set the state of the position
1843      *
1844      * @param  positionId  The Unique ID of the position
1845      * @param  oldOwner    The previous owner of the loan
1846      * @param  newOwner    The intended owner of the loan
1847      * @return             The address that the intended owner wishes to assign the loan to (may be
1848      *                     the same as the intended owner).
1849      */
1850     function grantLoanOwnership(
1851         bytes32 positionId,
1852         address oldOwner,
1853         address newOwner
1854     )
1855         internal
1856         returns (address)
1857     {
1858         // log event except upon position creation
1859         if (oldOwner != address(0)) {
1860             emit LoanTransferred(positionId, oldOwner, newOwner);
1861         }
1862 
1863         if (AddressUtils.isContract(newOwner)) {
1864             address nextOwner =
1865                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1866             if (nextOwner != newOwner) {
1867                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1868             }
1869         }
1870 
1871         require(
1872             newOwner != address(0),
1873             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1874         );
1875 
1876         return newOwner;
1877     }
1878 
1879     /**
1880      * Returns either the address of the new position owner, or the address to which they wish to
1881      * pass ownership of the position. This function does not actually set the state of the position
1882      *
1883      * @param  positionId  The Unique ID of the position
1884      * @param  oldOwner    The previous owner of the position
1885      * @param  newOwner    The intended owner of the position
1886      * @return             The address that the intended owner wishes to assign the position to (may
1887      *                     be the same as the intended owner).
1888      */
1889     function grantPositionOwnership(
1890         bytes32 positionId,
1891         address oldOwner,
1892         address newOwner
1893     )
1894         internal
1895         returns (address)
1896     {
1897         // log event except upon position creation
1898         if (oldOwner != address(0)) {
1899             emit PositionTransferred(positionId, oldOwner, newOwner);
1900         }
1901 
1902         if (AddressUtils.isContract(newOwner)) {
1903             address nextOwner =
1904                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1905             if (nextOwner != newOwner) {
1906                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1907             }
1908         }
1909 
1910         require(
1911             newOwner != address(0),
1912             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1913         );
1914 
1915         return newOwner;
1916     }
1917 }
1918 
1919 // File: contracts/lib/TimestampHelper.sol
1920 
1921 /**
1922  * @title TimestampHelper
1923  * @author dYdX
1924  *
1925  * Helper to get block timestamps in other formats
1926  */
1927 library TimestampHelper {
1928     function getBlockTimestamp32()
1929         internal
1930         view
1931         returns (uint32)
1932     {
1933         // Should not still be in-use in the year 2106
1934         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1935 
1936         assert(block.timestamp > 0);
1937 
1938         return uint32(block.timestamp);
1939     }
1940 }
1941 
1942 // File: contracts/margin/impl/MarginCommon.sol
1943 
1944 /**
1945  * @title MarginCommon
1946  * @author dYdX
1947  *
1948  * This library contains common functions for implementations of public facing Margin functions
1949  */
1950 library MarginCommon {
1951     using SafeMath for uint256;
1952 
1953     // ============ Structs ============
1954 
1955     struct Position {
1956         address owedToken;       // Immutable
1957         address heldToken;       // Immutable
1958         address lender;
1959         address owner;
1960         uint256 principal;
1961         uint256 requiredDeposit;
1962         uint32  callTimeLimit;   // Immutable
1963         uint32  startTimestamp;  // Immutable, cannot be 0
1964         uint32  callTimestamp;
1965         uint32  maxDuration;     // Immutable
1966         uint32  interestRate;    // Immutable
1967         uint32  interestPeriod;  // Immutable
1968     }
1969 
1970     struct LoanOffering {
1971         address   owedToken;
1972         address   heldToken;
1973         address   payer;
1974         address   owner;
1975         address   taker;
1976         address   positionOwner;
1977         address   feeRecipient;
1978         address   lenderFeeToken;
1979         address   takerFeeToken;
1980         LoanRates rates;
1981         uint256   expirationTimestamp;
1982         uint32    callTimeLimit;
1983         uint32    maxDuration;
1984         uint256   salt;
1985         bytes32   loanHash;
1986         bytes     signature;
1987     }
1988 
1989     struct LoanRates {
1990         uint256 maxAmount;
1991         uint256 minAmount;
1992         uint256 minHeldToken;
1993         uint256 lenderFee;
1994         uint256 takerFee;
1995         uint32  interestRate;
1996         uint32  interestPeriod;
1997     }
1998 
1999     // ============ Internal Implementation Functions ============
2000 
2001     function storeNewPosition(
2002         MarginState.State storage state,
2003         bytes32 positionId,
2004         Position memory position,
2005         address loanPayer
2006     )
2007         internal
2008     {
2009         assert(!positionHasExisted(state, positionId));
2010         assert(position.owedToken != address(0));
2011         assert(position.heldToken != address(0));
2012         assert(position.owedToken != position.heldToken);
2013         assert(position.owner != address(0));
2014         assert(position.lender != address(0));
2015         assert(position.maxDuration != 0);
2016         assert(position.interestPeriod <= position.maxDuration);
2017         assert(position.callTimestamp == 0);
2018         assert(position.requiredDeposit == 0);
2019 
2020         state.positions[positionId].owedToken = position.owedToken;
2021         state.positions[positionId].heldToken = position.heldToken;
2022         state.positions[positionId].principal = position.principal;
2023         state.positions[positionId].callTimeLimit = position.callTimeLimit;
2024         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
2025         state.positions[positionId].maxDuration = position.maxDuration;
2026         state.positions[positionId].interestRate = position.interestRate;
2027         state.positions[positionId].interestPeriod = position.interestPeriod;
2028 
2029         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
2030             positionId,
2031             (position.owner != msg.sender) ? msg.sender : address(0),
2032             position.owner
2033         );
2034 
2035         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
2036             positionId,
2037             (position.lender != loanPayer) ? loanPayer : address(0),
2038             position.lender
2039         );
2040     }
2041 
2042     function getPositionIdFromNonce(
2043         uint256 nonce
2044     )
2045         internal
2046         view
2047         returns (bytes32)
2048     {
2049         return keccak256(abi.encodePacked(msg.sender, nonce));
2050     }
2051 
2052     function getUnavailableLoanOfferingAmountImpl(
2053         MarginState.State storage state,
2054         bytes32 loanHash
2055     )
2056         internal
2057         view
2058         returns (uint256)
2059     {
2060         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
2061     }
2062 
2063     function cleanupPosition(
2064         MarginState.State storage state,
2065         bytes32 positionId
2066     )
2067         internal
2068     {
2069         delete state.positions[positionId];
2070         state.closedPositions[positionId] = true;
2071     }
2072 
2073     function calculateOwedAmount(
2074         Position storage position,
2075         uint256 closeAmount,
2076         uint256 endTimestamp
2077     )
2078         internal
2079         view
2080         returns (uint256)
2081     {
2082         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
2083 
2084         return InterestImpl.getCompoundedInterest(
2085             closeAmount,
2086             position.interestRate,
2087             timeElapsed
2088         );
2089     }
2090 
2091     /**
2092      * Calculates time elapsed rounded up to the nearest interestPeriod
2093      */
2094     function calculateEffectiveTimeElapsed(
2095         Position storage position,
2096         uint256 timestamp
2097     )
2098         internal
2099         view
2100         returns (uint256)
2101     {
2102         uint256 elapsed = timestamp.sub(position.startTimestamp);
2103 
2104         // round up to interestPeriod
2105         uint256 period = position.interestPeriod;
2106         if (period > 1) {
2107             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
2108         }
2109 
2110         // bound by maxDuration
2111         return Math.min256(
2112             elapsed,
2113             position.maxDuration
2114         );
2115     }
2116 
2117     function calculateLenderAmountForIncreasePosition(
2118         Position storage position,
2119         uint256 principalToAdd,
2120         uint256 endTimestamp
2121     )
2122         internal
2123         view
2124         returns (uint256)
2125     {
2126         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
2127 
2128         return InterestImpl.getCompoundedInterest(
2129             principalToAdd,
2130             position.interestRate,
2131             timeElapsed
2132         );
2133     }
2134 
2135     function getLoanOfferingHash(
2136         LoanOffering loanOffering
2137     )
2138         internal
2139         view
2140         returns (bytes32)
2141     {
2142         return keccak256(
2143             abi.encodePacked(
2144                 address(this),
2145                 loanOffering.owedToken,
2146                 loanOffering.heldToken,
2147                 loanOffering.payer,
2148                 loanOffering.owner,
2149                 loanOffering.taker,
2150                 loanOffering.positionOwner,
2151                 loanOffering.feeRecipient,
2152                 loanOffering.lenderFeeToken,
2153                 loanOffering.takerFeeToken,
2154                 getValuesHash(loanOffering)
2155             )
2156         );
2157     }
2158 
2159     function getPositionBalanceImpl(
2160         MarginState.State storage state,
2161         bytes32 positionId
2162     )
2163         internal
2164         view
2165         returns(uint256)
2166     {
2167         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
2168     }
2169 
2170     function containsPositionImpl(
2171         MarginState.State storage state,
2172         bytes32 positionId
2173     )
2174         internal
2175         view
2176         returns (bool)
2177     {
2178         return state.positions[positionId].startTimestamp != 0;
2179     }
2180 
2181     function positionHasExisted(
2182         MarginState.State storage state,
2183         bytes32 positionId
2184     )
2185         internal
2186         view
2187         returns (bool)
2188     {
2189         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
2190     }
2191 
2192     function getPositionFromStorage(
2193         MarginState.State storage state,
2194         bytes32 positionId
2195     )
2196         internal
2197         view
2198         returns (Position storage)
2199     {
2200         Position storage position = state.positions[positionId];
2201 
2202         require(
2203             position.startTimestamp != 0,
2204             "MarginCommon#getPositionFromStorage: The position does not exist"
2205         );
2206 
2207         return position;
2208     }
2209 
2210     // ============ Private Helper-Functions ============
2211 
2212     /**
2213      * Calculates time elapsed rounded down to the nearest interestPeriod
2214      */
2215     function calculateEffectiveTimeElapsedForNewLender(
2216         Position storage position,
2217         uint256 timestamp
2218     )
2219         private
2220         view
2221         returns (uint256)
2222     {
2223         uint256 elapsed = timestamp.sub(position.startTimestamp);
2224 
2225         // round down to interestPeriod
2226         uint256 period = position.interestPeriod;
2227         if (period > 1) {
2228             elapsed = elapsed.div(period).mul(period);
2229         }
2230 
2231         // bound by maxDuration
2232         return Math.min256(
2233             elapsed,
2234             position.maxDuration
2235         );
2236     }
2237 
2238     function getValuesHash(
2239         LoanOffering loanOffering
2240     )
2241         private
2242         pure
2243         returns (bytes32)
2244     {
2245         return keccak256(
2246             abi.encodePacked(
2247                 loanOffering.rates.maxAmount,
2248                 loanOffering.rates.minAmount,
2249                 loanOffering.rates.minHeldToken,
2250                 loanOffering.rates.lenderFee,
2251                 loanOffering.rates.takerFee,
2252                 loanOffering.expirationTimestamp,
2253                 loanOffering.salt,
2254                 loanOffering.callTimeLimit,
2255                 loanOffering.maxDuration,
2256                 loanOffering.rates.interestRate,
2257                 loanOffering.rates.interestPeriod
2258             )
2259         );
2260     }
2261 }
2262 
2263 // File: contracts/margin/interfaces/PayoutRecipient.sol
2264 
2265 /**
2266  * @title PayoutRecipient
2267  * @author dYdX
2268  *
2269  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2270  * closePosition transaction.
2271  *
2272  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2273  *       to these functions
2274  */
2275 interface PayoutRecipient {
2276 
2277     // ============ Public Interface functions ============
2278 
2279     /**
2280      * Function a contract must implement in order to receive payout from being the payoutRecipient
2281      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2282      *
2283      * @param  positionId         Unique ID of the position
2284      * @param  closeAmount        Amount of the position that was closed
2285      * @param  closer             Address of the account or contract that closed the position
2286      * @param  positionOwner      Address of the owner of the position
2287      * @param  heldToken          Address of the ERC20 heldToken
2288      * @param  payout             Number of tokens received from the payout
2289      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2290      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2291      * @return                    True if approved by the receiver
2292      */
2293     function receiveClosePositionPayout(
2294         bytes32 positionId,
2295         uint256 closeAmount,
2296         address closer,
2297         address positionOwner,
2298         address heldToken,
2299         uint256 payout,
2300         uint256 totalHeldToken,
2301         bool    payoutInHeldToken
2302     )
2303         external
2304         /* onlyMargin */
2305         returns (bool);
2306 }
2307 
2308 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2309 
2310 /**
2311  * @title CloseLoanDelegator
2312  * @author dYdX
2313  *
2314  * Interface that smart contracts must implement in order to let other addresses close a loan
2315  * owned by the smart contract.
2316  *
2317  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2318  *       to these functions
2319  */
2320 interface CloseLoanDelegator {
2321 
2322     // ============ Public Interface functions ============
2323 
2324     /**
2325      * Function a contract must implement in order to let other addresses call
2326      * closeWithoutCounterparty().
2327      *
2328      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2329      * either revert the entire transaction or that (at most) the specified amount of the loan was
2330      * successfully closed.
2331      *
2332      * @param  closer           Address of the caller of closeWithoutCounterparty()
2333      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2334      * @param  positionId       Unique ID of the position
2335      * @param  requestedAmount  Requested principal amount of the loan to close
2336      * @return                  1) This address to accept, a different address to ask that contract
2337      *                          2) The maximum amount that this contract is allowing
2338      */
2339     function closeLoanOnBehalfOf(
2340         address closer,
2341         address payoutRecipient,
2342         bytes32 positionId,
2343         uint256 requestedAmount
2344     )
2345         external
2346         /* onlyMargin */
2347         returns (address, uint256);
2348 }
2349 
2350 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2351 
2352 /**
2353  * @title ClosePositionDelegator
2354  * @author dYdX
2355  *
2356  * Interface that smart contracts must implement in order to let other addresses close a position
2357  * owned by the smart contract, allowing more complex logic to control positions.
2358  *
2359  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2360  *       to these functions
2361  */
2362 interface ClosePositionDelegator {
2363 
2364     // ============ Public Interface functions ============
2365 
2366     /**
2367      * Function a contract must implement in order to let other addresses call closePosition().
2368      *
2369      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2370      * either revert the entire transaction or that (at-most) the specified amount of the position
2371      * was successfully closed.
2372      *
2373      * @param  closer           Address of the caller of the closePosition() function
2374      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2375      * @param  positionId       Unique ID of the position
2376      * @param  requestedAmount  Requested principal amount of the position to close
2377      * @return                  1) This address to accept, a different address to ask that contract
2378      *                          2) The maximum amount that this contract is allowing
2379      */
2380     function closeOnBehalfOf(
2381         address closer,
2382         address payoutRecipient,
2383         bytes32 positionId,
2384         uint256 requestedAmount
2385     )
2386         external
2387         /* onlyMargin */
2388         returns (address, uint256);
2389 }
2390 
2391 // File: contracts/margin/impl/ClosePositionShared.sol
2392 
2393 /**
2394  * @title ClosePositionShared
2395  * @author dYdX
2396  *
2397  * This library contains shared functionality between ClosePositionImpl and
2398  * CloseWithoutCounterpartyImpl
2399  */
2400 library ClosePositionShared {
2401     using SafeMath for uint256;
2402 
2403     // ============ Structs ============
2404 
2405     struct CloseTx {
2406         bytes32 positionId;
2407         uint256 originalPrincipal;
2408         uint256 closeAmount;
2409         uint256 owedTokenOwed;
2410         uint256 startingHeldTokenBalance;
2411         uint256 availableHeldToken;
2412         address payoutRecipient;
2413         address owedToken;
2414         address heldToken;
2415         address positionOwner;
2416         address positionLender;
2417         address exchangeWrapper;
2418         bool    payoutInHeldToken;
2419     }
2420 
2421     // ============ Internal Implementation Functions ============
2422 
2423     function closePositionStateUpdate(
2424         MarginState.State storage state,
2425         CloseTx memory transaction
2426     )
2427         internal
2428     {
2429         // Delete the position, or just decrease the principal
2430         if (transaction.closeAmount == transaction.originalPrincipal) {
2431             MarginCommon.cleanupPosition(state, transaction.positionId);
2432         } else {
2433             assert(
2434                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2435             );
2436             state.positions[transaction.positionId].principal =
2437                 transaction.originalPrincipal.sub(transaction.closeAmount);
2438         }
2439     }
2440 
2441     function sendTokensToPayoutRecipient(
2442         MarginState.State storage state,
2443         ClosePositionShared.CloseTx memory transaction,
2444         uint256 buybackCostInHeldToken,
2445         uint256 receivedOwedToken
2446     )
2447         internal
2448         returns (uint256)
2449     {
2450         uint256 payout;
2451 
2452         if (transaction.payoutInHeldToken) {
2453             // Send remaining heldToken to payoutRecipient
2454             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2455 
2456             Vault(state.VAULT).transferFromVault(
2457                 transaction.positionId,
2458                 transaction.heldToken,
2459                 transaction.payoutRecipient,
2460                 payout
2461             );
2462         } else {
2463             assert(transaction.exchangeWrapper != address(0));
2464 
2465             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2466 
2467             TokenProxy(state.TOKEN_PROXY).transferTokens(
2468                 transaction.owedToken,
2469                 transaction.exchangeWrapper,
2470                 transaction.payoutRecipient,
2471                 payout
2472             );
2473         }
2474 
2475         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2476             require(
2477                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2478                     transaction.positionId,
2479                     transaction.closeAmount,
2480                     msg.sender,
2481                     transaction.positionOwner,
2482                     transaction.heldToken,
2483                     payout,
2484                     transaction.availableHeldToken,
2485                     transaction.payoutInHeldToken
2486                 ),
2487                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2488             );
2489         }
2490 
2491         // The ending heldToken balance of the vault should be the starting heldToken balance
2492         // minus the available heldToken amount
2493         assert(
2494             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2495             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2496         );
2497 
2498         return payout;
2499     }
2500 
2501     function createCloseTx(
2502         MarginState.State storage state,
2503         bytes32 positionId,
2504         uint256 requestedAmount,
2505         address payoutRecipient,
2506         address exchangeWrapper,
2507         bool payoutInHeldToken,
2508         bool isWithoutCounterparty
2509     )
2510         internal
2511         returns (CloseTx memory)
2512     {
2513         // Validate
2514         require(
2515             payoutRecipient != address(0),
2516             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2517         );
2518         require(
2519             requestedAmount > 0,
2520             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2521         );
2522 
2523         MarginCommon.Position storage position =
2524             MarginCommon.getPositionFromStorage(state, positionId);
2525 
2526         uint256 closeAmount = getApprovedAmount(
2527             position,
2528             positionId,
2529             requestedAmount,
2530             payoutRecipient,
2531             isWithoutCounterparty
2532         );
2533 
2534         return parseCloseTx(
2535             state,
2536             position,
2537             positionId,
2538             closeAmount,
2539             payoutRecipient,
2540             exchangeWrapper,
2541             payoutInHeldToken,
2542             isWithoutCounterparty
2543         );
2544     }
2545 
2546     // ============ Private Helper-Functions ============
2547 
2548     function getApprovedAmount(
2549         MarginCommon.Position storage position,
2550         bytes32 positionId,
2551         uint256 requestedAmount,
2552         address payoutRecipient,
2553         bool requireLenderApproval
2554     )
2555         private
2556         returns (uint256)
2557     {
2558         // Ensure enough principal
2559         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2560 
2561         // Ensure owner consent
2562         allowedAmount = closePositionOnBehalfOfRecurse(
2563             position.owner,
2564             msg.sender,
2565             payoutRecipient,
2566             positionId,
2567             allowedAmount
2568         );
2569 
2570         // Ensure lender consent
2571         if (requireLenderApproval) {
2572             allowedAmount = closeLoanOnBehalfOfRecurse(
2573                 position.lender,
2574                 msg.sender,
2575                 payoutRecipient,
2576                 positionId,
2577                 allowedAmount
2578             );
2579         }
2580 
2581         assert(allowedAmount > 0);
2582         assert(allowedAmount <= position.principal);
2583         assert(allowedAmount <= requestedAmount);
2584 
2585         return allowedAmount;
2586     }
2587 
2588     function closePositionOnBehalfOfRecurse(
2589         address contractAddr,
2590         address closer,
2591         address payoutRecipient,
2592         bytes32 positionId,
2593         uint256 closeAmount
2594     )
2595         private
2596         returns (uint256)
2597     {
2598         // no need to ask for permission
2599         if (closer == contractAddr) {
2600             return closeAmount;
2601         }
2602 
2603         (
2604             address newContractAddr,
2605             uint256 newCloseAmount
2606         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2607             closer,
2608             payoutRecipient,
2609             positionId,
2610             closeAmount
2611         );
2612 
2613         require(
2614             newCloseAmount <= closeAmount,
2615             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2616         );
2617         require(
2618             newCloseAmount > 0,
2619             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2620         );
2621 
2622         if (newContractAddr != contractAddr) {
2623             closePositionOnBehalfOfRecurse(
2624                 newContractAddr,
2625                 closer,
2626                 payoutRecipient,
2627                 positionId,
2628                 newCloseAmount
2629             );
2630         }
2631 
2632         return newCloseAmount;
2633     }
2634 
2635     function closeLoanOnBehalfOfRecurse(
2636         address contractAddr,
2637         address closer,
2638         address payoutRecipient,
2639         bytes32 positionId,
2640         uint256 closeAmount
2641     )
2642         private
2643         returns (uint256)
2644     {
2645         // no need to ask for permission
2646         if (closer == contractAddr) {
2647             return closeAmount;
2648         }
2649 
2650         (
2651             address newContractAddr,
2652             uint256 newCloseAmount
2653         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2654                 closer,
2655                 payoutRecipient,
2656                 positionId,
2657                 closeAmount
2658             );
2659 
2660         require(
2661             newCloseAmount <= closeAmount,
2662             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2663         );
2664         require(
2665             newCloseAmount > 0,
2666             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2667         );
2668 
2669         if (newContractAddr != contractAddr) {
2670             closeLoanOnBehalfOfRecurse(
2671                 newContractAddr,
2672                 closer,
2673                 payoutRecipient,
2674                 positionId,
2675                 newCloseAmount
2676             );
2677         }
2678 
2679         return newCloseAmount;
2680     }
2681 
2682     // ============ Parsing Functions ============
2683 
2684     function parseCloseTx(
2685         MarginState.State storage state,
2686         MarginCommon.Position storage position,
2687         bytes32 positionId,
2688         uint256 closeAmount,
2689         address payoutRecipient,
2690         address exchangeWrapper,
2691         bool payoutInHeldToken,
2692         bool isWithoutCounterparty
2693     )
2694         private
2695         view
2696         returns (CloseTx memory)
2697     {
2698         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2699 
2700         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2701             closeAmount,
2702             position.principal,
2703             startingHeldTokenBalance
2704         );
2705         uint256 owedTokenOwed = 0;
2706 
2707         if (!isWithoutCounterparty) {
2708             owedTokenOwed = MarginCommon.calculateOwedAmount(
2709                 position,
2710                 closeAmount,
2711                 block.timestamp
2712             );
2713         }
2714 
2715         return CloseTx({
2716             positionId: positionId,
2717             originalPrincipal: position.principal,
2718             closeAmount: closeAmount,
2719             owedTokenOwed: owedTokenOwed,
2720             startingHeldTokenBalance: startingHeldTokenBalance,
2721             availableHeldToken: availableHeldToken,
2722             payoutRecipient: payoutRecipient,
2723             owedToken: position.owedToken,
2724             heldToken: position.heldToken,
2725             positionOwner: position.owner,
2726             positionLender: position.lender,
2727             exchangeWrapper: exchangeWrapper,
2728             payoutInHeldToken: payoutInHeldToken
2729         });
2730     }
2731 }
2732 
2733 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2734 
2735 /**
2736  * @title ExchangeWrapper
2737  * @author dYdX
2738  *
2739  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2740  * with other smart contracts through a common interface.
2741  */
2742 interface ExchangeWrapper {
2743 
2744     // ============ Public Functions ============
2745 
2746     /**
2747      * Exchange some amount of takerToken for makerToken.
2748      *
2749      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2750      *                              cannot always be trusted as it is set at the discretion of the
2751      *                              msg.sender)
2752      * @param  receiver             Address to set allowance on once the trade has completed
2753      * @param  makerToken           Address of makerToken, the token to receive
2754      * @param  takerToken           Address of takerToken, the token to pay
2755      * @param  requestedFillAmount  Amount of takerToken being paid
2756      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2757      * @return                      The amount of makerToken received
2758      */
2759     function exchange(
2760         address tradeOriginator,
2761         address receiver,
2762         address makerToken,
2763         address takerToken,
2764         uint256 requestedFillAmount,
2765         bytes orderData
2766     )
2767         external
2768         returns (uint256);
2769 
2770     /**
2771      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2772      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2773      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2774      * than desiredMakerToken
2775      *
2776      * @param  makerToken         Address of makerToken, the token to receive
2777      * @param  takerToken         Address of takerToken, the token to pay
2778      * @param  desiredMakerToken  Amount of makerToken requested
2779      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2780      * @return                    Amount of takerToken the needed to complete the transaction
2781      */
2782     function getExchangeCost(
2783         address makerToken,
2784         address takerToken,
2785         uint256 desiredMakerToken,
2786         bytes orderData
2787     )
2788         external
2789         view
2790         returns (uint256);
2791 }
2792 
2793 // File: contracts/margin/impl/ClosePositionImpl.sol
2794 
2795 /**
2796  * @title ClosePositionImpl
2797  * @author dYdX
2798  *
2799  * This library contains the implementation for the closePosition function of Margin
2800  */
2801 library ClosePositionImpl {
2802     using SafeMath for uint256;
2803 
2804     // ============ Events ============
2805 
2806     /**
2807      * A position was closed or partially closed
2808      */
2809     event PositionClosed(
2810         bytes32 indexed positionId,
2811         address indexed closer,
2812         address indexed payoutRecipient,
2813         uint256 closeAmount,
2814         uint256 remainingAmount,
2815         uint256 owedTokenPaidToLender,
2816         uint256 payoutAmount,
2817         uint256 buybackCostInHeldToken,
2818         bool    payoutInHeldToken
2819     );
2820 
2821     // ============ Public Implementation Functions ============
2822 
2823     function closePositionImpl(
2824         MarginState.State storage state,
2825         bytes32 positionId,
2826         uint256 requestedCloseAmount,
2827         address payoutRecipient,
2828         address exchangeWrapper,
2829         bool payoutInHeldToken,
2830         bytes memory orderData
2831     )
2832         public
2833         returns (uint256, uint256, uint256)
2834     {
2835         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2836             state,
2837             positionId,
2838             requestedCloseAmount,
2839             payoutRecipient,
2840             exchangeWrapper,
2841             payoutInHeldToken,
2842             false
2843         );
2844 
2845         (
2846             uint256 buybackCostInHeldToken,
2847             uint256 receivedOwedToken
2848         ) = returnOwedTokensToLender(
2849             state,
2850             transaction,
2851             orderData
2852         );
2853 
2854         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2855             state,
2856             transaction,
2857             buybackCostInHeldToken,
2858             receivedOwedToken
2859         );
2860 
2861         ClosePositionShared.closePositionStateUpdate(state, transaction);
2862 
2863         logEventOnClose(
2864             transaction,
2865             buybackCostInHeldToken,
2866             payout
2867         );
2868 
2869         return (
2870             transaction.closeAmount,
2871             payout,
2872             transaction.owedTokenOwed
2873         );
2874     }
2875 
2876     // ============ Private Helper-Functions ============
2877 
2878     function returnOwedTokensToLender(
2879         MarginState.State storage state,
2880         ClosePositionShared.CloseTx memory transaction,
2881         bytes memory orderData
2882     )
2883         private
2884         returns (uint256, uint256)
2885     {
2886         uint256 buybackCostInHeldToken = 0;
2887         uint256 receivedOwedToken = 0;
2888         uint256 lenderOwedToken = transaction.owedTokenOwed;
2889 
2890         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2891         // from msg.sender
2892         if (transaction.exchangeWrapper == address(0)) {
2893             require(
2894                 transaction.payoutInHeldToken,
2895                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2896             );
2897 
2898             // No DEX Order; send owedTokens directly from the closer to the lender
2899             TokenProxy(state.TOKEN_PROXY).transferTokens(
2900                 transaction.owedToken,
2901                 msg.sender,
2902                 transaction.positionLender,
2903                 lenderOwedToken
2904             );
2905         } else {
2906             // Buy back owedTokens using DEX Order and send to lender
2907             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2908                 state,
2909                 transaction,
2910                 orderData
2911             );
2912 
2913             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2914             if (transaction.payoutInHeldToken) {
2915                 assert(receivedOwedToken >= lenderOwedToken);
2916                 lenderOwedToken = receivedOwedToken;
2917             }
2918 
2919             // Transfer owedToken from the exchange wrapper to the lender
2920             TokenProxy(state.TOKEN_PROXY).transferTokens(
2921                 transaction.owedToken,
2922                 transaction.exchangeWrapper,
2923                 transaction.positionLender,
2924                 lenderOwedToken
2925             );
2926         }
2927 
2928         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2929             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2930 
2931         return (buybackCostInHeldToken, receivedOwedToken);
2932     }
2933 
2934     function buyBackOwedToken(
2935         MarginState.State storage state,
2936         ClosePositionShared.CloseTx transaction,
2937         bytes memory orderData
2938     )
2939         private
2940         returns (uint256, uint256)
2941     {
2942         // Ask the exchange wrapper the cost in heldToken to buy back the close
2943         // amount of owedToken
2944         uint256 buybackCostInHeldToken;
2945 
2946         if (transaction.payoutInHeldToken) {
2947             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2948                 .getExchangeCost(
2949                     transaction.owedToken,
2950                     transaction.heldToken,
2951                     transaction.owedTokenOwed,
2952                     orderData
2953                 );
2954 
2955             // Require enough available heldToken to pay for the buyback
2956             require(
2957                 buybackCostInHeldToken <= transaction.availableHeldToken,
2958                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2959             );
2960         } else {
2961             buybackCostInHeldToken = transaction.availableHeldToken;
2962         }
2963 
2964         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2965         Vault(state.VAULT).transferFromVault(
2966             transaction.positionId,
2967             transaction.heldToken,
2968             transaction.exchangeWrapper,
2969             buybackCostInHeldToken
2970         );
2971 
2972         // Trade the heldToken for the owedToken
2973         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2974             msg.sender,
2975             state.TOKEN_PROXY,
2976             transaction.owedToken,
2977             transaction.heldToken,
2978             buybackCostInHeldToken,
2979             orderData
2980         );
2981 
2982         require(
2983             receivedOwedToken >= transaction.owedTokenOwed,
2984             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2985         );
2986 
2987         return (buybackCostInHeldToken, receivedOwedToken);
2988     }
2989 
2990     function logEventOnClose(
2991         ClosePositionShared.CloseTx transaction,
2992         uint256 buybackCostInHeldToken,
2993         uint256 payout
2994     )
2995         private
2996     {
2997         emit PositionClosed(
2998             transaction.positionId,
2999             msg.sender,
3000             transaction.payoutRecipient,
3001             transaction.closeAmount,
3002             transaction.originalPrincipal.sub(transaction.closeAmount),
3003             transaction.owedTokenOwed,
3004             payout,
3005             buybackCostInHeldToken,
3006             transaction.payoutInHeldToken
3007         );
3008     }
3009 
3010 }
3011 
3012 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
3013 
3014 /**
3015  * @title CloseWithoutCounterpartyImpl
3016  * @author dYdX
3017  *
3018  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
3019  * Margin
3020  */
3021 library CloseWithoutCounterpartyImpl {
3022     using SafeMath for uint256;
3023 
3024     // ============ Events ============
3025 
3026     /**
3027      * A position was closed or partially closed
3028      */
3029     event PositionClosed(
3030         bytes32 indexed positionId,
3031         address indexed closer,
3032         address indexed payoutRecipient,
3033         uint256 closeAmount,
3034         uint256 remainingAmount,
3035         uint256 owedTokenPaidToLender,
3036         uint256 payoutAmount,
3037         uint256 buybackCostInHeldToken,
3038         bool payoutInHeldToken
3039     );
3040 
3041     // ============ Public Implementation Functions ============
3042 
3043     function closeWithoutCounterpartyImpl(
3044         MarginState.State storage state,
3045         bytes32 positionId,
3046         uint256 requestedCloseAmount,
3047         address payoutRecipient
3048     )
3049         public
3050         returns (uint256, uint256)
3051     {
3052         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
3053             state,
3054             positionId,
3055             requestedCloseAmount,
3056             payoutRecipient,
3057             address(0),
3058             true,
3059             true
3060         );
3061 
3062         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
3063             state,
3064             transaction,
3065             0, // No buyback cost
3066             0  // Did not receive any owedToken
3067         );
3068 
3069         ClosePositionShared.closePositionStateUpdate(state, transaction);
3070 
3071         logEventOnCloseWithoutCounterparty(transaction);
3072 
3073         return (
3074             transaction.closeAmount,
3075             heldTokenPayout
3076         );
3077     }
3078 
3079     // ============ Private Helper-Functions ============
3080 
3081     function logEventOnCloseWithoutCounterparty(
3082         ClosePositionShared.CloseTx transaction
3083     )
3084         private
3085     {
3086         emit PositionClosed(
3087             transaction.positionId,
3088             msg.sender,
3089             transaction.payoutRecipient,
3090             transaction.closeAmount,
3091             transaction.originalPrincipal.sub(transaction.closeAmount),
3092             0,
3093             transaction.availableHeldToken,
3094             0,
3095             true
3096         );
3097     }
3098 }
3099 
3100 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
3101 
3102 /**
3103  * @title DepositCollateralDelegator
3104  * @author dYdX
3105  *
3106  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
3107  * into a position owned by the smart contract.
3108  *
3109  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3110  *       to these functions
3111  */
3112 interface DepositCollateralDelegator {
3113 
3114     // ============ Public Interface functions ============
3115 
3116     /**
3117      * Function a contract must implement in order to let other addresses call depositCollateral().
3118      *
3119      * @param  depositor   Address of the caller of the depositCollateral() function
3120      * @param  positionId  Unique ID of the position
3121      * @param  amount      Requested deposit amount
3122      * @return             This address to accept, a different address to ask that contract
3123      */
3124     function depositCollateralOnBehalfOf(
3125         address depositor,
3126         bytes32 positionId,
3127         uint256 amount
3128     )
3129         external
3130         /* onlyMargin */
3131         returns (address);
3132 }
3133 
3134 // File: contracts/margin/impl/DepositCollateralImpl.sol
3135 
3136 /**
3137  * @title DepositCollateralImpl
3138  * @author dYdX
3139  *
3140  * This library contains the implementation for the deposit function of Margin
3141  */
3142 library DepositCollateralImpl {
3143     using SafeMath for uint256;
3144 
3145     // ============ Events ============
3146 
3147     /**
3148      * Additional collateral for a position was posted by the owner
3149      */
3150     event AdditionalCollateralDeposited(
3151         bytes32 indexed positionId,
3152         uint256 amount,
3153         address depositor
3154     );
3155 
3156     /**
3157      * A margin call was canceled
3158      */
3159     event MarginCallCanceled(
3160         bytes32 indexed positionId,
3161         address indexed lender,
3162         address indexed owner,
3163         uint256 depositAmount
3164     );
3165 
3166     // ============ Public Implementation Functions ============
3167 
3168     function depositCollateralImpl(
3169         MarginState.State storage state,
3170         bytes32 positionId,
3171         uint256 depositAmount
3172     )
3173         public
3174     {
3175         MarginCommon.Position storage position =
3176             MarginCommon.getPositionFromStorage(state, positionId);
3177 
3178         require(
3179             depositAmount > 0,
3180             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
3181         );
3182 
3183         // Ensure owner consent
3184         depositCollateralOnBehalfOfRecurse(
3185             position.owner,
3186             msg.sender,
3187             positionId,
3188             depositAmount
3189         );
3190 
3191         Vault(state.VAULT).transferToVault(
3192             positionId,
3193             position.heldToken,
3194             msg.sender,
3195             depositAmount
3196         );
3197 
3198         // cancel margin call if applicable
3199         bool marginCallCanceled = false;
3200         uint256 requiredDeposit = position.requiredDeposit;
3201         if (position.callTimestamp > 0 && requiredDeposit > 0) {
3202             if (depositAmount >= requiredDeposit) {
3203                 position.requiredDeposit = 0;
3204                 position.callTimestamp = 0;
3205                 marginCallCanceled = true;
3206             } else {
3207                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
3208             }
3209         }
3210 
3211         emit AdditionalCollateralDeposited(
3212             positionId,
3213             depositAmount,
3214             msg.sender
3215         );
3216 
3217         if (marginCallCanceled) {
3218             emit MarginCallCanceled(
3219                 positionId,
3220                 position.lender,
3221                 msg.sender,
3222                 depositAmount
3223             );
3224         }
3225     }
3226 
3227     // ============ Private Helper-Functions ============
3228 
3229     function depositCollateralOnBehalfOfRecurse(
3230         address contractAddr,
3231         address depositor,
3232         bytes32 positionId,
3233         uint256 amount
3234     )
3235         private
3236     {
3237         // no need to ask for permission
3238         if (depositor == contractAddr) {
3239             return;
3240         }
3241 
3242         address newContractAddr =
3243             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
3244                 depositor,
3245                 positionId,
3246                 amount
3247             );
3248 
3249         // if not equal, recurse
3250         if (newContractAddr != contractAddr) {
3251             depositCollateralOnBehalfOfRecurse(
3252                 newContractAddr,
3253                 depositor,
3254                 positionId,
3255                 amount
3256             );
3257         }
3258     }
3259 }
3260 
3261 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
3262 
3263 /**
3264  * @title ForceRecoverCollateralDelegator
3265  * @author dYdX
3266  *
3267  * Interface that smart contracts must implement in order to let other addresses
3268  * forceRecoverCollateral() a loan owned by the smart contract.
3269  *
3270  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3271  *       to these functions
3272  */
3273 interface ForceRecoverCollateralDelegator {
3274 
3275     // ============ Public Interface functions ============
3276 
3277     /**
3278      * Function a contract must implement in order to let other addresses call
3279      * forceRecoverCollateral().
3280      *
3281      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3282      * will either revert the entire transaction or that the collateral was forcibly recovered.
3283      *
3284      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3285      * @param  positionId  Unique ID of the position
3286      * @param  recipient   Address to send the recovered tokens to
3287      * @return             This address to accept, a different address to ask that contract
3288      */
3289     function forceRecoverCollateralOnBehalfOf(
3290         address recoverer,
3291         bytes32 positionId,
3292         address recipient
3293     )
3294         external
3295         /* onlyMargin */
3296         returns (address);
3297 }
3298 
3299 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3300 
3301 /**
3302  * @title ForceRecoverCollateralImpl
3303  * @author dYdX
3304  *
3305  * This library contains the implementation for the forceRecoverCollateral function of Margin
3306  */
3307 library ForceRecoverCollateralImpl {
3308     using SafeMath for uint256;
3309 
3310     // ============ Events ============
3311 
3312     /**
3313      * Collateral for a position was forcibly recovered
3314      */
3315     event CollateralForceRecovered(
3316         bytes32 indexed positionId,
3317         address indexed recipient,
3318         uint256 amount
3319     );
3320 
3321     // ============ Public Implementation Functions ============
3322 
3323     function forceRecoverCollateralImpl(
3324         MarginState.State storage state,
3325         bytes32 positionId,
3326         address recipient
3327     )
3328         public
3329         returns (uint256)
3330     {
3331         MarginCommon.Position storage position =
3332             MarginCommon.getPositionFromStorage(state, positionId);
3333 
3334         // Can only force recover after either:
3335         // 1) The loan was called and the call period has elapsed
3336         // 2) The maxDuration of the position has elapsed
3337         require( /* solium-disable-next-line */
3338             (
3339                 position.callTimestamp > 0
3340                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3341             ) || (
3342                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3343             ),
3344             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3345         );
3346 
3347         // Ensure lender consent
3348         forceRecoverCollateralOnBehalfOfRecurse(
3349             position.lender,
3350             msg.sender,
3351             positionId,
3352             recipient
3353         );
3354 
3355         // Send the tokens
3356         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3357         Vault(state.VAULT).transferFromVault(
3358             positionId,
3359             position.heldToken,
3360             recipient,
3361             heldTokenRecovered
3362         );
3363 
3364         // Delete the position
3365         // NOTE: Since position is a storage pointer, this will also set all fields on
3366         //       the position variable to 0
3367         MarginCommon.cleanupPosition(
3368             state,
3369             positionId
3370         );
3371 
3372         // Log an event
3373         emit CollateralForceRecovered(
3374             positionId,
3375             recipient,
3376             heldTokenRecovered
3377         );
3378 
3379         return heldTokenRecovered;
3380     }
3381 
3382     // ============ Private Helper-Functions ============
3383 
3384     function forceRecoverCollateralOnBehalfOfRecurse(
3385         address contractAddr,
3386         address recoverer,
3387         bytes32 positionId,
3388         address recipient
3389     )
3390         private
3391     {
3392         // no need to ask for permission
3393         if (recoverer == contractAddr) {
3394             return;
3395         }
3396 
3397         address newContractAddr =
3398             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3399                 recoverer,
3400                 positionId,
3401                 recipient
3402             );
3403 
3404         if (newContractAddr != contractAddr) {
3405             forceRecoverCollateralOnBehalfOfRecurse(
3406                 newContractAddr,
3407                 recoverer,
3408                 positionId,
3409                 recipient
3410             );
3411         }
3412     }
3413 }
3414 
3415 // File: contracts/lib/TypedSignature.sol
3416 
3417 /**
3418  * @title TypedSignature
3419  * @author dYdX
3420  *
3421  * Allows for ecrecovery of signed hashes with three different prepended messages:
3422  * 1) ""
3423  * 2) "\x19Ethereum Signed Message:\n32"
3424  * 3) "\x19Ethereum Signed Message:\n\x20"
3425  */
3426 library TypedSignature {
3427 
3428     // Solidity does not offer guarantees about enum values, so we define them explicitly
3429     uint8 private constant SIGTYPE_INVALID = 0;
3430     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3431     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3432     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3433 
3434     // prepended message with the length of the signed hash in hexadecimal
3435     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3436 
3437     // prepended message with the length of the signed hash in decimal
3438     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3439 
3440     /**
3441      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3442      *
3443      * @param  hash               Hash that was signed (does not include prepended message)
3444      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3445      * @return                    address of the signer of the hash
3446      */
3447     function recover(
3448         bytes32 hash,
3449         bytes signatureWithType
3450     )
3451         internal
3452         pure
3453         returns (address)
3454     {
3455         require(
3456             signatureWithType.length == 66,
3457             "SignatureValidator#validateSignature: invalid signature length"
3458         );
3459 
3460         uint8 sigType = uint8(signatureWithType[0]);
3461 
3462         require(
3463             sigType > uint8(SIGTYPE_INVALID),
3464             "SignatureValidator#validateSignature: invalid signature type"
3465         );
3466         require(
3467             sigType < uint8(SIGTYPE_UNSUPPORTED),
3468             "SignatureValidator#validateSignature: unsupported signature type"
3469         );
3470 
3471         uint8 v = uint8(signatureWithType[1]);
3472         bytes32 r;
3473         bytes32 s;
3474 
3475         /* solium-disable-next-line security/no-inline-assembly */
3476         assembly {
3477             r := mload(add(signatureWithType, 34))
3478             s := mload(add(signatureWithType, 66))
3479         }
3480 
3481         bytes32 signedHash;
3482         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3483             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3484         } else {
3485             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3486             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3487         }
3488 
3489         return ecrecover(
3490             signedHash,
3491             v,
3492             r,
3493             s
3494         );
3495     }
3496 }
3497 
3498 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3499 
3500 /**
3501  * @title LoanOfferingVerifier
3502  * @author dYdX
3503  *
3504  * Interface that smart contracts must implement to be able to make off-chain generated
3505  * loan offerings.
3506  *
3507  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3508  *       to these functions
3509  */
3510 interface LoanOfferingVerifier {
3511 
3512     /**
3513      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3514      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3515      * position.
3516      *
3517      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3518      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3519      * state on a loan.
3520      *
3521      * @param  addresses    Array of addresses:
3522      *
3523      *  [0] = owedToken
3524      *  [1] = heldToken
3525      *  [2] = loan payer
3526      *  [3] = loan owner
3527      *  [4] = loan taker
3528      *  [5] = loan positionOwner
3529      *  [6] = loan fee recipient
3530      *  [7] = loan lender fee token
3531      *  [8] = loan taker fee token
3532      *
3533      * @param  values256    Values corresponding to:
3534      *
3535      *  [0] = loan maximum amount
3536      *  [1] = loan minimum amount
3537      *  [2] = loan minimum heldToken
3538      *  [3] = loan lender fee
3539      *  [4] = loan taker fee
3540      *  [5] = loan expiration timestamp (in seconds)
3541      *  [6] = loan salt
3542      *
3543      * @param  values32     Values corresponding to:
3544      *
3545      *  [0] = loan call time limit (in seconds)
3546      *  [1] = loan maxDuration (in seconds)
3547      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3548      *  [3] = loan interest update period (in seconds)
3549      *
3550      * @param  positionId   Unique ID of the position
3551      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3552      * @return              This address to accept, a different address to ask that contract
3553      */
3554     function verifyLoanOffering(
3555         address[9] addresses,
3556         uint256[7] values256,
3557         uint32[4] values32,
3558         bytes32 positionId,
3559         bytes signature
3560     )
3561         external
3562         /* onlyMargin */
3563         returns (address);
3564 }
3565 
3566 // File: contracts/margin/impl/BorrowShared.sol
3567 
3568 /**
3569  * @title BorrowShared
3570  * @author dYdX
3571  *
3572  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3573  * Both use a Loan Offering and a DEX Order to open or increase a position.
3574  */
3575 library BorrowShared {
3576     using SafeMath for uint256;
3577 
3578     // ============ Structs ============
3579 
3580     struct Tx {
3581         bytes32 positionId;
3582         address owner;
3583         uint256 principal;
3584         uint256 lenderAmount;
3585         MarginCommon.LoanOffering loanOffering;
3586         address exchangeWrapper;
3587         bool depositInHeldToken;
3588         uint256 depositAmount;
3589         uint256 collateralAmount;
3590         uint256 heldTokenFromSell;
3591     }
3592 
3593     // ============ Internal Implementation Functions ============
3594 
3595     /**
3596      * Validate the transaction before exchanging heldToken for owedToken
3597      */
3598     function validateTxPreSell(
3599         MarginState.State storage state,
3600         Tx memory transaction
3601     )
3602         internal
3603     {
3604         assert(transaction.lenderAmount >= transaction.principal);
3605 
3606         require(
3607             transaction.principal > 0,
3608             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3609         );
3610 
3611         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3612         if (transaction.loanOffering.taker != address(0)) {
3613             require(
3614                 msg.sender == transaction.loanOffering.taker,
3615                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3616             );
3617         }
3618 
3619         // If the positionOwner is 0x0 then any address can be set as the position owner.
3620         // Otherwise only the specified positionOwner can be set as the position owner.
3621         if (transaction.loanOffering.positionOwner != address(0)) {
3622             require(
3623                 transaction.owner == transaction.loanOffering.positionOwner,
3624                 "BorrowShared#validateTxPreSell: Invalid position owner"
3625             );
3626         }
3627 
3628         // Require the loan offering to be approved by the payer
3629         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3630             getConsentFromSmartContractLender(transaction);
3631         } else {
3632             require(
3633                 transaction.loanOffering.payer == TypedSignature.recover(
3634                     transaction.loanOffering.loanHash,
3635                     transaction.loanOffering.signature
3636                 ),
3637                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3638             );
3639         }
3640 
3641         // Validate the amount is <= than max and >= min
3642         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3643             state,
3644             transaction.loanOffering.loanHash
3645         );
3646         require(
3647             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3648             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3649         );
3650 
3651         require(
3652             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3653             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3654         );
3655 
3656         require(
3657             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3658             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3659         );
3660 
3661         require(
3662             transaction.owner != address(0),
3663             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3664         );
3665 
3666         require(
3667             transaction.loanOffering.owner != address(0),
3668             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3669         );
3670 
3671         require(
3672             transaction.loanOffering.expirationTimestamp > block.timestamp,
3673             "BorrowShared#validateTxPreSell: Loan offering is expired"
3674         );
3675 
3676         require(
3677             transaction.loanOffering.maxDuration > 0,
3678             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3679         );
3680 
3681         require(
3682             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3683             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3684         );
3685 
3686         // The minimum heldToken is validated after executing the sell
3687         // Position and loan ownership is validated in TransferInternal
3688     }
3689 
3690     /**
3691      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3692      * how much of the loan was used.
3693      */
3694     function doPostSell(
3695         MarginState.State storage state,
3696         Tx memory transaction
3697     )
3698         internal
3699     {
3700         validateTxPostSell(transaction);
3701 
3702         // Transfer feeTokens from trader and lender
3703         transferLoanFees(state, transaction);
3704 
3705         // Update global amounts for the loan
3706         state.loanFills[transaction.loanOffering.loanHash] =
3707             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3708     }
3709 
3710     /**
3711      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3712      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3713      * maxHeldTokenToBuy of heldTokens at most.
3714      */
3715     function doSell(
3716         MarginState.State storage state,
3717         Tx transaction,
3718         bytes orderData,
3719         uint256 maxHeldTokenToBuy
3720     )
3721         internal
3722         returns (uint256)
3723     {
3724         // Move owedTokens from lender to exchange wrapper
3725         pullOwedTokensFromLender(state, transaction);
3726 
3727         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3728         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3729         uint256 sellAmount = transaction.depositInHeldToken ?
3730             transaction.lenderAmount :
3731             transaction.lenderAmount.add(transaction.depositAmount);
3732 
3733         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3734         uint256 heldTokenFromSell = Math.min256(
3735             maxHeldTokenToBuy,
3736             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3737                 msg.sender,
3738                 state.TOKEN_PROXY,
3739                 transaction.loanOffering.heldToken,
3740                 transaction.loanOffering.owedToken,
3741                 sellAmount,
3742                 orderData
3743             )
3744         );
3745 
3746         // Move the tokens to the vault
3747         Vault(state.VAULT).transferToVault(
3748             transaction.positionId,
3749             transaction.loanOffering.heldToken,
3750             transaction.exchangeWrapper,
3751             heldTokenFromSell
3752         );
3753 
3754         // Update collateral amount
3755         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3756 
3757         return heldTokenFromSell;
3758     }
3759 
3760     /**
3761      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3762      * be sold for heldToken.
3763      */
3764     function doDepositOwedToken(
3765         MarginState.State storage state,
3766         Tx transaction
3767     )
3768         internal
3769     {
3770         TokenProxy(state.TOKEN_PROXY).transferTokens(
3771             transaction.loanOffering.owedToken,
3772             msg.sender,
3773             transaction.exchangeWrapper,
3774             transaction.depositAmount
3775         );
3776     }
3777 
3778     /**
3779      * Take the heldToken deposit from the trader and move it to the vault.
3780      */
3781     function doDepositHeldToken(
3782         MarginState.State storage state,
3783         Tx transaction
3784     )
3785         internal
3786     {
3787         Vault(state.VAULT).transferToVault(
3788             transaction.positionId,
3789             transaction.loanOffering.heldToken,
3790             msg.sender,
3791             transaction.depositAmount
3792         );
3793 
3794         // Update collateral amount
3795         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3796     }
3797 
3798     // ============ Private Helper-Functions ============
3799 
3800     function validateTxPostSell(
3801         Tx transaction
3802     )
3803         private
3804         pure
3805     {
3806         uint256 expectedCollateral = transaction.depositInHeldToken ?
3807             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3808             transaction.heldTokenFromSell;
3809         assert(transaction.collateralAmount == expectedCollateral);
3810 
3811         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3812             transaction.lenderAmount,
3813             transaction.loanOffering.rates.maxAmount,
3814             transaction.loanOffering.rates.minHeldToken
3815         );
3816         require(
3817             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3818             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3819         );
3820     }
3821 
3822     function getConsentFromSmartContractLender(
3823         Tx transaction
3824     )
3825         private
3826     {
3827         verifyLoanOfferingRecurse(
3828             transaction.loanOffering.payer,
3829             getLoanOfferingAddresses(transaction),
3830             getLoanOfferingValues256(transaction),
3831             getLoanOfferingValues32(transaction),
3832             transaction.positionId,
3833             transaction.loanOffering.signature
3834         );
3835     }
3836 
3837     function verifyLoanOfferingRecurse(
3838         address contractAddr,
3839         address[9] addresses,
3840         uint256[7] values256,
3841         uint32[4] values32,
3842         bytes32 positionId,
3843         bytes signature
3844     )
3845         private
3846     {
3847         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3848             addresses,
3849             values256,
3850             values32,
3851             positionId,
3852             signature
3853         );
3854 
3855         if (newContractAddr != contractAddr) {
3856             verifyLoanOfferingRecurse(
3857                 newContractAddr,
3858                 addresses,
3859                 values256,
3860                 values32,
3861                 positionId,
3862                 signature
3863             );
3864         }
3865     }
3866 
3867     function pullOwedTokensFromLender(
3868         MarginState.State storage state,
3869         Tx transaction
3870     )
3871         private
3872     {
3873         // Transfer owedToken to the exchange wrapper
3874         TokenProxy(state.TOKEN_PROXY).transferTokens(
3875             transaction.loanOffering.owedToken,
3876             transaction.loanOffering.payer,
3877             transaction.exchangeWrapper,
3878             transaction.lenderAmount
3879         );
3880     }
3881 
3882     function transferLoanFees(
3883         MarginState.State storage state,
3884         Tx transaction
3885     )
3886         private
3887     {
3888         // 0 fee address indicates no fees
3889         if (transaction.loanOffering.feeRecipient == address(0)) {
3890             return;
3891         }
3892 
3893         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3894 
3895         uint256 lenderFee = MathHelpers.getPartialAmount(
3896             transaction.lenderAmount,
3897             transaction.loanOffering.rates.maxAmount,
3898             transaction.loanOffering.rates.lenderFee
3899         );
3900         uint256 takerFee = MathHelpers.getPartialAmount(
3901             transaction.lenderAmount,
3902             transaction.loanOffering.rates.maxAmount,
3903             transaction.loanOffering.rates.takerFee
3904         );
3905 
3906         if (lenderFee > 0) {
3907             proxy.transferTokens(
3908                 transaction.loanOffering.lenderFeeToken,
3909                 transaction.loanOffering.payer,
3910                 transaction.loanOffering.feeRecipient,
3911                 lenderFee
3912             );
3913         }
3914 
3915         if (takerFee > 0) {
3916             proxy.transferTokens(
3917                 transaction.loanOffering.takerFeeToken,
3918                 msg.sender,
3919                 transaction.loanOffering.feeRecipient,
3920                 takerFee
3921             );
3922         }
3923     }
3924 
3925     function getLoanOfferingAddresses(
3926         Tx transaction
3927     )
3928         private
3929         pure
3930         returns (address[9])
3931     {
3932         return [
3933             transaction.loanOffering.owedToken,
3934             transaction.loanOffering.heldToken,
3935             transaction.loanOffering.payer,
3936             transaction.loanOffering.owner,
3937             transaction.loanOffering.taker,
3938             transaction.loanOffering.positionOwner,
3939             transaction.loanOffering.feeRecipient,
3940             transaction.loanOffering.lenderFeeToken,
3941             transaction.loanOffering.takerFeeToken
3942         ];
3943     }
3944 
3945     function getLoanOfferingValues256(
3946         Tx transaction
3947     )
3948         private
3949         pure
3950         returns (uint256[7])
3951     {
3952         return [
3953             transaction.loanOffering.rates.maxAmount,
3954             transaction.loanOffering.rates.minAmount,
3955             transaction.loanOffering.rates.minHeldToken,
3956             transaction.loanOffering.rates.lenderFee,
3957             transaction.loanOffering.rates.takerFee,
3958             transaction.loanOffering.expirationTimestamp,
3959             transaction.loanOffering.salt
3960         ];
3961     }
3962 
3963     function getLoanOfferingValues32(
3964         Tx transaction
3965     )
3966         private
3967         pure
3968         returns (uint32[4])
3969     {
3970         return [
3971             transaction.loanOffering.callTimeLimit,
3972             transaction.loanOffering.maxDuration,
3973             transaction.loanOffering.rates.interestRate,
3974             transaction.loanOffering.rates.interestPeriod
3975         ];
3976     }
3977 }
3978 
3979 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3980 
3981 /**
3982  * @title IncreaseLoanDelegator
3983  * @author dYdX
3984  *
3985  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3986  *
3987  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3988  *       to these functions
3989  */
3990 interface IncreaseLoanDelegator {
3991 
3992     // ============ Public Interface functions ============
3993 
3994     /**
3995      * Function a contract must implement in order to allow additional value to be added onto
3996      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3997      *
3998      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3999      * either revert the entire transaction or that the loan size was successfully increased.
4000      *
4001      * @param  payer           Lender adding additional funds to the position
4002      * @param  positionId      Unique ID of the position
4003      * @param  principalAdded  Principal amount to be added to the position
4004      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
4005      *                         zero if increaseWithoutCounterparty() is used).
4006      * @return                 This address to accept, a different address to ask that contract
4007      */
4008     function increaseLoanOnBehalfOf(
4009         address payer,
4010         bytes32 positionId,
4011         uint256 principalAdded,
4012         uint256 lentAmount
4013     )
4014         external
4015         /* onlyMargin */
4016         returns (address);
4017 }
4018 
4019 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
4020 
4021 /**
4022  * @title IncreasePositionDelegator
4023  * @author dYdX
4024  *
4025  * Interface that smart contracts must implement in order to own position on behalf of other
4026  * accounts
4027  *
4028  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4029  *       to these functions
4030  */
4031 interface IncreasePositionDelegator {
4032 
4033     // ============ Public Interface functions ============
4034 
4035     /**
4036      * Function a contract must implement in order to allow additional value to be added onto
4037      * an owned position. Margin will call this on the owner of a position during increasePosition()
4038      *
4039      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4040      * either revert the entire transaction or that the position size was successfully increased.
4041      *
4042      * @param  trader          Address initiating the addition of funds to the position
4043      * @param  positionId      Unique ID of the position
4044      * @param  principalAdded  Amount of principal to be added to the position
4045      * @return                 This address to accept, a different address to ask that contract
4046      */
4047     function increasePositionOnBehalfOf(
4048         address trader,
4049         bytes32 positionId,
4050         uint256 principalAdded
4051     )
4052         external
4053         /* onlyMargin */
4054         returns (address);
4055 }
4056 
4057 // File: contracts/margin/impl/IncreasePositionImpl.sol
4058 
4059 /**
4060  * @title IncreasePositionImpl
4061  * @author dYdX
4062  *
4063  * This library contains the implementation for the increasePosition function of Margin
4064  */
4065 library IncreasePositionImpl {
4066     using SafeMath for uint256;
4067 
4068     // ============ Events ============
4069 
4070     /*
4071      * A position was increased
4072      */
4073     event PositionIncreased(
4074         bytes32 indexed positionId,
4075         address indexed trader,
4076         address indexed lender,
4077         address positionOwner,
4078         address loanOwner,
4079         bytes32 loanHash,
4080         address loanFeeRecipient,
4081         uint256 amountBorrowed,
4082         uint256 principalAdded,
4083         uint256 heldTokenFromSell,
4084         uint256 depositAmount,
4085         bool    depositInHeldToken
4086     );
4087 
4088     // ============ Public Implementation Functions ============
4089 
4090     function increasePositionImpl(
4091         MarginState.State storage state,
4092         bytes32 positionId,
4093         address[7] addresses,
4094         uint256[8] values256,
4095         uint32[2] values32,
4096         bool depositInHeldToken,
4097         bytes signature,
4098         bytes orderData
4099     )
4100         public
4101         returns (uint256)
4102     {
4103         // Also ensures that the position exists
4104         MarginCommon.Position storage position =
4105             MarginCommon.getPositionFromStorage(state, positionId);
4106 
4107         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
4108             position,
4109             positionId,
4110             addresses,
4111             values256,
4112             values32,
4113             depositInHeldToken,
4114             signature
4115         );
4116 
4117         validateIncrease(state, transaction, position);
4118 
4119         doBorrowAndSell(state, transaction, orderData);
4120 
4121         updateState(
4122             position,
4123             transaction.positionId,
4124             transaction.principal,
4125             transaction.lenderAmount,
4126             transaction.loanOffering.payer
4127         );
4128 
4129         // LOG EVENT
4130         recordPositionIncreased(transaction, position);
4131 
4132         return transaction.lenderAmount;
4133     }
4134 
4135     function increaseWithoutCounterpartyImpl(
4136         MarginState.State storage state,
4137         bytes32 positionId,
4138         uint256 principalToAdd
4139     )
4140         public
4141         returns (uint256)
4142     {
4143         MarginCommon.Position storage position =
4144             MarginCommon.getPositionFromStorage(state, positionId);
4145 
4146         // Disallow adding 0 principal
4147         require(
4148             principalToAdd > 0,
4149             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
4150         );
4151 
4152         // Disallow additions after maximum duration
4153         require(
4154             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
4155             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
4156         );
4157 
4158         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
4159             state,
4160             position,
4161             positionId,
4162             principalToAdd
4163         );
4164 
4165         Vault(state.VAULT).transferToVault(
4166             positionId,
4167             position.heldToken,
4168             msg.sender,
4169             heldTokenAmount
4170         );
4171 
4172         updateState(
4173             position,
4174             positionId,
4175             principalToAdd,
4176             0, // lent amount
4177             msg.sender
4178         );
4179 
4180         emit PositionIncreased(
4181             positionId,
4182             msg.sender,
4183             msg.sender,
4184             position.owner,
4185             position.lender,
4186             "",
4187             address(0),
4188             0,
4189             principalToAdd,
4190             0,
4191             heldTokenAmount,
4192             true
4193         );
4194 
4195         return heldTokenAmount;
4196     }
4197 
4198     // ============ Private Helper-Functions ============
4199 
4200     function doBorrowAndSell(
4201         MarginState.State storage state,
4202         BorrowShared.Tx memory transaction,
4203         bytes orderData
4204     )
4205         private
4206     {
4207         // Calculate the number of heldTokens to add
4208         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
4209             state,
4210             state.positions[transaction.positionId],
4211             transaction.positionId,
4212             transaction.principal
4213         );
4214 
4215         // Do pre-exchange validations
4216         BorrowShared.validateTxPreSell(state, transaction);
4217 
4218         // Calculate and deposit owedToken
4219         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
4220         if (!transaction.depositInHeldToken) {
4221             transaction.depositAmount =
4222                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
4223             BorrowShared.doDepositOwedToken(state, transaction);
4224             maxHeldTokenFromSell = collateralToAdd;
4225         }
4226 
4227         // Sell owedToken for heldToken using the exchange wrapper
4228         transaction.heldTokenFromSell = BorrowShared.doSell(
4229             state,
4230             transaction,
4231             orderData,
4232             maxHeldTokenFromSell
4233         );
4234 
4235         // Calculate and deposit heldToken
4236         if (transaction.depositInHeldToken) {
4237             require(
4238                 transaction.heldTokenFromSell <= collateralToAdd,
4239                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
4240             );
4241             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
4242             BorrowShared.doDepositHeldToken(state, transaction);
4243         }
4244 
4245         // Make sure the actual added collateral is what is expected
4246         assert(transaction.collateralAmount == collateralToAdd);
4247 
4248         // Do post-exchange validations
4249         BorrowShared.doPostSell(state, transaction);
4250     }
4251 
4252     function getOwedTokenDeposit(
4253         BorrowShared.Tx transaction,
4254         uint256 collateralToAdd,
4255         bytes orderData
4256     )
4257         private
4258         view
4259         returns (uint256)
4260     {
4261         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4262             transaction.loanOffering.heldToken,
4263             transaction.loanOffering.owedToken,
4264             collateralToAdd,
4265             orderData
4266         );
4267 
4268         require(
4269             transaction.lenderAmount <= totalOwedToken,
4270             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4271         );
4272 
4273         return totalOwedToken.sub(transaction.lenderAmount);
4274     }
4275 
4276     function validateIncrease(
4277         MarginState.State storage state,
4278         BorrowShared.Tx transaction,
4279         MarginCommon.Position storage position
4280     )
4281         private
4282         view
4283     {
4284         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4285 
4286         require(
4287             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4288             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4289         );
4290 
4291         // require the position to end no later than the loanOffering's maximum acceptable end time
4292         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4293         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4294         require(
4295             positionEndTimestamp <= offeringEndTimestamp,
4296             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4297         );
4298 
4299         require(
4300             block.timestamp < positionEndTimestamp,
4301             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4302         );
4303     }
4304 
4305     function getCollateralNeededForAddedPrincipal(
4306         MarginState.State storage state,
4307         MarginCommon.Position storage position,
4308         bytes32 positionId,
4309         uint256 principalToAdd
4310     )
4311         private
4312         view
4313         returns (uint256)
4314     {
4315         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4316 
4317         return MathHelpers.getPartialAmountRoundedUp(
4318             principalToAdd,
4319             position.principal,
4320             heldTokenBalance
4321         );
4322     }
4323 
4324     function updateState(
4325         MarginCommon.Position storage position,
4326         bytes32 positionId,
4327         uint256 principalAdded,
4328         uint256 owedTokenLent,
4329         address loanPayer
4330     )
4331         private
4332     {
4333         position.principal = position.principal.add(principalAdded);
4334 
4335         address owner = position.owner;
4336         address lender = position.lender;
4337 
4338         // Ensure owner consent
4339         increasePositionOnBehalfOfRecurse(
4340             owner,
4341             msg.sender,
4342             positionId,
4343             principalAdded
4344         );
4345 
4346         // Ensure lender consent
4347         increaseLoanOnBehalfOfRecurse(
4348             lender,
4349             loanPayer,
4350             positionId,
4351             principalAdded,
4352             owedTokenLent
4353         );
4354     }
4355 
4356     function increasePositionOnBehalfOfRecurse(
4357         address contractAddr,
4358         address trader,
4359         bytes32 positionId,
4360         uint256 principalAdded
4361     )
4362         private
4363     {
4364         // Assume owner approval if not a smart contract and they increased their own position
4365         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4366             return;
4367         }
4368 
4369         address newContractAddr =
4370             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4371                 trader,
4372                 positionId,
4373                 principalAdded
4374             );
4375 
4376         if (newContractAddr != contractAddr) {
4377             increasePositionOnBehalfOfRecurse(
4378                 newContractAddr,
4379                 trader,
4380                 positionId,
4381                 principalAdded
4382             );
4383         }
4384     }
4385 
4386     function increaseLoanOnBehalfOfRecurse(
4387         address contractAddr,
4388         address payer,
4389         bytes32 positionId,
4390         uint256 principalAdded,
4391         uint256 amountLent
4392     )
4393         private
4394     {
4395         // Assume lender approval if not a smart contract and they increased their own loan
4396         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4397             return;
4398         }
4399 
4400         address newContractAddr =
4401             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4402                 payer,
4403                 positionId,
4404                 principalAdded,
4405                 amountLent
4406             );
4407 
4408         if (newContractAddr != contractAddr) {
4409             increaseLoanOnBehalfOfRecurse(
4410                 newContractAddr,
4411                 payer,
4412                 positionId,
4413                 principalAdded,
4414                 amountLent
4415             );
4416         }
4417     }
4418 
4419     function recordPositionIncreased(
4420         BorrowShared.Tx transaction,
4421         MarginCommon.Position storage position
4422     )
4423         private
4424     {
4425         emit PositionIncreased(
4426             transaction.positionId,
4427             msg.sender,
4428             transaction.loanOffering.payer,
4429             position.owner,
4430             position.lender,
4431             transaction.loanOffering.loanHash,
4432             transaction.loanOffering.feeRecipient,
4433             transaction.lenderAmount,
4434             transaction.principal,
4435             transaction.heldTokenFromSell,
4436             transaction.depositAmount,
4437             transaction.depositInHeldToken
4438         );
4439     }
4440 
4441     // ============ Parsing Functions ============
4442 
4443     function parseIncreasePositionTx(
4444         MarginCommon.Position storage position,
4445         bytes32 positionId,
4446         address[7] addresses,
4447         uint256[8] values256,
4448         uint32[2] values32,
4449         bool depositInHeldToken,
4450         bytes signature
4451     )
4452         private
4453         view
4454         returns (BorrowShared.Tx memory)
4455     {
4456         uint256 principal = values256[7];
4457 
4458         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4459             position,
4460             principal,
4461             block.timestamp
4462         );
4463         assert(lenderAmount >= principal);
4464 
4465         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4466             positionId: positionId,
4467             owner: position.owner,
4468             principal: principal,
4469             lenderAmount: lenderAmount,
4470             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4471                 position,
4472                 addresses,
4473                 values256,
4474                 values32,
4475                 signature
4476             ),
4477             exchangeWrapper: addresses[6],
4478             depositInHeldToken: depositInHeldToken,
4479             depositAmount: 0, // set later
4480             collateralAmount: 0, // set later
4481             heldTokenFromSell: 0 // set later
4482         });
4483 
4484         return transaction;
4485     }
4486 
4487     function parseLoanOfferingFromIncreasePositionTx(
4488         MarginCommon.Position storage position,
4489         address[7] addresses,
4490         uint256[8] values256,
4491         uint32[2] values32,
4492         bytes signature
4493     )
4494         private
4495         view
4496         returns (MarginCommon.LoanOffering memory)
4497     {
4498         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4499             owedToken: position.owedToken,
4500             heldToken: position.heldToken,
4501             payer: addresses[0],
4502             owner: position.lender,
4503             taker: addresses[1],
4504             positionOwner: addresses[2],
4505             feeRecipient: addresses[3],
4506             lenderFeeToken: addresses[4],
4507             takerFeeToken: addresses[5],
4508             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4509             expirationTimestamp: values256[5],
4510             callTimeLimit: values32[0],
4511             maxDuration: values32[1],
4512             salt: values256[6],
4513             loanHash: 0,
4514             signature: signature
4515         });
4516 
4517         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4518 
4519         return loanOffering;
4520     }
4521 
4522     function parseLoanOfferingRatesFromIncreasePositionTx(
4523         MarginCommon.Position storage position,
4524         uint256[8] values256
4525     )
4526         private
4527         view
4528         returns (MarginCommon.LoanRates memory)
4529     {
4530         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4531             maxAmount: values256[0],
4532             minAmount: values256[1],
4533             minHeldToken: values256[2],
4534             lenderFee: values256[3],
4535             takerFee: values256[4],
4536             interestRate: position.interestRate,
4537             interestPeriod: position.interestPeriod
4538         });
4539 
4540         return rates;
4541     }
4542 }
4543 
4544 // File: contracts/margin/impl/MarginStorage.sol
4545 
4546 /**
4547  * @title MarginStorage
4548  * @author dYdX
4549  *
4550  * This contract serves as the storage for the entire state of MarginStorage
4551  */
4552 contract MarginStorage {
4553 
4554     MarginState.State state;
4555 
4556 }
4557 
4558 // File: contracts/margin/impl/LoanGetters.sol
4559 
4560 /**
4561  * @title LoanGetters
4562  * @author dYdX
4563  *
4564  * A collection of public constant getter functions that allows reading of the state of any loan
4565  * offering stored in the dYdX protocol.
4566  */
4567 contract LoanGetters is MarginStorage {
4568 
4569     // ============ Public Constant Functions ============
4570 
4571     /**
4572      * Gets the principal amount of a loan offering that is no longer available.
4573      *
4574      * @param  loanHash  Unique hash of the loan offering
4575      * @return           The total unavailable amount of the loan offering, which is equal to the
4576      *                   filled amount plus the canceled amount.
4577      */
4578     function getLoanUnavailableAmount(
4579         bytes32 loanHash
4580     )
4581         external
4582         view
4583         returns (uint256)
4584     {
4585         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4586     }
4587 
4588     /**
4589      * Gets the total amount of owed token lent for a loan.
4590      *
4591      * @param  loanHash  Unique hash of the loan offering
4592      * @return           The total filled amount of the loan offering.
4593      */
4594     function getLoanFilledAmount(
4595         bytes32 loanHash
4596     )
4597         external
4598         view
4599         returns (uint256)
4600     {
4601         return state.loanFills[loanHash];
4602     }
4603 
4604     /**
4605      * Gets the amount of a loan offering that has been canceled.
4606      *
4607      * @param  loanHash  Unique hash of the loan offering
4608      * @return           The total canceled amount of the loan offering.
4609      */
4610     function getLoanCanceledAmount(
4611         bytes32 loanHash
4612     )
4613         external
4614         view
4615         returns (uint256)
4616     {
4617         return state.loanCancels[loanHash];
4618     }
4619 }
4620 
4621 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4622 
4623 /**
4624  * @title CancelMarginCallDelegator
4625  * @author dYdX
4626  *
4627  * Interface that smart contracts must implement in order to let other addresses cancel a
4628  * margin-call for a loan owned by the smart contract.
4629  *
4630  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4631  *       to these functions
4632  */
4633 interface CancelMarginCallDelegator {
4634 
4635     // ============ Public Interface functions ============
4636 
4637     /**
4638      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4639      *
4640      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4641      * either revert the entire transaction or that the margin-call was successfully canceled.
4642      *
4643      * @param  canceler    Address of the caller of the cancelMarginCall function
4644      * @param  positionId  Unique ID of the position
4645      * @return             This address to accept, a different address to ask that contract
4646      */
4647     function cancelMarginCallOnBehalfOf(
4648         address canceler,
4649         bytes32 positionId
4650     )
4651         external
4652         /* onlyMargin */
4653         returns (address);
4654 }
4655 
4656 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4657 
4658 /**
4659  * @title MarginCallDelegator
4660  * @author dYdX
4661  *
4662  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4663  * owned by the smart contract.
4664  *
4665  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4666  *       to these functions
4667  */
4668 interface MarginCallDelegator {
4669 
4670     // ============ Public Interface functions ============
4671 
4672     /**
4673      * Function a contract must implement in order to let other addresses call marginCall().
4674      *
4675      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4676      * either revert the entire transaction or that the loan was successfully margin-called.
4677      *
4678      * @param  caller         Address of the caller of the marginCall function
4679      * @param  positionId     Unique ID of the position
4680      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4681      * @return                This address to accept, a different address to ask that contract
4682      */
4683     function marginCallOnBehalfOf(
4684         address caller,
4685         bytes32 positionId,
4686         uint256 depositAmount
4687     )
4688         external
4689         /* onlyMargin */
4690         returns (address);
4691 }
4692 
4693 // File: contracts/margin/impl/LoanImpl.sol
4694 
4695 /**
4696  * @title LoanImpl
4697  * @author dYdX
4698  *
4699  * This library contains the implementation for the following functions of Margin:
4700  *
4701  *      - marginCall
4702  *      - cancelMarginCallImpl
4703  *      - cancelLoanOffering
4704  */
4705 library LoanImpl {
4706     using SafeMath for uint256;
4707 
4708     // ============ Events ============
4709 
4710     /**
4711      * A position was margin-called
4712      */
4713     event MarginCallInitiated(
4714         bytes32 indexed positionId,
4715         address indexed lender,
4716         address indexed owner,
4717         uint256 requiredDeposit
4718     );
4719 
4720     /**
4721      * A margin call was canceled
4722      */
4723     event MarginCallCanceled(
4724         bytes32 indexed positionId,
4725         address indexed lender,
4726         address indexed owner,
4727         uint256 depositAmount
4728     );
4729 
4730     /**
4731      * A loan offering was canceled before it was used. Any amount less than the
4732      * total for the loan offering can be canceled.
4733      */
4734     event LoanOfferingCanceled(
4735         bytes32 indexed loanHash,
4736         address indexed payer,
4737         address indexed feeRecipient,
4738         uint256 cancelAmount
4739     );
4740 
4741     // ============ Public Implementation Functions ============
4742 
4743     function marginCallImpl(
4744         MarginState.State storage state,
4745         bytes32 positionId,
4746         uint256 requiredDeposit
4747     )
4748         public
4749     {
4750         MarginCommon.Position storage position =
4751             MarginCommon.getPositionFromStorage(state, positionId);
4752 
4753         require(
4754             position.callTimestamp == 0,
4755             "LoanImpl#marginCallImpl: The position has already been margin-called"
4756         );
4757 
4758         // Ensure lender consent
4759         marginCallOnBehalfOfRecurse(
4760             position.lender,
4761             msg.sender,
4762             positionId,
4763             requiredDeposit
4764         );
4765 
4766         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4767         position.requiredDeposit = requiredDeposit;
4768 
4769         emit MarginCallInitiated(
4770             positionId,
4771             position.lender,
4772             position.owner,
4773             requiredDeposit
4774         );
4775     }
4776 
4777     function cancelMarginCallImpl(
4778         MarginState.State storage state,
4779         bytes32 positionId
4780     )
4781         public
4782     {
4783         MarginCommon.Position storage position =
4784             MarginCommon.getPositionFromStorage(state, positionId);
4785 
4786         require(
4787             position.callTimestamp > 0,
4788             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4789         );
4790 
4791         // Ensure lender consent
4792         cancelMarginCallOnBehalfOfRecurse(
4793             position.lender,
4794             msg.sender,
4795             positionId
4796         );
4797 
4798         state.positions[positionId].callTimestamp = 0;
4799         state.positions[positionId].requiredDeposit = 0;
4800 
4801         emit MarginCallCanceled(
4802             positionId,
4803             position.lender,
4804             position.owner,
4805             0
4806         );
4807     }
4808 
4809     function cancelLoanOfferingImpl(
4810         MarginState.State storage state,
4811         address[9] addresses,
4812         uint256[7] values256,
4813         uint32[4]  values32,
4814         uint256    cancelAmount
4815     )
4816         public
4817         returns (uint256)
4818     {
4819         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4820             addresses,
4821             values256,
4822             values32
4823         );
4824 
4825         require(
4826             msg.sender == loanOffering.payer,
4827             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4828         );
4829         require(
4830             loanOffering.expirationTimestamp > block.timestamp,
4831             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4832         );
4833 
4834         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4835             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4836         );
4837         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4838 
4839         // If the loan was already fully canceled, then just return 0 amount was canceled
4840         if (amountToCancel == 0) {
4841             return 0;
4842         }
4843 
4844         state.loanCancels[loanOffering.loanHash] =
4845             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4846 
4847         emit LoanOfferingCanceled(
4848             loanOffering.loanHash,
4849             loanOffering.payer,
4850             loanOffering.feeRecipient,
4851             amountToCancel
4852         );
4853 
4854         return amountToCancel;
4855     }
4856 
4857     // ============ Private Helper-Functions ============
4858 
4859     function marginCallOnBehalfOfRecurse(
4860         address contractAddr,
4861         address who,
4862         bytes32 positionId,
4863         uint256 requiredDeposit
4864     )
4865         private
4866     {
4867         // no need to ask for permission
4868         if (who == contractAddr) {
4869             return;
4870         }
4871 
4872         address newContractAddr =
4873             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4874                 msg.sender,
4875                 positionId,
4876                 requiredDeposit
4877             );
4878 
4879         if (newContractAddr != contractAddr) {
4880             marginCallOnBehalfOfRecurse(
4881                 newContractAddr,
4882                 who,
4883                 positionId,
4884                 requiredDeposit
4885             );
4886         }
4887     }
4888 
4889     function cancelMarginCallOnBehalfOfRecurse(
4890         address contractAddr,
4891         address who,
4892         bytes32 positionId
4893     )
4894         private
4895     {
4896         // no need to ask for permission
4897         if (who == contractAddr) {
4898             return;
4899         }
4900 
4901         address newContractAddr =
4902             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4903                 msg.sender,
4904                 positionId
4905             );
4906 
4907         if (newContractAddr != contractAddr) {
4908             cancelMarginCallOnBehalfOfRecurse(
4909                 newContractAddr,
4910                 who,
4911                 positionId
4912             );
4913         }
4914     }
4915 
4916     // ============ Parsing Functions ============
4917 
4918     function parseLoanOffering(
4919         address[9] addresses,
4920         uint256[7] values256,
4921         uint32[4]  values32
4922     )
4923         private
4924         view
4925         returns (MarginCommon.LoanOffering memory)
4926     {
4927         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4928             owedToken: addresses[0],
4929             heldToken: addresses[1],
4930             payer: addresses[2],
4931             owner: addresses[3],
4932             taker: addresses[4],
4933             positionOwner: addresses[5],
4934             feeRecipient: addresses[6],
4935             lenderFeeToken: addresses[7],
4936             takerFeeToken: addresses[8],
4937             rates: parseLoanOfferRates(values256, values32),
4938             expirationTimestamp: values256[5],
4939             callTimeLimit: values32[0],
4940             maxDuration: values32[1],
4941             salt: values256[6],
4942             loanHash: 0,
4943             signature: new bytes(0)
4944         });
4945 
4946         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4947 
4948         return loanOffering;
4949     }
4950 
4951     function parseLoanOfferRates(
4952         uint256[7] values256,
4953         uint32[4] values32
4954     )
4955         private
4956         pure
4957         returns (MarginCommon.LoanRates memory)
4958     {
4959         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4960             maxAmount: values256[0],
4961             minAmount: values256[1],
4962             minHeldToken: values256[2],
4963             interestRate: values32[2],
4964             lenderFee: values256[3],
4965             takerFee: values256[4],
4966             interestPeriod: values32[3]
4967         });
4968 
4969         return rates;
4970     }
4971 }
4972 
4973 // File: contracts/margin/impl/MarginAdmin.sol
4974 
4975 /**
4976  * @title MarginAdmin
4977  * @author dYdX
4978  *
4979  * Contains admin functions for the Margin contract
4980  * The owner can put Margin into various close-only modes, which will disallow new position creation
4981  */
4982 contract MarginAdmin is Ownable {
4983     // ============ Enums ============
4984 
4985     // All functionality enabled
4986     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4987 
4988     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4989     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4990     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4991 
4992     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4993     // forceRecoverCollateral)
4994     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4995 
4996     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4997     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4998 
4999     // This operation state (and any higher) is invalid
5000     uint8 private constant OPERATION_STATE_INVALID = 4;
5001 
5002     // ============ Events ============
5003 
5004     /**
5005      * Event indicating the operation state has changed
5006      */
5007     event OperationStateChanged(
5008         uint8 from,
5009         uint8 to
5010     );
5011 
5012     // ============ State Variables ============
5013 
5014     uint8 public operationState;
5015 
5016     // ============ Constructor ============
5017 
5018     constructor()
5019         public
5020         Ownable()
5021     {
5022         operationState = OPERATION_STATE_OPERATIONAL;
5023     }
5024 
5025     // ============ Modifiers ============
5026 
5027     modifier onlyWhileOperational() {
5028         require(
5029             operationState == OPERATION_STATE_OPERATIONAL,
5030             "MarginAdmin#onlyWhileOperational: Can only call while operational"
5031         );
5032         _;
5033     }
5034 
5035     modifier cancelLoanOfferingStateControl() {
5036         require(
5037             operationState == OPERATION_STATE_OPERATIONAL
5038             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
5039             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
5040         );
5041         _;
5042     }
5043 
5044     modifier closePositionStateControl() {
5045         require(
5046             operationState == OPERATION_STATE_OPERATIONAL
5047             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
5048             || operationState == OPERATION_STATE_CLOSE_ONLY,
5049             "MarginAdmin#closePositionStateControl: Invalid operation state"
5050         );
5051         _;
5052     }
5053 
5054     modifier closePositionDirectlyStateControl() {
5055         _;
5056     }
5057 
5058     // ============ Owner-Only State-Changing Functions ============
5059 
5060     function setOperationState(
5061         uint8 newState
5062     )
5063         external
5064         onlyOwner
5065     {
5066         require(
5067             newState < OPERATION_STATE_INVALID,
5068             "MarginAdmin#setOperationState: newState is not a valid operation state"
5069         );
5070 
5071         if (newState != operationState) {
5072             emit OperationStateChanged(
5073                 operationState,
5074                 newState
5075             );
5076             operationState = newState;
5077         }
5078     }
5079 }
5080 
5081 // File: contracts/margin/impl/MarginEvents.sol
5082 
5083 /**
5084  * @title MarginEvents
5085  * @author dYdX
5086  *
5087  * Contains events for the Margin contract.
5088  *
5089  * NOTE: Any Margin function libraries that use events will need to both define the event here
5090  *       and copy the event into the library itself as libraries don't support sharing events
5091  */
5092 contract MarginEvents {
5093     // ============ Events ============
5094 
5095     /**
5096      * A position was opened
5097      */
5098     event PositionOpened(
5099         bytes32 indexed positionId,
5100         address indexed trader,
5101         address indexed lender,
5102         bytes32 loanHash,
5103         address owedToken,
5104         address heldToken,
5105         address loanFeeRecipient,
5106         uint256 principal,
5107         uint256 heldTokenFromSell,
5108         uint256 depositAmount,
5109         uint256 interestRate,
5110         uint32  callTimeLimit,
5111         uint32  maxDuration,
5112         bool    depositInHeldToken
5113     );
5114 
5115     /*
5116      * A position was increased
5117      */
5118     event PositionIncreased(
5119         bytes32 indexed positionId,
5120         address indexed trader,
5121         address indexed lender,
5122         address positionOwner,
5123         address loanOwner,
5124         bytes32 loanHash,
5125         address loanFeeRecipient,
5126         uint256 amountBorrowed,
5127         uint256 principalAdded,
5128         uint256 heldTokenFromSell,
5129         uint256 depositAmount,
5130         bool    depositInHeldToken
5131     );
5132 
5133     /**
5134      * A position was closed or partially closed
5135      */
5136     event PositionClosed(
5137         bytes32 indexed positionId,
5138         address indexed closer,
5139         address indexed payoutRecipient,
5140         uint256 closeAmount,
5141         uint256 remainingAmount,
5142         uint256 owedTokenPaidToLender,
5143         uint256 payoutAmount,
5144         uint256 buybackCostInHeldToken,
5145         bool payoutInHeldToken
5146     );
5147 
5148     /**
5149      * Collateral for a position was forcibly recovered
5150      */
5151     event CollateralForceRecovered(
5152         bytes32 indexed positionId,
5153         address indexed recipient,
5154         uint256 amount
5155     );
5156 
5157     /**
5158      * A position was margin-called
5159      */
5160     event MarginCallInitiated(
5161         bytes32 indexed positionId,
5162         address indexed lender,
5163         address indexed owner,
5164         uint256 requiredDeposit
5165     );
5166 
5167     /**
5168      * A margin call was canceled
5169      */
5170     event MarginCallCanceled(
5171         bytes32 indexed positionId,
5172         address indexed lender,
5173         address indexed owner,
5174         uint256 depositAmount
5175     );
5176 
5177     /**
5178      * A loan offering was canceled before it was used. Any amount less than the
5179      * total for the loan offering can be canceled.
5180      */
5181     event LoanOfferingCanceled(
5182         bytes32 indexed loanHash,
5183         address indexed payer,
5184         address indexed feeRecipient,
5185         uint256 cancelAmount
5186     );
5187 
5188     /**
5189      * Additional collateral for a position was posted by the owner
5190      */
5191     event AdditionalCollateralDeposited(
5192         bytes32 indexed positionId,
5193         uint256 amount,
5194         address depositor
5195     );
5196 
5197     /**
5198      * Ownership of a loan was transferred to a new address
5199      */
5200     event LoanTransferred(
5201         bytes32 indexed positionId,
5202         address indexed from,
5203         address indexed to
5204     );
5205 
5206     /**
5207      * Ownership of a position was transferred to a new address
5208      */
5209     event PositionTransferred(
5210         bytes32 indexed positionId,
5211         address indexed from,
5212         address indexed to
5213     );
5214 }
5215 
5216 // File: contracts/margin/impl/OpenPositionImpl.sol
5217 
5218 /**
5219  * @title OpenPositionImpl
5220  * @author dYdX
5221  *
5222  * This library contains the implementation for the openPosition function of Margin
5223  */
5224 library OpenPositionImpl {
5225     using SafeMath for uint256;
5226 
5227     // ============ Events ============
5228 
5229     /**
5230      * A position was opened
5231      */
5232     event PositionOpened(
5233         bytes32 indexed positionId,
5234         address indexed trader,
5235         address indexed lender,
5236         bytes32 loanHash,
5237         address owedToken,
5238         address heldToken,
5239         address loanFeeRecipient,
5240         uint256 principal,
5241         uint256 heldTokenFromSell,
5242         uint256 depositAmount,
5243         uint256 interestRate,
5244         uint32  callTimeLimit,
5245         uint32  maxDuration,
5246         bool    depositInHeldToken
5247     );
5248 
5249     // ============ Public Implementation Functions ============
5250 
5251     function openPositionImpl(
5252         MarginState.State storage state,
5253         address[11] addresses,
5254         uint256[10] values256,
5255         uint32[4] values32,
5256         bool depositInHeldToken,
5257         bytes signature,
5258         bytes orderData
5259     )
5260         public
5261         returns (bytes32)
5262     {
5263         BorrowShared.Tx memory transaction = parseOpenTx(
5264             addresses,
5265             values256,
5266             values32,
5267             depositInHeldToken,
5268             signature
5269         );
5270 
5271         require(
5272             !MarginCommon.positionHasExisted(state, transaction.positionId),
5273             "OpenPositionImpl#openPositionImpl: positionId already exists"
5274         );
5275 
5276         doBorrowAndSell(state, transaction, orderData);
5277 
5278         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5279         recordPositionOpened(
5280             transaction
5281         );
5282 
5283         doStoreNewPosition(
5284             state,
5285             transaction
5286         );
5287 
5288         return transaction.positionId;
5289     }
5290 
5291     // ============ Private Helper-Functions ============
5292 
5293     function doBorrowAndSell(
5294         MarginState.State storage state,
5295         BorrowShared.Tx memory transaction,
5296         bytes orderData
5297     )
5298         private
5299     {
5300         BorrowShared.validateTxPreSell(state, transaction);
5301 
5302         if (transaction.depositInHeldToken) {
5303             BorrowShared.doDepositHeldToken(state, transaction);
5304         } else {
5305             BorrowShared.doDepositOwedToken(state, transaction);
5306         }
5307 
5308         transaction.heldTokenFromSell = BorrowShared.doSell(
5309             state,
5310             transaction,
5311             orderData,
5312             MathHelpers.maxUint256()
5313         );
5314 
5315         BorrowShared.doPostSell(state, transaction);
5316     }
5317 
5318     function doStoreNewPosition(
5319         MarginState.State storage state,
5320         BorrowShared.Tx memory transaction
5321     )
5322         private
5323     {
5324         MarginCommon.storeNewPosition(
5325             state,
5326             transaction.positionId,
5327             MarginCommon.Position({
5328                 owedToken: transaction.loanOffering.owedToken,
5329                 heldToken: transaction.loanOffering.heldToken,
5330                 lender: transaction.loanOffering.owner,
5331                 owner: transaction.owner,
5332                 principal: transaction.principal,
5333                 requiredDeposit: 0,
5334                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5335                 startTimestamp: 0,
5336                 callTimestamp: 0,
5337                 maxDuration: transaction.loanOffering.maxDuration,
5338                 interestRate: transaction.loanOffering.rates.interestRate,
5339                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5340             }),
5341             transaction.loanOffering.payer
5342         );
5343     }
5344 
5345     function recordPositionOpened(
5346         BorrowShared.Tx transaction
5347     )
5348         private
5349     {
5350         emit PositionOpened(
5351             transaction.positionId,
5352             msg.sender,
5353             transaction.loanOffering.payer,
5354             transaction.loanOffering.loanHash,
5355             transaction.loanOffering.owedToken,
5356             transaction.loanOffering.heldToken,
5357             transaction.loanOffering.feeRecipient,
5358             transaction.principal,
5359             transaction.heldTokenFromSell,
5360             transaction.depositAmount,
5361             transaction.loanOffering.rates.interestRate,
5362             transaction.loanOffering.callTimeLimit,
5363             transaction.loanOffering.maxDuration,
5364             transaction.depositInHeldToken
5365         );
5366     }
5367 
5368     // ============ Parsing Functions ============
5369 
5370     function parseOpenTx(
5371         address[11] addresses,
5372         uint256[10] values256,
5373         uint32[4] values32,
5374         bool depositInHeldToken,
5375         bytes signature
5376     )
5377         private
5378         view
5379         returns (BorrowShared.Tx memory)
5380     {
5381         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5382             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5383             owner: addresses[0],
5384             principal: values256[7],
5385             lenderAmount: values256[7],
5386             loanOffering: parseLoanOffering(
5387                 addresses,
5388                 values256,
5389                 values32,
5390                 signature
5391             ),
5392             exchangeWrapper: addresses[10],
5393             depositInHeldToken: depositInHeldToken,
5394             depositAmount: values256[8],
5395             collateralAmount: 0, // set later
5396             heldTokenFromSell: 0 // set later
5397         });
5398 
5399         return transaction;
5400     }
5401 
5402     function parseLoanOffering(
5403         address[11] addresses,
5404         uint256[10] values256,
5405         uint32[4]   values32,
5406         bytes       signature
5407     )
5408         private
5409         view
5410         returns (MarginCommon.LoanOffering memory)
5411     {
5412         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5413             owedToken: addresses[1],
5414             heldToken: addresses[2],
5415             payer: addresses[3],
5416             owner: addresses[4],
5417             taker: addresses[5],
5418             positionOwner: addresses[6],
5419             feeRecipient: addresses[7],
5420             lenderFeeToken: addresses[8],
5421             takerFeeToken: addresses[9],
5422             rates: parseLoanOfferRates(values256, values32),
5423             expirationTimestamp: values256[5],
5424             callTimeLimit: values32[0],
5425             maxDuration: values32[1],
5426             salt: values256[6],
5427             loanHash: 0,
5428             signature: signature
5429         });
5430 
5431         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5432 
5433         return loanOffering;
5434     }
5435 
5436     function parseLoanOfferRates(
5437         uint256[10] values256,
5438         uint32[4] values32
5439     )
5440         private
5441         pure
5442         returns (MarginCommon.LoanRates memory)
5443     {
5444         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5445             maxAmount: values256[0],
5446             minAmount: values256[1],
5447             minHeldToken: values256[2],
5448             lenderFee: values256[3],
5449             takerFee: values256[4],
5450             interestRate: values32[2],
5451             interestPeriod: values32[3]
5452         });
5453 
5454         return rates;
5455     }
5456 }
5457 
5458 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5459 
5460 /**
5461  * @title OpenWithoutCounterpartyImpl
5462  * @author dYdX
5463  *
5464  * This library contains the implementation for the openWithoutCounterparty
5465  * function of Margin
5466  */
5467 library OpenWithoutCounterpartyImpl {
5468 
5469     // ============ Structs ============
5470 
5471     struct Tx {
5472         bytes32 positionId;
5473         address positionOwner;
5474         address owedToken;
5475         address heldToken;
5476         address loanOwner;
5477         uint256 principal;
5478         uint256 deposit;
5479         uint32 callTimeLimit;
5480         uint32 maxDuration;
5481         uint32 interestRate;
5482         uint32 interestPeriod;
5483     }
5484 
5485     // ============ Events ============
5486 
5487     /**
5488      * A position was opened
5489      */
5490     event PositionOpened(
5491         bytes32 indexed positionId,
5492         address indexed trader,
5493         address indexed lender,
5494         bytes32 loanHash,
5495         address owedToken,
5496         address heldToken,
5497         address loanFeeRecipient,
5498         uint256 principal,
5499         uint256 heldTokenFromSell,
5500         uint256 depositAmount,
5501         uint256 interestRate,
5502         uint32  callTimeLimit,
5503         uint32  maxDuration,
5504         bool    depositInHeldToken
5505     );
5506 
5507     // ============ Public Implementation Functions ============
5508 
5509     function openWithoutCounterpartyImpl(
5510         MarginState.State storage state,
5511         address[4] addresses,
5512         uint256[3] values256,
5513         uint32[4]  values32
5514     )
5515         public
5516         returns (bytes32)
5517     {
5518         Tx memory openTx = parseTx(
5519             addresses,
5520             values256,
5521             values32
5522         );
5523 
5524         validate(
5525             state,
5526             openTx
5527         );
5528 
5529         Vault(state.VAULT).transferToVault(
5530             openTx.positionId,
5531             openTx.heldToken,
5532             msg.sender,
5533             openTx.deposit
5534         );
5535 
5536         recordPositionOpened(
5537             openTx
5538         );
5539 
5540         doStoreNewPosition(
5541             state,
5542             openTx
5543         );
5544 
5545         return openTx.positionId;
5546     }
5547 
5548     // ============ Private Helper-Functions ============
5549 
5550     function doStoreNewPosition(
5551         MarginState.State storage state,
5552         Tx memory openTx
5553     )
5554         private
5555     {
5556         MarginCommon.storeNewPosition(
5557             state,
5558             openTx.positionId,
5559             MarginCommon.Position({
5560                 owedToken: openTx.owedToken,
5561                 heldToken: openTx.heldToken,
5562                 lender: openTx.loanOwner,
5563                 owner: openTx.positionOwner,
5564                 principal: openTx.principal,
5565                 requiredDeposit: 0,
5566                 callTimeLimit: openTx.callTimeLimit,
5567                 startTimestamp: 0,
5568                 callTimestamp: 0,
5569                 maxDuration: openTx.maxDuration,
5570                 interestRate: openTx.interestRate,
5571                 interestPeriod: openTx.interestPeriod
5572             }),
5573             msg.sender
5574         );
5575     }
5576 
5577     function validate(
5578         MarginState.State storage state,
5579         Tx memory openTx
5580     )
5581         private
5582         view
5583     {
5584         require(
5585             !MarginCommon.positionHasExisted(state, openTx.positionId),
5586             "openWithoutCounterpartyImpl#validate: positionId already exists"
5587         );
5588 
5589         require(
5590             openTx.principal > 0,
5591             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5592         );
5593 
5594         require(
5595             openTx.owedToken != address(0),
5596             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5597         );
5598 
5599         require(
5600             openTx.owedToken != openTx.heldToken,
5601             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5602         );
5603 
5604         require(
5605             openTx.positionOwner != address(0),
5606             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5607         );
5608 
5609         require(
5610             openTx.loanOwner != address(0),
5611             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5612         );
5613 
5614         require(
5615             openTx.maxDuration > 0,
5616             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5617         );
5618 
5619         require(
5620             openTx.interestPeriod <= openTx.maxDuration,
5621             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5622         );
5623     }
5624 
5625     function recordPositionOpened(
5626         Tx memory openTx
5627     )
5628         private
5629     {
5630         emit PositionOpened(
5631             openTx.positionId,
5632             msg.sender,
5633             msg.sender,
5634             bytes32(0),
5635             openTx.owedToken,
5636             openTx.heldToken,
5637             address(0),
5638             openTx.principal,
5639             0,
5640             openTx.deposit,
5641             openTx.interestRate,
5642             openTx.callTimeLimit,
5643             openTx.maxDuration,
5644             true
5645         );
5646     }
5647 
5648     // ============ Parsing Functions ============
5649 
5650     function parseTx(
5651         address[4] addresses,
5652         uint256[3] values256,
5653         uint32[4]  values32
5654     )
5655         private
5656         view
5657         returns (Tx memory)
5658     {
5659         Tx memory openTx = Tx({
5660             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5661             positionOwner: addresses[0],
5662             owedToken: addresses[1],
5663             heldToken: addresses[2],
5664             loanOwner: addresses[3],
5665             principal: values256[0],
5666             deposit: values256[1],
5667             callTimeLimit: values32[0],
5668             maxDuration: values32[1],
5669             interestRate: values32[2],
5670             interestPeriod: values32[3]
5671         });
5672 
5673         return openTx;
5674     }
5675 }
5676 
5677 // File: contracts/margin/impl/PositionGetters.sol
5678 
5679 /**
5680  * @title PositionGetters
5681  * @author dYdX
5682  *
5683  * A collection of public constant getter functions that allows reading of the state of any position
5684  * stored in the dYdX protocol.
5685  */
5686 contract PositionGetters is MarginStorage {
5687     using SafeMath for uint256;
5688 
5689     // ============ Public Constant Functions ============
5690 
5691     /**
5692      * Gets if a position is currently open.
5693      *
5694      * @param  positionId  Unique ID of the position
5695      * @return             True if the position is exists and is open
5696      */
5697     function containsPosition(
5698         bytes32 positionId
5699     )
5700         external
5701         view
5702         returns (bool)
5703     {
5704         return MarginCommon.containsPositionImpl(state, positionId);
5705     }
5706 
5707     /**
5708      * Gets if a position is currently margin-called.
5709      *
5710      * @param  positionId  Unique ID of the position
5711      * @return             True if the position is margin-called
5712      */
5713     function isPositionCalled(
5714         bytes32 positionId
5715     )
5716         external
5717         view
5718         returns (bool)
5719     {
5720         return (state.positions[positionId].callTimestamp > 0);
5721     }
5722 
5723     /**
5724      * Gets if a position was previously open and is now closed.
5725      *
5726      * @param  positionId  Unique ID of the position
5727      * @return             True if the position is now closed
5728      */
5729     function isPositionClosed(
5730         bytes32 positionId
5731     )
5732         external
5733         view
5734         returns (bool)
5735     {
5736         return state.closedPositions[positionId];
5737     }
5738 
5739     /**
5740      * Gets the total amount of owedToken ever repaid to the lender for a position.
5741      *
5742      * @param  positionId  Unique ID of the position
5743      * @return             Total amount of owedToken ever repaid
5744      */
5745     function getTotalOwedTokenRepaidToLender(
5746         bytes32 positionId
5747     )
5748         external
5749         view
5750         returns (uint256)
5751     {
5752         return state.totalOwedTokenRepaidToLender[positionId];
5753     }
5754 
5755     /**
5756      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5757      *
5758      * @param  positionId  Unique ID of the position
5759      * @return             The amount of heldToken
5760      */
5761     function getPositionBalance(
5762         bytes32 positionId
5763     )
5764         external
5765         view
5766         returns (uint256)
5767     {
5768         return MarginCommon.getPositionBalanceImpl(state, positionId);
5769     }
5770 
5771     /**
5772      * Gets the time until the interest fee charged for the position will increase.
5773      * Returns 1 if the interest fee increases every second.
5774      * Returns 0 if the interest fee will never increase again.
5775      *
5776      * @param  positionId  Unique ID of the position
5777      * @return             The number of seconds until the interest fee will increase
5778      */
5779     function getTimeUntilInterestIncrease(
5780         bytes32 positionId
5781     )
5782         external
5783         view
5784         returns (uint256)
5785     {
5786         MarginCommon.Position storage position =
5787             MarginCommon.getPositionFromStorage(state, positionId);
5788 
5789         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5790             position,
5791             block.timestamp
5792         );
5793 
5794         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5795         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5796             return 0;
5797         } else {
5798             // nextStep is the final second at which the calculated interest fee is the same as it
5799             // is currently, so add 1 to get the correct value
5800             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5801         }
5802     }
5803 
5804     /**
5805      * Gets the amount of owedTokens currently needed to close the position completely, including
5806      * interest fees.
5807      *
5808      * @param  positionId  Unique ID of the position
5809      * @return             The number of owedTokens
5810      */
5811     function getPositionOwedAmount(
5812         bytes32 positionId
5813     )
5814         external
5815         view
5816         returns (uint256)
5817     {
5818         MarginCommon.Position storage position =
5819             MarginCommon.getPositionFromStorage(state, positionId);
5820 
5821         return MarginCommon.calculateOwedAmount(
5822             position,
5823             position.principal,
5824             block.timestamp
5825         );
5826     }
5827 
5828     /**
5829      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5830      * given time, including interest fees.
5831      *
5832      * @param  positionId         Unique ID of the position
5833      * @param  principalToClose   Amount of principal being closed
5834      * @param  timestamp          Block timestamp in seconds of close
5835      * @return                    The number of owedTokens owed
5836      */
5837     function getPositionOwedAmountAtTime(
5838         bytes32 positionId,
5839         uint256 principalToClose,
5840         uint32  timestamp
5841     )
5842         external
5843         view
5844         returns (uint256)
5845     {
5846         MarginCommon.Position storage position =
5847             MarginCommon.getPositionFromStorage(state, positionId);
5848 
5849         require(
5850             timestamp >= position.startTimestamp,
5851             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5852         );
5853 
5854         return MarginCommon.calculateOwedAmount(
5855             position,
5856             principalToClose,
5857             timestamp
5858         );
5859     }
5860 
5861     /**
5862      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5863      * amount to the position at a given time.
5864      *
5865      * @param  positionId      Unique ID of the position
5866      * @param  principalToAdd  Amount being added to principal
5867      * @param  timestamp       Block timestamp in seconds of addition
5868      * @return                 The number of owedTokens that will be borrowed
5869      */
5870     function getLenderAmountForIncreasePositionAtTime(
5871         bytes32 positionId,
5872         uint256 principalToAdd,
5873         uint32  timestamp
5874     )
5875         external
5876         view
5877         returns (uint256)
5878     {
5879         MarginCommon.Position storage position =
5880             MarginCommon.getPositionFromStorage(state, positionId);
5881 
5882         require(
5883             timestamp >= position.startTimestamp,
5884             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5885         );
5886 
5887         return MarginCommon.calculateLenderAmountForIncreasePosition(
5888             position,
5889             principalToAdd,
5890             timestamp
5891         );
5892     }
5893 
5894     // ============ All Properties ============
5895 
5896     /**
5897      * Get a Position by id. This does not validate the position exists. If the position does not
5898      * exist, all 0's will be returned.
5899      *
5900      * @param  positionId  Unique ID of the position
5901      * @return             Addresses corresponding to:
5902      *
5903      *                     [0] = owedToken
5904      *                     [1] = heldToken
5905      *                     [2] = lender
5906      *                     [3] = owner
5907      *
5908      *                     Values corresponding to:
5909      *
5910      *                     [0] = principal
5911      *                     [1] = requiredDeposit
5912      *
5913      *                     Values corresponding to:
5914      *
5915      *                     [0] = callTimeLimit
5916      *                     [1] = startTimestamp
5917      *                     [2] = callTimestamp
5918      *                     [3] = maxDuration
5919      *                     [4] = interestRate
5920      *                     [5] = interestPeriod
5921      */
5922     function getPosition(
5923         bytes32 positionId
5924     )
5925         external
5926         view
5927         returns (
5928             address[4],
5929             uint256[2],
5930             uint32[6]
5931         )
5932     {
5933         MarginCommon.Position storage position = state.positions[positionId];
5934 
5935         return (
5936             [
5937                 position.owedToken,
5938                 position.heldToken,
5939                 position.lender,
5940                 position.owner
5941             ],
5942             [
5943                 position.principal,
5944                 position.requiredDeposit
5945             ],
5946             [
5947                 position.callTimeLimit,
5948                 position.startTimestamp,
5949                 position.callTimestamp,
5950                 position.maxDuration,
5951                 position.interestRate,
5952                 position.interestPeriod
5953             ]
5954         );
5955     }
5956 
5957     // ============ Individual Properties ============
5958 
5959     function getPositionLender(
5960         bytes32 positionId
5961     )
5962         external
5963         view
5964         returns (address)
5965     {
5966         return state.positions[positionId].lender;
5967     }
5968 
5969     function getPositionOwner(
5970         bytes32 positionId
5971     )
5972         external
5973         view
5974         returns (address)
5975     {
5976         return state.positions[positionId].owner;
5977     }
5978 
5979     function getPositionHeldToken(
5980         bytes32 positionId
5981     )
5982         external
5983         view
5984         returns (address)
5985     {
5986         return state.positions[positionId].heldToken;
5987     }
5988 
5989     function getPositionOwedToken(
5990         bytes32 positionId
5991     )
5992         external
5993         view
5994         returns (address)
5995     {
5996         return state.positions[positionId].owedToken;
5997     }
5998 
5999     function getPositionPrincipal(
6000         bytes32 positionId
6001     )
6002         external
6003         view
6004         returns (uint256)
6005     {
6006         return state.positions[positionId].principal;
6007     }
6008 
6009     function getPositionInterestRate(
6010         bytes32 positionId
6011     )
6012         external
6013         view
6014         returns (uint256)
6015     {
6016         return state.positions[positionId].interestRate;
6017     }
6018 
6019     function getPositionRequiredDeposit(
6020         bytes32 positionId
6021     )
6022         external
6023         view
6024         returns (uint256)
6025     {
6026         return state.positions[positionId].requiredDeposit;
6027     }
6028 
6029     function getPositionStartTimestamp(
6030         bytes32 positionId
6031     )
6032         external
6033         view
6034         returns (uint32)
6035     {
6036         return state.positions[positionId].startTimestamp;
6037     }
6038 
6039     function getPositionCallTimestamp(
6040         bytes32 positionId
6041     )
6042         external
6043         view
6044         returns (uint32)
6045     {
6046         return state.positions[positionId].callTimestamp;
6047     }
6048 
6049     function getPositionCallTimeLimit(
6050         bytes32 positionId
6051     )
6052         external
6053         view
6054         returns (uint32)
6055     {
6056         return state.positions[positionId].callTimeLimit;
6057     }
6058 
6059     function getPositionMaxDuration(
6060         bytes32 positionId
6061     )
6062         external
6063         view
6064         returns (uint32)
6065     {
6066         return state.positions[positionId].maxDuration;
6067     }
6068 
6069     function getPositioninterestPeriod(
6070         bytes32 positionId
6071     )
6072         external
6073         view
6074         returns (uint32)
6075     {
6076         return state.positions[positionId].interestPeriod;
6077     }
6078 }
6079 
6080 // File: contracts/margin/impl/TransferImpl.sol
6081 
6082 /**
6083  * @title TransferImpl
6084  * @author dYdX
6085  *
6086  * This library contains the implementation for the transferPosition and transferLoan functions of
6087  * Margin
6088  */
6089 library TransferImpl {
6090 
6091     // ============ Public Implementation Functions ============
6092 
6093     function transferLoanImpl(
6094         MarginState.State storage state,
6095         bytes32 positionId,
6096         address newLender
6097     )
6098         public
6099     {
6100         require(
6101             MarginCommon.containsPositionImpl(state, positionId),
6102             "TransferImpl#transferLoanImpl: Position does not exist"
6103         );
6104 
6105         address originalLender = state.positions[positionId].lender;
6106 
6107         require(
6108             msg.sender == originalLender,
6109             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
6110         );
6111         require(
6112             newLender != originalLender,
6113             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
6114         );
6115 
6116         // Doesn't change the state of positionId; figures out the final owner of loan.
6117         // That is, newLender may pass ownership to a different address.
6118         address finalLender = TransferInternal.grantLoanOwnership(
6119             positionId,
6120             originalLender,
6121             newLender);
6122 
6123         require(
6124             finalLender != originalLender,
6125             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
6126         );
6127 
6128         // Set state only after resolving the new owner (to reduce the number of storage calls)
6129         state.positions[positionId].lender = finalLender;
6130     }
6131 
6132     function transferPositionImpl(
6133         MarginState.State storage state,
6134         bytes32 positionId,
6135         address newOwner
6136     )
6137         public
6138     {
6139         require(
6140             MarginCommon.containsPositionImpl(state, positionId),
6141             "TransferImpl#transferPositionImpl: Position does not exist"
6142         );
6143 
6144         address originalOwner = state.positions[positionId].owner;
6145 
6146         require(
6147             msg.sender == originalOwner,
6148             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
6149         );
6150         require(
6151             newOwner != originalOwner,
6152             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
6153         );
6154 
6155         // Doesn't change the state of positionId; figures out the final owner of position.
6156         // That is, newOwner may pass ownership to a different address.
6157         address finalOwner = TransferInternal.grantPositionOwnership(
6158             positionId,
6159             originalOwner,
6160             newOwner);
6161 
6162         require(
6163             finalOwner != originalOwner,
6164             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
6165         );
6166 
6167         // Set state only after resolving the new owner (to reduce the number of storage calls)
6168         state.positions[positionId].owner = finalOwner;
6169     }
6170 }
6171 
6172 // File: contracts/margin/Margin.sol
6173 
6174 /**
6175  * @title Margin
6176  * @author dYdX
6177  *
6178  * This contract is used to facilitate margin trading as per the dYdX protocol
6179  */
6180 contract Margin is
6181     ReentrancyGuard,
6182     MarginStorage,
6183     MarginEvents,
6184     MarginAdmin,
6185     LoanGetters,
6186     PositionGetters
6187 {
6188 
6189     using SafeMath for uint256;
6190 
6191     // ============ Constructor ============
6192 
6193     constructor(
6194         address vault,
6195         address proxy
6196     )
6197         public
6198         MarginAdmin()
6199     {
6200         state = MarginState.State({
6201             VAULT: vault,
6202             TOKEN_PROXY: proxy
6203         });
6204     }
6205 
6206     // ============ Public State Changing Functions ============
6207 
6208     /**
6209      * Open a margin position. Called by the margin trader who must provide both a
6210      * signed loan offering as well as a DEX Order with which to sell the owedToken.
6211      *
6212      * @param  addresses           Addresses corresponding to:
6213      *
6214      *  [0]  = position owner
6215      *  [1]  = owedToken
6216      *  [2]  = heldToken
6217      *  [3]  = loan payer
6218      *  [4]  = loan owner
6219      *  [5]  = loan taker
6220      *  [6]  = loan position owner
6221      *  [7]  = loan fee recipient
6222      *  [8]  = loan lender fee token
6223      *  [9]  = loan taker fee token
6224      *  [10]  = exchange wrapper address
6225      *
6226      * @param  values256           Values corresponding to:
6227      *
6228      *  [0]  = loan maximum amount
6229      *  [1]  = loan minimum amount
6230      *  [2]  = loan minimum heldToken
6231      *  [3]  = loan lender fee
6232      *  [4]  = loan taker fee
6233      *  [5]  = loan expiration timestamp (in seconds)
6234      *  [6]  = loan salt
6235      *  [7]  = position amount of principal
6236      *  [8]  = deposit amount
6237      *  [9]  = nonce (used to calculate positionId)
6238      *
6239      * @param  values32            Values corresponding to:
6240      *
6241      *  [0] = loan call time limit (in seconds)
6242      *  [1] = loan maxDuration (in seconds)
6243      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6244      *  [3] = loan interest update period (in seconds)
6245      *
6246      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6247      *                             False if the margin deposit will be in owedToken
6248      *                             and then sold along with the owedToken borrowed from the lender
6249      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6250      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6251      *                             is a smart contract, these are arbitrary bytes that the contract
6252      *                             will recieve when choosing whether to approve the loan.
6253      * @param  order               Order object to be passed to the exchange wrapper
6254      * @return                     Unique ID for the new position
6255      */
6256     function openPosition(
6257         address[11] addresses,
6258         uint256[10] values256,
6259         uint32[4]   values32,
6260         bool        depositInHeldToken,
6261         bytes       signature,
6262         bytes       order
6263     )
6264         external
6265         onlyWhileOperational
6266         nonReentrant
6267         returns (bytes32)
6268     {
6269         return OpenPositionImpl.openPositionImpl(
6270             state,
6271             addresses,
6272             values256,
6273             values32,
6274             depositInHeldToken,
6275             signature,
6276             order
6277         );
6278     }
6279 
6280     /**
6281      * Open a margin position without a counterparty. The caller will serve as both the
6282      * lender and the position owner
6283      *
6284      * @param  addresses    Addresses corresponding to:
6285      *
6286      *  [0]  = position owner
6287      *  [1]  = owedToken
6288      *  [2]  = heldToken
6289      *  [3]  = loan owner
6290      *
6291      * @param  values256    Values corresponding to:
6292      *
6293      *  [0]  = principal
6294      *  [1]  = deposit amount
6295      *  [2]  = nonce (used to calculate positionId)
6296      *
6297      * @param  values32     Values corresponding to:
6298      *
6299      *  [0] = call time limit (in seconds)
6300      *  [1] = maxDuration (in seconds)
6301      *  [2] = interest rate (annual nominal percentage times 10**6)
6302      *  [3] = interest update period (in seconds)
6303      *
6304      * @return              Unique ID for the new position
6305      */
6306     function openWithoutCounterparty(
6307         address[4] addresses,
6308         uint256[3] values256,
6309         uint32[4]  values32
6310     )
6311         external
6312         onlyWhileOperational
6313         nonReentrant
6314         returns (bytes32)
6315     {
6316         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6317             state,
6318             addresses,
6319             values256,
6320             values32
6321         );
6322     }
6323 
6324     /**
6325      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6326      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6327      * principal added, as it will incorporate interest already earned by the position so far.
6328      *
6329      * @param  positionId          Unique ID of the position
6330      * @param  addresses           Addresses corresponding to:
6331      *
6332      *  [0]  = loan payer
6333      *  [1]  = loan taker
6334      *  [2]  = loan position owner
6335      *  [3]  = loan fee recipient
6336      *  [4]  = loan lender fee token
6337      *  [5]  = loan taker fee token
6338      *  [6]  = exchange wrapper address
6339      *
6340      * @param  values256           Values corresponding to:
6341      *
6342      *  [0]  = loan maximum amount
6343      *  [1]  = loan minimum amount
6344      *  [2]  = loan minimum heldToken
6345      *  [3]  = loan lender fee
6346      *  [4]  = loan taker fee
6347      *  [5]  = loan expiration timestamp (in seconds)
6348      *  [6]  = loan salt
6349      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6350      *                                                           will be >= this amount)
6351      *
6352      * @param  values32            Values corresponding to:
6353      *
6354      *  [0] = loan call time limit (in seconds)
6355      *  [1] = loan maxDuration (in seconds)
6356      *
6357      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6358      *                             False if the margin deposit will be pulled in owedToken
6359      *                             and then sold along with the owedToken borrowed from the lender
6360      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6361      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6362      *                             is a smart contract, these are arbitrary bytes that the contract
6363      *                             will recieve when choosing whether to approve the loan.
6364      * @param  order               Order object to be passed to the exchange wrapper
6365      * @return                     Amount of owedTokens pulled from the lender
6366      */
6367     function increasePosition(
6368         bytes32    positionId,
6369         address[7] addresses,
6370         uint256[8] values256,
6371         uint32[2]  values32,
6372         bool       depositInHeldToken,
6373         bytes      signature,
6374         bytes      order
6375     )
6376         external
6377         onlyWhileOperational
6378         nonReentrant
6379         returns (uint256)
6380     {
6381         return IncreasePositionImpl.increasePositionImpl(
6382             state,
6383             positionId,
6384             addresses,
6385             values256,
6386             values32,
6387             depositInHeldToken,
6388             signature,
6389             order
6390         );
6391     }
6392 
6393     /**
6394      * Increase a position directly by putting up heldToken. The caller will serve as both the
6395      * lender and the position owner
6396      *
6397      * @param  positionId      Unique ID of the position
6398      * @param  principalToAdd  Principal amount to add to the position
6399      * @return                 Amount of heldToken pulled from the msg.sender
6400      */
6401     function increaseWithoutCounterparty(
6402         bytes32 positionId,
6403         uint256 principalToAdd
6404     )
6405         external
6406         onlyWhileOperational
6407         nonReentrant
6408         returns (uint256)
6409     {
6410         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6411             state,
6412             positionId,
6413             principalToAdd
6414         );
6415     }
6416 
6417     /**
6418      * Close a position. May be called by the owner or with the approval of the owner. May provide
6419      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6420      * is sent the resulting payout.
6421      *
6422      * @param  positionId            Unique ID of the position
6423      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6424      *                               closed is also bounded by:
6425      *                               1) The principal of the position
6426      *                               2) The amount allowed by the owner if closer != owner
6427      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6428      * @param  exchangeWrapper       Address of the exchange wrapper
6429      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6430      *                               False to pay out the payoutRecipient in owedToken
6431      * @param  order                 Order object to be passed to the exchange wrapper
6432      * @return                       Values corresponding to:
6433      *                               1) Principal of position closed
6434      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6435      *                                  owedToken otherwise) received by the payoutRecipient
6436      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6437      */
6438     function closePosition(
6439         bytes32 positionId,
6440         uint256 requestedCloseAmount,
6441         address payoutRecipient,
6442         address exchangeWrapper,
6443         bool    payoutInHeldToken,
6444         bytes   order
6445     )
6446         external
6447         closePositionStateControl
6448         nonReentrant
6449         returns (uint256, uint256, uint256)
6450     {
6451         return ClosePositionImpl.closePositionImpl(
6452             state,
6453             positionId,
6454             requestedCloseAmount,
6455             payoutRecipient,
6456             exchangeWrapper,
6457             payoutInHeldToken,
6458             order
6459         );
6460     }
6461 
6462     /**
6463      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6464      *
6465      * @param  positionId            Unique ID of the position
6466      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6467      *                               closed is also bounded by:
6468      *                               1) The principal of the position
6469      *                               2) The amount allowed by the owner if closer != owner
6470      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6471      * @return                       Values corresponding to:
6472      *                               1) Principal amount of position closed
6473      *                               2) Amount of heldToken received by the payoutRecipient
6474      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6475      */
6476     function closePositionDirectly(
6477         bytes32 positionId,
6478         uint256 requestedCloseAmount,
6479         address payoutRecipient
6480     )
6481         external
6482         closePositionDirectlyStateControl
6483         nonReentrant
6484         returns (uint256, uint256, uint256)
6485     {
6486         return ClosePositionImpl.closePositionImpl(
6487             state,
6488             positionId,
6489             requestedCloseAmount,
6490             payoutRecipient,
6491             address(0),
6492             true,
6493             new bytes(0)
6494         );
6495     }
6496 
6497     /**
6498      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6499      * Must be approved by both the position owner and lender.
6500      *
6501      * @param  positionId            Unique ID of the position
6502      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6503      *                               closed is also bounded by:
6504      *                               1) The principal of the position
6505      *                               2) The amount allowed by the owner if closer != owner
6506      *                               3) The amount allowed by the lender if closer != lender
6507      * @return                       Values corresponding to:
6508      *                               1) Principal amount of position closed
6509      *                               2) Amount of heldToken received by the msg.sender
6510      */
6511     function closeWithoutCounterparty(
6512         bytes32 positionId,
6513         uint256 requestedCloseAmount,
6514         address payoutRecipient
6515     )
6516         external
6517         closePositionStateControl
6518         nonReentrant
6519         returns (uint256, uint256)
6520     {
6521         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6522             state,
6523             positionId,
6524             requestedCloseAmount,
6525             payoutRecipient
6526         );
6527     }
6528 
6529     /**
6530      * Margin-call a position. Only callable with the approval of the position lender. After the
6531      * call, the position owner will have time equal to the callTimeLimit of the position to close
6532      * the position. If the owner does not close the position, the lender can recover the collateral
6533      * in the position.
6534      *
6535      * @param  positionId       Unique ID of the position
6536      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6537      *                          the margin-call. Passing in 0 means the margin call cannot be
6538      *                          canceled by depositing
6539      */
6540     function marginCall(
6541         bytes32 positionId,
6542         uint256 requiredDeposit
6543     )
6544         external
6545         nonReentrant
6546     {
6547         LoanImpl.marginCallImpl(
6548             state,
6549             positionId,
6550             requiredDeposit
6551         );
6552     }
6553 
6554     /**
6555      * Cancel a margin-call. Only callable with the approval of the position lender.
6556      *
6557      * @param  positionId  Unique ID of the position
6558      */
6559     function cancelMarginCall(
6560         bytes32 positionId
6561     )
6562         external
6563         onlyWhileOperational
6564         nonReentrant
6565     {
6566         LoanImpl.cancelMarginCallImpl(state, positionId);
6567     }
6568 
6569     /**
6570      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6571      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6572      * but remains unclosed. Only callable with the approval of the position lender.
6573      *
6574      * @param  positionId  Unique ID of the position
6575      * @param  recipient   Address to send the recovered tokens to
6576      * @return             Amount of heldToken recovered
6577      */
6578     function forceRecoverCollateral(
6579         bytes32 positionId,
6580         address recipient
6581     )
6582         external
6583         nonReentrant
6584         returns (uint256)
6585     {
6586         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6587             state,
6588             positionId,
6589             recipient
6590         );
6591     }
6592 
6593     /**
6594      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6595      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6596      *
6597      * @param  positionId       Unique ID of the position
6598      * @param  depositAmount    Additional amount in heldToken to deposit
6599      */
6600     function depositCollateral(
6601         bytes32 positionId,
6602         uint256 depositAmount
6603     )
6604         external
6605         onlyWhileOperational
6606         nonReentrant
6607     {
6608         DepositCollateralImpl.depositCollateralImpl(
6609             state,
6610             positionId,
6611             depositAmount
6612         );
6613     }
6614 
6615     /**
6616      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6617      *
6618      * @param  addresses     Array of addresses:
6619      *
6620      *  [0] = owedToken
6621      *  [1] = heldToken
6622      *  [2] = loan payer
6623      *  [3] = loan owner
6624      *  [4] = loan taker
6625      *  [5] = loan position owner
6626      *  [6] = loan fee recipient
6627      *  [7] = loan lender fee token
6628      *  [8] = loan taker fee token
6629      *
6630      * @param  values256     Values corresponding to:
6631      *
6632      *  [0] = loan maximum amount
6633      *  [1] = loan minimum amount
6634      *  [2] = loan minimum heldToken
6635      *  [3] = loan lender fee
6636      *  [4] = loan taker fee
6637      *  [5] = loan expiration timestamp (in seconds)
6638      *  [6] = loan salt
6639      *
6640      * @param  values32      Values corresponding to:
6641      *
6642      *  [0] = loan call time limit (in seconds)
6643      *  [1] = loan maxDuration (in seconds)
6644      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6645      *  [3] = loan interest update period (in seconds)
6646      *
6647      * @param  cancelAmount  Amount to cancel
6648      * @return               Amount that was canceled
6649      */
6650     function cancelLoanOffering(
6651         address[9] addresses,
6652         uint256[7]  values256,
6653         uint32[4]   values32,
6654         uint256     cancelAmount
6655     )
6656         external
6657         cancelLoanOfferingStateControl
6658         nonReentrant
6659         returns (uint256)
6660     {
6661         return LoanImpl.cancelLoanOfferingImpl(
6662             state,
6663             addresses,
6664             values256,
6665             values32,
6666             cancelAmount
6667         );
6668     }
6669 
6670     /**
6671      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6672      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6673      * must implement the LoanOwner interface.
6674      *
6675      * @param  positionId  Unique ID of the position
6676      * @param  who         New owner of the loan
6677      */
6678     function transferLoan(
6679         bytes32 positionId,
6680         address who
6681     )
6682         external
6683         nonReentrant
6684     {
6685         TransferImpl.transferLoanImpl(
6686             state,
6687             positionId,
6688             who);
6689     }
6690 
6691     /**
6692      * Transfer ownership of a position to a new address. This new address will be entitled to all
6693      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6694      * the PositionOwner interface.
6695      *
6696      * @param  positionId  Unique ID of the position
6697      * @param  who         New owner of the position
6698      */
6699     function transferPosition(
6700         bytes32 positionId,
6701         address who
6702     )
6703         external
6704         nonReentrant
6705     {
6706         TransferImpl.transferPositionImpl(
6707             state,
6708             positionId,
6709             who);
6710     }
6711 
6712     // ============ Public Constant Functions ============
6713 
6714     /**
6715      * Gets the address of the Vault contract that holds and accounts for tokens.
6716      *
6717      * @return  The address of the Vault contract
6718      */
6719     function getVaultAddress()
6720         external
6721         view
6722         returns (address)
6723     {
6724         return state.VAULT;
6725     }
6726 
6727     /**
6728      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6729      * make loans or open/close positions.
6730      *
6731      * @return  The address of the TokenProxy contract
6732      */
6733     function getTokenProxyAddress()
6734         external
6735         view
6736         returns (address)
6737     {
6738         return state.TOKEN_PROXY;
6739     }
6740 }
6741 
6742 // File: contracts/margin/interfaces/OnlyMargin.sol
6743 
6744 /**
6745  * @title OnlyMargin
6746  * @author dYdX
6747  *
6748  * Contract to store the address of the main Margin contract and trust only that address to call
6749  * certain functions.
6750  */
6751 contract OnlyMargin {
6752 
6753     // ============ Constants ============
6754 
6755     // Address of the known and trusted Margin contract on the blockchain
6756     address public DYDX_MARGIN;
6757 
6758     // ============ Constructor ============
6759 
6760     constructor(
6761         address margin
6762     )
6763         public
6764     {
6765         DYDX_MARGIN = margin;
6766     }
6767 
6768     // ============ Modifiers ============
6769 
6770     modifier onlyMargin()
6771     {
6772         require(
6773             msg.sender == DYDX_MARGIN,
6774             "OnlyMargin#onlyMargin: Only Margin can call"
6775         );
6776 
6777         _;
6778     }
6779 }
6780 
6781 // File: contracts/margin/external/interfaces/PositionCustodian.sol
6782 
6783 /**
6784  * @title PositionCustodian
6785  * @author dYdX
6786  *
6787  * Interface to interact with other second-layer contracts. For contracts that own positions as a
6788  * proxy for other addresses.
6789  */
6790 interface PositionCustodian {
6791 
6792     /**
6793      * Function that is intended to be called by external contracts to see where to pay any fees or
6794      * tokens as a result of closing a position on behalf of another contract.
6795      *
6796      * @param  positionId   Unique ID of the position
6797      * @return              Address of the true owner of the position
6798      */
6799     function getPositionDeedHolder(
6800         bytes32 positionId
6801     )
6802         external
6803         view
6804         returns (address);
6805 }
6806 
6807 // File: contracts/margin/external/lib/MarginHelper.sol
6808 
6809 /**
6810  * @title MarginHelper
6811  * @author dYdX
6812  *
6813  * This library contains helper functions for interacting with Margin
6814  */
6815 library MarginHelper {
6816     function getPosition(
6817         address DYDX_MARGIN,
6818         bytes32 positionId
6819     )
6820         internal
6821         view
6822         returns (MarginCommon.Position memory)
6823     {
6824         (
6825             address[4] memory addresses,
6826             uint256[2] memory values256,
6827             uint32[6]  memory values32
6828         ) = Margin(DYDX_MARGIN).getPosition(positionId);
6829 
6830         return MarginCommon.Position({
6831             owedToken: addresses[0],
6832             heldToken: addresses[1],
6833             lender: addresses[2],
6834             owner: addresses[3],
6835             principal: values256[0],
6836             requiredDeposit: values256[1],
6837             callTimeLimit: values32[0],
6838             startTimestamp: values32[1],
6839             callTimestamp: values32[2],
6840             maxDuration: values32[3],
6841             interestRate: values32[4],
6842             interestPeriod: values32[5]
6843         });
6844     }
6845 }
6846 
6847 // File: contracts/margin/external/ERC20/ERC20Position.sol
6848 
6849 /**
6850  * @title ERC20Position
6851  * @author dYdX
6852  *
6853  * Shared code for ERC20Short and ERC20Long
6854  */
6855 contract ERC20Position is
6856     ReentrancyGuard,
6857     StandardToken,
6858     OnlyMargin,
6859     PositionOwner,
6860     IncreasePositionDelegator,
6861     ClosePositionDelegator,
6862     PositionCustodian
6863 {
6864     using SafeMath for uint256;
6865 
6866     // ============ Enums ============
6867 
6868     enum State {
6869         UNINITIALIZED,
6870         OPEN,
6871         CLOSED
6872     }
6873 
6874     // ============ Events ============
6875 
6876     /**
6877      * This ERC20 was successfully initialized
6878      */
6879     event Initialized(
6880         bytes32 positionId,
6881         uint256 initialSupply
6882     );
6883 
6884     /**
6885      * The position was completely closed by a trusted third-party and tokens can be withdrawn
6886      */
6887     event ClosedByTrustedParty(
6888         address closer,
6889         uint256 tokenAmount,
6890         address payoutRecipient
6891     );
6892 
6893     /**
6894      * The position was completely closed and tokens can be withdrawn
6895      */
6896     event CompletelyClosed();
6897 
6898     /**
6899      * A user burned tokens to withdraw heldTokens from this contract after the position was closed
6900      */
6901     event Withdraw(
6902         address indexed redeemer,
6903         uint256 tokensRedeemed,
6904         uint256 heldTokenPayout
6905     );
6906 
6907     /**
6908      * A user burned tokens in order to partially close the position
6909      */
6910     event Close(
6911         address indexed redeemer,
6912         uint256 closeAmount
6913     );
6914 
6915     // ============ State Variables ============
6916 
6917     // All tokens will initially be allocated to this address
6918     address public INITIAL_TOKEN_HOLDER;
6919 
6920     // Unique ID of the position this contract is tokenizing
6921     bytes32 public POSITION_ID;
6922 
6923     // Recipients that will fairly verify and redistribute funds from closing the position
6924     mapping (address => bool) public TRUSTED_RECIPIENTS;
6925 
6926     // Withdrawers that will fairly withdraw funds after the position has been closed
6927     mapping (address => bool) public TRUSTED_WITHDRAWERS;
6928 
6929     // Current State of this contract. See State enum
6930     State public state;
6931 
6932     // Address of the position's heldToken. Cached for convenience and lower-cost withdrawals
6933     address public heldToken;
6934 
6935     // Position has been closed using a trusted recipient
6936     bool public closedUsingTrustedRecipient;
6937 
6938     // ============ Modifiers ============
6939 
6940     modifier onlyPosition(bytes32 positionId) {
6941         require(
6942             POSITION_ID == positionId,
6943             "ERC20Position#onlyPosition: Incorrect position"
6944         );
6945         _;
6946     }
6947 
6948     modifier onlyState(State specificState) {
6949         require(
6950             state == specificState,
6951             "ERC20Position#onlyState: Incorrect State"
6952         );
6953         _;
6954     }
6955 
6956     // ============ Constructor ============
6957 
6958     constructor(
6959         bytes32 positionId,
6960         address margin,
6961         address initialTokenHolder,
6962         address[] trustedRecipients,
6963         address[] trustedWithdrawers
6964     )
6965         public
6966         OnlyMargin(margin)
6967     {
6968         POSITION_ID = positionId;
6969         state = State.UNINITIALIZED;
6970         INITIAL_TOKEN_HOLDER = initialTokenHolder;
6971         closedUsingTrustedRecipient = false;
6972 
6973         uint256 i;
6974         for (i = 0; i < trustedRecipients.length; i++) {
6975             TRUSTED_RECIPIENTS[trustedRecipients[i]] = true;
6976         }
6977         for (i = 0; i < trustedWithdrawers.length; i++) {
6978             TRUSTED_WITHDRAWERS[trustedWithdrawers[i]] = true;
6979         }
6980     }
6981 
6982     // ============ Margin-Only Functions ============
6983 
6984     /**
6985      * Called by Margin when anyone transfers ownership of a position to this contract.
6986      * This function initializes the tokenization of the position given and returns this address to
6987      * indicate to Margin that it is willing to take ownership of the position.
6988      *
6989      *  param  (unused)
6990      * @param  positionId  Unique ID of the position
6991      * @return             This address on success, throw otherwise
6992      */
6993     function receivePositionOwnership(
6994         address /* from */,
6995         bytes32 positionId
6996     )
6997         external
6998         onlyMargin
6999         nonReentrant
7000         onlyState(State.UNINITIALIZED)
7001         onlyPosition(positionId)
7002         returns (address)
7003     {
7004         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
7005         assert(position.principal > 0);
7006 
7007         // set relevant constants
7008         state = State.OPEN;
7009 
7010         uint256 tokenAmount = getTokenAmountOnAdd(position.principal);
7011 
7012         totalSupply_ = tokenAmount;
7013         balances[INITIAL_TOKEN_HOLDER] = tokenAmount;
7014         heldToken = position.heldToken;
7015 
7016         // Record event
7017         emit Initialized(POSITION_ID, tokenAmount);
7018 
7019         // ERC20 Standard requires Transfer event from 0x0 when tokens are minted
7020         emit Transfer(address(0), INITIAL_TOKEN_HOLDER, tokenAmount);
7021 
7022         return address(this); // returning own address retains ownership of position
7023     }
7024 
7025     /**
7026      * Called by Margin when additional value is added onto the position this contract
7027      * owns. Tokens are minted and assigned to the address that added the value.
7028      *
7029      * @param  trader          Address that added the value to the position
7030      * @param  positionId      Unique ID of the position
7031      * @param  principalAdded  Amount that was added to the position
7032      * @return                 This address on success, throw otherwise
7033      */
7034     function increasePositionOnBehalfOf(
7035         address trader,
7036         bytes32 positionId,
7037         uint256 principalAdded
7038     )
7039         external
7040         onlyMargin
7041         nonReentrant
7042         onlyState(State.OPEN)
7043         onlyPosition(positionId)
7044         returns (address)
7045     {
7046         require(
7047             !Margin(DYDX_MARGIN).isPositionCalled(POSITION_ID),
7048             "ERC20Position#increasePositionOnBehalfOf: Position is margin-called"
7049         );
7050         require(
7051             !closedUsingTrustedRecipient,
7052             "ERC20Position#increasePositionOnBehalfOf: Position closed using trusted recipient"
7053         );
7054 
7055         uint256 tokenAmount = getTokenAmountOnAdd(principalAdded);
7056 
7057         balances[trader] = balances[trader].add(tokenAmount);
7058         totalSupply_ = totalSupply_.add(tokenAmount);
7059 
7060         // ERC20 Standard requires Transfer event from 0x0 when tokens are minted
7061         emit Transfer(address(0), trader, tokenAmount);
7062 
7063         return address(this);
7064     }
7065 
7066     /**
7067      * Called by Margin when an owner of this token is attempting to close some of the
7068      * position. Implementation is required per PositionOwner contract in order to be used by
7069      * Margin to approve closing parts of a position.
7070      *
7071      * @param  closer           Address of the caller of the close function
7072      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
7073      * @param  positionId       Unique ID of the position
7074      * @param  requestedAmount  Amount (in principal) of the position being closed
7075      * @return                  1) This address to accept, a different address to ask that contract
7076      *                          2) The maximum amount that this contract is allowing
7077      */
7078     function closeOnBehalfOf(
7079         address closer,
7080         address payoutRecipient,
7081         bytes32 positionId,
7082         uint256 requestedAmount
7083     )
7084         external
7085         onlyMargin
7086         nonReentrant
7087         onlyState(State.OPEN)
7088         onlyPosition(positionId)
7089         returns (address, uint256)
7090     {
7091         uint256 positionPrincipal = Margin(DYDX_MARGIN).getPositionPrincipal(positionId);
7092 
7093         assert(requestedAmount <= positionPrincipal);
7094 
7095         uint256 allowedAmount;
7096         if (TRUSTED_RECIPIENTS[payoutRecipient]) {
7097             allowedAmount = closeUsingTrustedRecipient(
7098                 closer,
7099                 payoutRecipient,
7100                 requestedAmount
7101             );
7102         } else {
7103             allowedAmount = close(
7104                 closer,
7105                 requestedAmount,
7106                 positionPrincipal
7107             );
7108         }
7109 
7110         assert(allowedAmount > 0);
7111         assert(allowedAmount <= requestedAmount);
7112 
7113         if (allowedAmount == positionPrincipal) {
7114             state = State.CLOSED;
7115             emit CompletelyClosed();
7116         }
7117 
7118         return (address(this), allowedAmount);
7119     }
7120 
7121     // ============ Public State Changing Functions ============
7122 
7123     /**
7124      * Withdraw heldTokens from this contract for any of the position that was closed via external
7125      * means (such as an auction-closing mechanism)
7126      *
7127      * NOTE: It is possible that this contract could be sent heldToken by external sources
7128      * other than from the Margin contract. In this case the payout for token holders
7129      * would be greater than just that from the normal payout. This is fine because
7130      * nobody has incentive to send this contract extra funds, and if they do then it's
7131      * also fine just to let the token holders have it.
7132      *
7133      * NOTE: If there are significant rounding errors, then it is possible that withdrawing later is
7134      * more advantageous. An "attack" could involve withdrawing for others before withdrawing for
7135      * yourself. Likely, rounding error will be small enough to not properly incentivize people to
7136      * carry out such an attack.
7137      *
7138      * @param  onBehalfOf  Address of the account to withdraw for
7139      * @return             The amount of heldToken withdrawn
7140      */
7141     function withdraw(
7142         address onBehalfOf
7143     )
7144         external
7145         nonReentrant
7146         returns (uint256)
7147     {
7148         setStateClosedIfClosed();
7149         require(
7150             state == State.CLOSED,
7151             "ERC20Position#withdraw: Position has not yet been closed"
7152         );
7153 
7154         if (msg.sender != onBehalfOf) {
7155             require(
7156                 TRUSTED_WITHDRAWERS[msg.sender],
7157                 "ERC20Position#withdraw: Only trusted withdrawers can withdraw on behalf of others"
7158             );
7159         }
7160 
7161         return withdrawImpl(msg.sender, onBehalfOf);
7162     }
7163 
7164     // ============ Public Constant Functions ============
7165 
7166     /**
7167      * ERC20 decimals function. Returns the same number of decimals as the position's owedToken
7168      *
7169      * @return  The number of decimal places, or revert if the baseToken has no such function.
7170      */
7171     function decimals()
7172         external
7173         view
7174         returns (uint8);
7175 
7176     /**
7177      * ERC20 symbol function.
7178      *
7179      * @return  The symbol of the Margin Token
7180      */
7181     function symbol()
7182         external
7183         view
7184         returns (string);
7185 
7186     /**
7187      * Implements PositionCustodian functionality. Called by external contracts to see where to pay
7188      * tokens as a result of closing a position on behalf of this contract
7189      *
7190      * @param  positionId  Unique ID of the position
7191      * @return             Address of this contract. Indicates funds should be sent to this contract
7192      */
7193     function getPositionDeedHolder(
7194         bytes32 positionId
7195     )
7196         external
7197         view
7198         onlyPosition(positionId)
7199         returns (address)
7200     {
7201         // Claim ownership of deed and allow token holders to withdraw funds from this contract
7202         return address(this);
7203     }
7204 
7205     // ============ Internal Helper-Functions ============
7206 
7207     /**
7208      * Tokens are not burned when a trusted recipient is used, but we require the position to be
7209      * completely closed. All token holders are then entitled to the heldTokens in the contract
7210      */
7211     function closeUsingTrustedRecipient(
7212         address closer,
7213         address payoutRecipient,
7214         uint256 requestedAmount
7215     )
7216         internal
7217         returns (uint256)
7218     {
7219         assert(requestedAmount > 0);
7220 
7221         // remember that a trusted recipient was used
7222         if (!closedUsingTrustedRecipient) {
7223             closedUsingTrustedRecipient = true;
7224         }
7225 
7226         emit ClosedByTrustedParty(closer, requestedAmount, payoutRecipient);
7227 
7228         return requestedAmount;
7229     }
7230 
7231     // ============ Private Helper-Functions ============
7232 
7233     function withdrawImpl(
7234         address receiver,
7235         address onBehalfOf
7236     )
7237         private
7238         returns (uint256)
7239     {
7240         uint256 value = balanceOf(onBehalfOf);
7241 
7242         if (value == 0) {
7243             return 0;
7244         }
7245 
7246         uint256 heldTokenBalance = TokenInteract.balanceOf(heldToken, address(this));
7247 
7248         // NOTE the payout must be calculated before decrementing the totalSupply below
7249         uint256 heldTokenPayout = MathHelpers.getPartialAmount(
7250             value,
7251             totalSupply_,
7252             heldTokenBalance
7253         );
7254 
7255         // Destroy the margin tokens
7256         delete balances[onBehalfOf];
7257         totalSupply_ = totalSupply_.sub(value);
7258 
7259         // Send the redeemer their proportion of heldToken
7260         TokenInteract.transfer(heldToken, receiver, heldTokenPayout);
7261 
7262         emit Withdraw(onBehalfOf, value, heldTokenPayout);
7263 
7264         return heldTokenPayout;
7265     }
7266 
7267     function setStateClosedIfClosed(
7268     )
7269         private
7270     {
7271         // If in OPEN state, but the position is closed, set to CLOSED state
7272         if (state == State.OPEN && Margin(DYDX_MARGIN).isPositionClosed(POSITION_ID)) {
7273             state = State.CLOSED;
7274             emit CompletelyClosed();
7275         }
7276     }
7277 
7278     function close(
7279         address closer,
7280         uint256 requestedAmount,
7281         uint256 positionPrincipal
7282     )
7283         private
7284         returns (uint256)
7285     {
7286         uint256 balance = balances[closer];
7287 
7288         (
7289             uint256 tokenAmount,
7290             uint256 allowedCloseAmount
7291         ) = getCloseAmounts(
7292             requestedAmount,
7293             balance,
7294             positionPrincipal
7295         );
7296 
7297         require(
7298             tokenAmount > 0 && allowedCloseAmount > 0,
7299             "ERC20Position#close: Cannot close 0 amount"
7300         );
7301 
7302         assert(tokenAmount <= balance);
7303         assert(allowedCloseAmount <= requestedAmount);
7304 
7305         balances[closer] = balance.sub(tokenAmount);
7306         totalSupply_ = totalSupply_.sub(tokenAmount);
7307 
7308         emit Close(closer, tokenAmount);
7309 
7310         return allowedCloseAmount;
7311     }
7312 
7313     // ============ Private Abstract Functions ============
7314 
7315     function getTokenAmountOnAdd(
7316         uint256 principalAdded
7317     )
7318         internal
7319         view
7320         returns (uint256);
7321 
7322     function getCloseAmounts(
7323         uint256 requestedCloseAmount,
7324         uint256 balance,
7325         uint256 positionPrincipal
7326     )
7327         private
7328         view
7329         returns (
7330             uint256 /* tokenAmount */,
7331             uint256 /* allowedCloseAmount */
7332         );
7333 }
7334 
7335 // File: contracts/margin/external/ERC20/ERC20PositionWithdrawer.sol
7336 
7337 /**
7338  * @title ERC20PositionWithdrawer
7339  * @author dYdX
7340  *
7341  * Proxy contract to withdraw from an ERC20Position and exchange the withdrawn tokens on a DEX
7342  */
7343 contract ERC20PositionWithdrawer is ReentrancyGuard
7344 {
7345     using TokenInteract for address;
7346 
7347     // ============ Constants ============
7348 
7349     address public WETH;
7350 
7351     // ============ Constructor ============
7352 
7353     constructor(
7354         address weth
7355     )
7356         public
7357     {
7358         WETH = weth;
7359     }
7360 
7361     // ============ Public Functions ============
7362 
7363     /**
7364      * Fallback function. Disallows ether to be sent to this contract without data except when
7365      * unwrapping WETH.
7366      */
7367     function ()
7368         external
7369         payable
7370     {
7371         require( // coverage-disable-line
7372             msg.sender == WETH,
7373             "PayableMarginMinter#fallback: Cannot recieve ETH directly unless unwrapping WETH"
7374         );
7375     }
7376 
7377     /**
7378      * After a Margin Position (that backs a ERC20 Margin Token) is closed, the remaining Margin
7379      * Token holders are able to withdraw the Margin Position's heldToken from the Margin Token
7380      * contract. This function allows a holder to atomically withdraw the token and trade it for a
7381      * different ERC20 before returning the funds to the holder.
7382      *
7383      * @param  erc20Position    The address of the ERC20Position contract to withdraw from
7384      * @param  returnedToken    The address of the token that is returned to the token holder
7385      * @param  exchangeWrapper  The address of the ExchangeWrapper
7386      * @param  orderData        Arbitrary bytes data for any information to pass to the exchange
7387      * @return                  [1] The number of tokens withdrawn
7388      *                          [2] The number of tokens returned to the user
7389      */
7390     function withdraw(
7391         address erc20Position,
7392         address returnedToken,
7393         address exchangeWrapper,
7394         bytes orderData
7395     )
7396         external
7397         nonReentrant
7398         returns (uint256, uint256)
7399     {
7400         // withdraw tokens
7401         uint256 tokensWithdrawn = ERC20Position(erc20Position).withdraw(msg.sender);
7402         if (tokensWithdrawn == 0) {
7403             return (0, 0);
7404         }
7405 
7406         // do the exchange
7407         address withdrawnToken = ERC20Position(erc20Position).heldToken();
7408         withdrawnToken.transfer(exchangeWrapper, tokensWithdrawn);
7409         uint256 tokensReturned = ExchangeWrapper(exchangeWrapper).exchange(
7410             msg.sender,
7411             address(this),
7412             returnedToken,
7413             withdrawnToken,
7414             tokensWithdrawn,
7415             orderData
7416         );
7417 
7418         // return returnedToken back to msg.sender
7419         if (returnedToken == WETH) {
7420             // take the WETH back, withdraw into ETH, and send to the msg.sender
7421             returnedToken.transferFrom(exchangeWrapper, address(this), tokensReturned);
7422             WETH9(returnedToken).withdraw(tokensReturned);
7423             msg.sender.transfer(tokensReturned);
7424         } else {
7425             // send the tokens directly to the msg.sender
7426             returnedToken.transferFrom(exchangeWrapper, msg.sender, tokensReturned);
7427         }
7428 
7429         return (tokensWithdrawn, tokensReturned);
7430     }
7431 }