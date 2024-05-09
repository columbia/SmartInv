1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 interface IERC20 {
86   function totalSupply() external view returns (uint256);
87 
88   function balanceOf(address who) external view returns (uint256);
89 
90   function allowance(address owner, address spender)
91     external view returns (uint256);
92 
93   function transfer(address to, uint256 value) external returns (bool);
94 
95   function approve(address spender, uint256 value)
96     external returns (bool);
97 
98   function transferFrom(address from, address to, uint256 value)
99     external returns (bool);
100 
101   event Transfer(
102     address indexed from,
103     address indexed to,
104     uint256 value
105   );
106 
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
187  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract ERC20 is IERC20 {
190   using SafeMath for uint256;
191 
192   mapping (address => uint256) private _balances;
193 
194   mapping (address => mapping (address => uint256)) private _allowed;
195 
196   uint256 private _totalSupply;
197 
198   /**
199   * @dev Total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return _totalSupply;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param owner The address to query the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address owner) public view returns (uint256) {
211     return _balances[owner];
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param owner address The address which owns the funds.
217    * @param spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address owner,
222     address spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return _allowed[owner][spender];
229   }
230 
231   /**
232   * @dev Transfer token for a specified address
233   * @param to The address to transfer to.
234   * @param value The amount to be transferred.
235   */
236   function transfer(address to, uint256 value) public returns (bool) {
237     _transfer(msg.sender, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param spender The address which will spend the funds.
248    * @param value The amount of tokens to be spent.
249    */
250   function approve(address spender, uint256 value) public returns (bool) {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = value;
254     emit Approval(msg.sender, spender, value);
255     return true;
256   }
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param from address The address which you want to send tokens from
261    * @param to address The address which you want to transfer to
262    * @param value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address from,
266     address to,
267     uint256 value
268   )
269     public
270     returns (bool)
271   {
272     require(value <= _allowed[from][msg.sender]);
273 
274     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275     _transfer(from, to, value);
276     return true;
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseAllowance(
289     address spender,
290     uint256 addedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].add(addedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed_[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param spender The address which will spend the funds.
310    * @param subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseAllowance(
313     address spender,
314     uint256 subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     require(spender != address(0));
320 
321     _allowed[msg.sender][spender] = (
322       _allowed[msg.sender][spender].sub(subtractedValue));
323     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324     return true;
325   }
326 
327   /**
328   * @dev Transfer token for a specified addresses
329   * @param from The address to transfer from.
330   * @param to The address to transfer to.
331   * @param value The amount to be transferred.
332   */
333   function _transfer(address from, address to, uint256 value) internal {
334     require(value <= _balances[from]);
335     require(to != address(0));
336 
337     _balances[from] = _balances[from].sub(value);
338     _balances[to] = _balances[to].add(value);
339     emit Transfer(from, to, value);
340   }
341 
342   /**
343    * @dev Internal function that mints an amount of the token and assigns it to
344    * an account. This encapsulates the modification of balances such that the
345    * proper events are emitted.
346    * @param account The account that will receive the created tokens.
347    * @param value The amount that will be created.
348    */
349   function _mint(address account, uint256 value) internal {
350     require(account != 0);
351     _totalSupply = _totalSupply.add(value);
352     _balances[account] = _balances[account].add(value);
353     emit Transfer(address(0), account, value);
354   }
355 
356   /**
357    * @dev Internal function that burns an amount of the token of a given
358    * account.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362   function _burn(address account, uint256 value) internal {
363     require(account != 0);
364     require(value <= _balances[account]);
365 
366     _totalSupply = _totalSupply.sub(value);
367     _balances[account] = _balances[account].sub(value);
368     emit Transfer(account, address(0), value);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account, deducting from the sender's allowance for said account. Uses the
374    * internal burn function.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burnFrom(address account, uint256 value) internal {
379     require(value <= _allowed[account][msg.sender]);
380 
381     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
382     // this function needs to emit an event with the updated approval.
383     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
384       value);
385     _burn(account, value);
386   }
387 }
388 
389 // File: contracts/PartialERC20.sol
390 
391 /**
392     * @title Standard ERC20 token
393     *
394     * @dev Implementation of the basic standard token.
395     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
396     * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
397 */
398 contract PartialERC20 is ERC20 {
399     
400     using SafeMath for uint256;
401 
402     mapping (address => uint256) internal _balances;
403     mapping (address => mapping (address => uint256)) internal _allowed;
404 
405     uint256 internal _totalSupply;
406 
407     /**
408         * @dev Total number of tokens in existence
409         */
410     function totalSupply() public view returns (uint256) {
411         return _totalSupply;
412     }
413 
414     /**
415         * @dev Gets the balance of the specified address.
416         * @param owner The address to query the balance of.
417         * @return An uint256 representing the amount owned by the passed address.
418         */
419     function balanceOf(address owner) public view returns (uint256) {
420         return _balances[owner];
421     }
422 
423     /**
424         * @dev Function to check the amount of tokens that an owner allowed to a spender.
425         * @param owner address The address which owns the funds.
426         * @param spender address The address which will spend the funds.
427         * @return A uint256 specifying the amount of tokens still available for the spender.
428         */
429     function allowance(
430         address owner,
431         address spender
432     )
433         public
434         view
435         returns (uint256)
436     {
437         return _allowed[owner][spender];
438     }
439 
440     /**
441         * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
442         * Beware that changing an allowance with this method brings the risk that someone may use both the old
443         * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
444         * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
445         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
446         * @param spender The address which will spend the funds.
447         * @param value The amount of tokens to be spent.
448         */
449     function approve(address spender, uint256 value) public returns (bool) {
450         require(spender != address(0));
451 
452         _allowed[msg.sender][spender] = value;
453         emit Approval(msg.sender, spender, value);
454         return true;
455     }
456 
457     /**
458         * @dev Increase the amount of tokens that an owner allowed to a spender.
459         * approve should be called when allowed_[_spender] == 0. To increment
460         * allowed value is better to use this function to avoid 2 calls (and wait until
461         * the first transaction is mined)
462         * From MonolithDAO Token.sol
463         * @param spender The address which will spend the funds.
464         * @param addedValue The amount of tokens to increase the allowance by.
465         */
466     function increaseAllowance(
467         address spender,
468         uint256 addedValue
469     )
470         public
471         returns (bool)
472     {
473         require(spender != address(0));
474 
475         _allowed[msg.sender][spender] = (
476         _allowed[msg.sender][spender].add(addedValue));
477         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
478         return true;
479     }
480 
481     /**
482         * @dev Decrease the amount of tokens that an owner allowed to a spender.
483         * approve should be called when allowed_[_spender] == 0. To decrement
484         * allowed value is better to use this function to avoid 2 calls (and wait until
485         * the first transaction is mined)
486         * From MonolithDAO Token.sol
487         * @param spender The address which will spend the funds.
488         * @param subtractedValue The amount of tokens to decrease the allowance by.
489         */
490     function decreaseAllowance(
491         address spender,
492         uint256 subtractedValue
493     )
494         public
495         returns (bool)
496     {
497         require(spender != address(0));
498 
499         _allowed[msg.sender][spender] = (
500         _allowed[msg.sender][spender].sub(subtractedValue));
501         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
502         return true;
503     }
504 
505     /**
506         * @dev Transfer token for a specified addresses
507         * @param from The address to transfer from.
508         * @param to The address to transfer to.
509         * @param value The amount to be transferred.
510         */
511     function _transfer(address from, address to, uint256 value) internal {
512         require(to != address(0));
513 
514         _balances[from] = _balances[from].sub(value);
515         _balances[to] = _balances[to].add(value);
516         emit Transfer(from, to, value);
517     }
518 
519     /**
520         * @dev Internal function that mints an amount of the token and assigns it to
521         * an account. This encapsulates the modification of balances such that the
522         * proper events are emitted.
523         * @param account The account that will receive the created tokens.
524         * @param value The amount that will be created.
525         */
526     function _mint(address account, uint256 value) internal {
527         require(account != address(0));
528 
529         _totalSupply = _totalSupply.add(value);
530         _balances[account] = _balances[account].add(value);
531         emit Transfer(address(0), account, value);
532     }
533 
534     /**
535         * @dev Internal function that burns an amount of the token of a given
536         * account.
537         * @param account The account whose tokens will be burnt.
538         * @param value The amount that will be burnt.
539         */
540     function _burn(address account, uint256 value) internal {
541         require(account != address(0));
542 
543         _totalSupply = _totalSupply.sub(value);
544         _balances[account] = _balances[account].sub(value);
545         emit Transfer(account, address(0), value);
546     }
547 
548     /**
549         * @dev Internal function that burns an amount of the token of a given
550         * account, deducting from the sender's allowance for said account. Uses the
551         * internal burn function.
552         * @param account The account whose tokens will be burnt.
553         * @param value The amount that will be burnt.
554         */
555     function _burnFrom(address account, uint256 value) internal {
556         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
557         // this function needs to emit an event with the updated approval.
558         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
559         value);
560         _burn(account, value);
561     }
562 }
563 
564 // File: contracts/PrivateToken.sol
565 
566 /**  
567 * @title Private Token
568 * @dev This Private token used for early adoption for token holders, and have mechanism for migration to a production token.
569 * @dev Migration Flow:
570 *       Step1: call freeze()
571 *       Step2: Loop mint for all holders on a production token.
572 */  
573 
574 
575 contract PrivateToken is PartialERC20, Ownable {
576     
577     bool public isFreezed = false;
578     
579     address[] public holders;
580     mapping(address => uint32) indexOfHolders;
581 
582     event Freezed(address commander);
583     event RecordNewTokenHolder(address holder);
584     event RemoveTokenHolder(address holder);
585     
586     function numberOfTokenHolders() public view returns(uint32) {
587         return uint32(holders.length);
588     }
589 
590     function isTokenHolder(address addr) public view returns(bool) {
591         return indexOfHolders[addr] > 0;        
592     }
593 
594     modifier isNotFreezed() {
595         require(!isFreezed);
596         _;
597     }
598 
599     function freeze() public onlyOwner {
600         isFreezed = true;
601 
602         emit Freezed(msg.sender);
603     }
604 
605     function _recordNewTokenHolder(address holder) internal {
606         // Record new holder
607         if (!isTokenHolder(holder)) {
608             holders.push(holder);
609             indexOfHolders[holder] = uint32(holders.length);
610             
611             emit RecordNewTokenHolder(holder);
612         }
613     }
614 
615     function _removeTokenHolder(address holder) internal {
616         //check if holder exist
617         if (isTokenHolder(holder)) {
618 
619             // delete holder in holders
620             uint32 index = indexOfHolders[holder] - 1;
621 
622             if (holders.length > 1 && index != uint32(holders.length - 1)) {
623                 //swap two elements of the array
624                 address lastHolder = holders[holders.length - 1];
625                 holders[holders.length - 1] = holders[index];
626                 holders[index] = lastHolder;
627                 
628                 indexOfHolders[lastHolder] = indexOfHolders[holder];
629             }
630             holders.length--;
631             indexOfHolders[holder] = 0;
632             
633             emit RemoveTokenHolder(holder);
634         }
635     }
636 
637     /**
638     * @dev Transfer token for a specified address
639     * @param to The address to transfer to.
640     * @param value The amount to be transferred.
641     */
642     function transfer(address to, uint256 value) 
643         public 
644         isNotFreezed
645         returns (bool) {
646 
647         _transfer(msg.sender, to, value);
648 
649         // Record new holder
650         _recordNewTokenHolder(to);
651 
652         return true;
653     }
654 
655     /**
656         * @dev Transfer tokens from one address to another
657         * @param from address The address which you want to send tokens from
658         * @param to address The address which you want to transfer to
659         * @param value uint256 the amount of tokens to be transferred
660         */
661     function transferFrom(address from, address to, uint256 value) 
662         public 
663         isNotFreezed
664         returns (bool) {
665 
666         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
667         _transfer(from, to, value);
668         
669         // Record new holder
670         _recordNewTokenHolder(to);
671         
672         return true;
673     }
674 }
675 
676 // File: contracts/KTFForTestMigration.sol
677 
678 /**
679     * @title Standard ERC20 token
680     *
681     * @dev Implementation of the basic standard token.
682     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
683     * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
684 */
685 contract KTFForTestMigration is PartialERC20, Ownable {
686     // uint256 public totalSupply;  
687     string public name;  
688     string public symbol;  
689     uint32 public decimals; 
690 
691     PrivateToken public pktf;
692 
693     uint32 public holderCount;
694 
695     constructor(PrivateToken _pktf) public {  
696         symbol = "KTF";  
697         name = "Katinrun Foundation";  
698         decimals = 18;  
699         _totalSupply = 0;
700         
701         _balances[msg.sender] = _totalSupply;  
702 
703         pktf = _pktf;
704     }
705 
706     function migrateFromPKTF()
707         public
708         onlyOwner {
709 
710         uint32 numberOfPKTFHolders = pktf.numberOfTokenHolders();
711         holderCount = numberOfPKTFHolders;
712         
713         for(uint256 i = 0; i < numberOfPKTFHolders; i++) {
714           address user = pktf.holders(i);
715           uint256 balance = pktf.balanceOf(user);
716 
717           mint(user, balance);
718         }
719     }
720 
721     /**
722         * @dev Function to mint tokens
723         * @param to The address that will receive the minted tokens.
724         * @param value The amount of tokens to mint.
725         * @return A boolean that indicates if the operation was successful.
726         */
727     function mint(address to,uint256 value) 
728         public
729         onlyOwner
730         returns (bool)
731     {
732         _mint(to, value);
733 
734         return true;
735     }
736 }
737 
738 // File: contracts/MintableWithVoucher.sol
739 
740 contract MintableWithVoucher is PrivateToken {
741     mapping(uint64 => bool) usedVouchers;
742     mapping(bytes32 => uint32) holderRedemptionCount;
743     
744     event VoucherUsed(
745         uint64 voucherID,
746         uint64 parityCode, 
747         uint256 amount,  
748         uint256 expired,  
749         address indexed receiver, // use indexed for easy to filter event
750         bytes32 socialHash
751     );
752 
753     function isVoucherUsed(uint64 _voucherID) public view returns (bool) {
754         return usedVouchers[_voucherID];
755     }
756     
757     function markVoucherAsUsed(uint64 _voucherID) private {
758         usedVouchers[_voucherID] = true;
759     }
760 
761     function getHolderRedemptionCount(bytes32 socialHash) public view returns(uint32) {
762         return holderRedemptionCount[socialHash];
763     }
764 
765     function isVoucherExpired(uint256 expired) public view returns(bool) {
766         return expired < now;
767     }
768 
769     function expireTomorrow() public view returns (uint256) {
770         return now + 1 days;
771     }
772 
773     function expireNow() public view returns (uint256) {
774         return now;
775     }
776 
777     // Implement voucher system
778     function redeemVoucher(
779         uint8 _v, 
780         bytes32 _r, 
781         bytes32 _s,
782         uint64 _voucherID,
783         uint64 _parityCode,
784         uint256 _amount,
785         uint256 _expired,
786         address _receiver,
787         bytes32 _socialHash
788     )  
789     public 
790     isNotFreezed
791     {
792         require(!isVoucherUsed(_voucherID), "Voucher has already been used.");
793         require(!isVoucherExpired(_expired), "Voucher is expired.");
794 
795         bytes memory prefix = "\x19Ethereum Signed Message:\n80";
796         bytes memory encoded = abi.encodePacked(prefix,_voucherID, _parityCode, _amount, _expired);
797 
798         require(ecrecover(keccak256(encoded), _v, _r, _s) == owner());
799 
800         // Mint
801         _mint(_receiver, _amount);
802 
803         // Record new holder
804         _recordNewTokenHolder(_receiver);
805 
806         markVoucherAsUsed(_voucherID);
807 
808         holderRedemptionCount[_socialHash]++;
809 
810         emit VoucherUsed(_voucherID, _parityCode, _amount,  _expired, _receiver, _socialHash);
811     }
812     
813     /**
814         * @dev Function to mint tokens
815         * @param to The address that will receive the minted tokens.
816         * @param value The amount of tokens to mint.
817         * @return A boolean that indicates if the operation was successful.
818         */
819     function mint(address to,uint256 value) 
820         public
821         onlyOwner // todo: or onlyMinter
822         isNotFreezed
823         returns (bool)
824     {
825         _mint(to, value);
826 
827         // Record new holder
828         _recordNewTokenHolder(to);
829 
830         return true;
831     }
832 
833     /**
834         * @dev Burns a specific amount of tokens. Only owner can burn themself.
835         * @param value The amount of token to be burned.
836         */
837     function burn(uint256 value) 
838         public
839         onlyOwner
840         isNotFreezed {
841 
842         _burn(msg.sender, value);
843         // _removeTokenHolder(msg.sender);
844     }
845 
846     /**
847         * @dev Burns a specific amount of tokens. Only owner can burn themself.
848         * @param value The amount of token to be burned.
849         */
850     function burn(address account, uint256 value) 
851         public
852         onlyOwner
853         isNotFreezed {
854 
855         _burn(account, value);
856         // _removeTokenHolder(account);
857     }
858 
859     /**
860         * @dev Internal function that burns an amount of the token of a given
861         * account.
862         * @param account The account whose tokens will be burnt.
863         * @param value The amount that will be burnt.
864         */
865     function burnFrom(address account, uint256 value) 
866         public 
867         isNotFreezed 
868         {
869         require(account != address(0));
870 
871         _burnFrom(account, value);
872 
873         // if(balanceOf(account) == 0) {
874         //     _removeTokenHolder(account);
875         // }
876     }
877 }
878 
879 // File: contracts/PrivateKatinrunFoudation.sol
880 
881 contract PrivateKatinrunFoudation is MintableWithVoucher {
882     // uint256 public totalSupply;  
883     string public name;  
884     string public symbol;  
885     uint32 public decimals; 
886 
887     PrivateToken public pktf;
888     uint32 public holderCount;
889 
890     constructor(PrivateToken _pktf) public {  
891         symbol = "PKTF";  
892         name = "Private Katinrun Foundation";  
893         decimals = 18;  
894         _totalSupply = 0;  
895         
896         _balances[msg.sender] = _totalSupply;  
897 
898         if(_pktf != address(0)){
899             pktf = _pktf;
900             uint32 numberOfPKTFHolders = pktf.numberOfTokenHolders();
901             holderCount = numberOfPKTFHolders;
902             
903             for(uint256 i = 0; i < numberOfPKTFHolders; i++) {
904                 address user = pktf.holders(i);
905                 uint256 balance = pktf.balanceOf(user);
906 
907                 mint(user, balance);
908             }
909         }
910         
911         // emit Transfer(0x0, msg.sender, _totalSupply);  
912     }
913     
914 }