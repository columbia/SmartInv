1 pragma solidity ^0.4.24;
2 
3 
4 /*
5    ________  _____    ____  ____  _______    _   __   __________  __    ____ 
6   / ____/ / / /   |  / __ \/ __ \/  _/   |  / | / /  / ____/ __ \/ /   / __ \
7  / / __/ / / / /| | / /_/ / / / // // /| | /  |/ /  / / __/ / / / /   / / / /
8 / /_/ / /_/ / ___ |/ _, _/ /_/ // // ___ |/ /|  /  / /_/ / /_/ / /___/ /_/ / 
9 \____/\____/_/  |_/_/ |_/_____/___/_/  |_/_/ |_/   \____/\____/_____/_____/  
10 
11 
12 */
13       
14 //  Guardian Gold Token
15 //  https://guardian-gold.com
16 //  https://guardian-gold.com/exchange.html
17 //  Launch Jan 30, 2019  22:00 UTC
18 // 
19 //  Gold Backed Cryptocurrency with Proof of Stake Rewards
20 //  1 GGT = 1 Gram of Physical Gold
21 //  NO Transaction Fees
22 //  NO Gold Storage Fees
23 
24 
25 contract ERC20Basic {
26     function totalSupply() public view returns (uint256);
27     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
28     function balanceOf(address who) public view returns (uint256);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transfer(address to, uint256 value) public returns (bool);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint256 tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35     event Buy(address to, uint amount);
36     event onWithdraw(
37         address indexed customerAddress,
38         uint256 ethereumWithdrawn
39     );
40     event onGoldAccountWithdraw(
41         uint256 ethereumWithdrawn
42     );
43     event onOpAccountWithdraw(
44         uint256 ethereumWithdrawn
45     );
46     event onTokenSale(
47         address indexed customerAddress,
48         uint256 amount
49     );
50     event onTokenRedeem(
51         address indexed customerAddress,
52         uint256 amount
53     );
54 }
55 
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
58 }
59 
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
66         {
67     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
68     // benefit is lost if 'b' is also tested.
69     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (a == 0) {
71            return 0;
72         }
73 
74         c = a * b;
75         assert(c / a == b);
76         return c;
77         }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a / b;
84     }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 contract Ownable {
105   address public owner;
106 
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
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param _newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address _newOwner) public onlyOwner {
135     _transferOwnership(_newOwner);
136   }
137 
138   /**
139    * @dev Transfers control of the contract to a newOwner.
140    * @param _newOwner The address to transfer ownership to.
141    */
142   function _transferOwnership(address _newOwner) internal {
143     require(_newOwner != address(0));
144     emit OwnershipTransferred(owner, _newOwner);
145     owner = _newOwner;
146   }
147 }
148 
149 library Roles {
150   struct Role {
151     mapping (address => bool) bearer;
152   }
153 
154   /**
155    * @dev give an address access to this role
156    */
157   function add(Role storage role, address addr)
158     internal
159   {
160     role.bearer[addr] = true;
161   }
162 
163   /**
164    * @dev remove an address' access to this role
165    */
166   function remove(Role storage role, address addr)
167     internal
168   {
169     role.bearer[addr] = false;
170   }
171 
172   /**
173    * @dev check if an address has this role
174    * // reverts
175    */
176   function check(Role storage role, address addr)
177     view
178     internal
179   {
180     require(has(role, addr));
181   }
182 
183   /**
184    * @dev check if an address has this role
185    * @return bool
186    */
187   function has(Role storage role, address addr)
188     view
189     internal
190     returns (bool)
191   {
192     return role.bearer[addr];
193   }
194 }
195 
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) balances;
200 
201   uint256 totalSupply_;
202 
203   /**
204   * @dev Total number of tokens in existence
205   */
206   function totalSupply() public view returns (uint256) {
207     return totalSupply_;
208   }
209 
210   /**
211   * @dev Transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[msg.sender]);
218 
219     //if(myDividends() > 0) withdraw();
220 
221     balances[msg.sender] = balances[msg.sender].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     emit Transfer(msg.sender, _to, _value);
224     return true;
225   }
226 
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param _owner The address to query the the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address _owner) public view returns (uint256) {
233     return balances[_owner];
234   }
235 
236 }
237 
238 contract MultiSigTransfer is Ownable {
239   string public name = "MultiSigTransfer";
240   string public symbol = "MST";
241   bool public complete = false;
242   bool public denied = false;
243   uint256 public quantity;
244   address public targetAddress;
245   address public requesterAddress;
246 
247   /**
248   * @dev The multisig transfer contract ensures that no single administrator can
249   * GGTs without approval of another administrator
250   * @param _quantity The number of GGT to transfer
251   * @param _targetAddress The receiver of the GGTs
252   * @param _requesterAddress The administrator requesting the transfer
253   */
254   constructor(
255     uint256 _quantity,
256     address _targetAddress,
257     address _requesterAddress
258   ) public {
259     quantity = _quantity;
260     targetAddress = _targetAddress;
261     requesterAddress = _requesterAddress;
262   }
263 
264   /**
265   * @dev Mark the transfer as approved / complete
266   */
267   function approveTransfer() public onlyOwner {
268     require(denied == false, "cannot approve a denied transfer");
269     require(complete == false, "cannot approve a complete transfer");
270     complete = true;
271   }
272 
273   /**
274   * @dev Mark the transfer as denied
275   */
276   function denyTransfer() public onlyOwner {
277     require(denied == false, "cannot deny a transfer that is already denied");
278     denied = true;
279   }
280 
281   /**
282   * @dev Determine if the transfer is pending
283   */
284   function isPending() public view returns (bool) {
285     return !complete;
286   }
287 }
288 
289 contract RBAC {
290   using Roles for Roles.Role;
291 
292   mapping (string => Roles.Role) private roles;
293 
294   event RoleAdded(address indexed operator, string role);
295   event RoleRemoved(address indexed operator, string role);
296 
297   /**
298    * @dev reverts if addr does not have role
299    * @param _operator address
300    * @param _role the name of the role
301    * // reverts
302    */
303   function checkRole(address _operator, string _role)
304     view
305     public
306   {
307     roles[_role].check(_operator);
308   }
309 
310   /**
311    * @dev determine if addr has role
312    * @param _operator address
313    * @param _role the name of the role
314    * @return bool
315    */
316   function hasRole(address _operator, string _role)
317     view
318     public
319     returns (bool)
320   {
321     return roles[_role].has(_operator);
322   }
323 
324   /**
325    * @dev add a role to an address
326    * @param _operator address
327    * @param _role the name of the role
328    */
329   function addRole(address _operator, string _role)
330     internal
331   {
332     roles[_role].add(_operator);
333     emit RoleAdded(_operator, _role);
334   }
335 
336   /**
337    * @dev remove a role from an address
338    * @param _operator address
339    * @param _role the name of the role
340    */
341   function removeRole(address _operator, string _role)
342     internal
343   {
344     roles[_role].remove(_operator);
345     emit RoleRemoved(_operator, _role);
346   }
347 
348   /**
349    * @dev modifier to scope access to a single role (uses msg.sender as addr)
350    * @param _role the name of the role
351    * // reverts
352    */
353   modifier onlyRole(string _role)
354   {
355     checkRole(msg.sender, _role);
356     _;
357   }
358 
359   /**
360    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
361    * @param _roles the names of the roles to scope access to
362    * // reverts
363    *
364    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
365    *  see: https://github.com/ethereum/solidity/issues/2467
366    */
367   // modifier onlyRoles(string[] _roles) {
368   //     bool hasAnyRole = false;
369   //     for (uint8 i = 0; i < _roles.length; i++) {
370   //         if (hasRole(msg.sender, _roles[i])) {
371   //             hasAnyRole = true;
372   //             break;
373   //         }
374   //     }
375 
376   //     require(hasAnyRole);
377 
378   //     _;
379   // }
380 }
381 
382 contract GuardianGoldToken is BasicToken, Ownable, RBAC {
383     string public name = "GuardianGoldToken";
384     string public symbol = "GGT";
385     uint8 public decimals = 18;
386     string public constant ADMIN_ROLE = "ADMIN";
387 
388     uint256 constant internal magnitude = 2**64;
389 
390     uint public maxTokens = 5000e18;
391 
392     mapping(address => uint256) internal tokenBalanceLedger_;
393     mapping(address => int256) internal payoutsTo_;
394     mapping(address => uint256) internal referralBalance_;
395     mapping(address => mapping (address => uint256)) allowed;
396 
397     uint public goldAccount = 0;
398     uint public operationsAccount = 0;
399 
400     uint256 internal profitPerShare_;
401 
402     address[] public transfers;
403 
404     uint public constant INITIAL_SUPPLY = 62207e15; 
405     uint public totalSupply = 62207e15;
406     uint public totalGoldReserves = 62207e15;
407     uint public pendingGold = 0;
408     uint public totalETHReceived = 57.599 ether;
409 
410     bool public isTransferable = true;
411     bool public toggleTransferablePending = false;
412     address public transferToggleRequester = address(0);
413 
414     uint public tokenPrice = 0.925925 ether;
415     uint public goldPrice = 0.390185 ether;
416 
417     uint public tokenSellDiscount = 950;  //95%
418     uint public referralFee = 30;  //3%
419 
420     uint minGoldPrice = 0.2 ether;
421     uint maxGoldPrice = 0.7 ether;
422 
423     uint minTokenPrice = 0.5 ether;
424     uint maxTokenPrice = 2 ether;
425 
426     uint public dividendRate = 150;  //15%
427 
428 
429     uint public minPurchaseAmount = 0.1 ether;
430     uint public minSaleAmount = 1e18;   //1 GGT
431     uint public minRefStake = 1e17;  //0.1 GGT
432 
433     bool public allowBuy = false;
434     bool public allowSell = false;
435     bool public allowRedeem = false;
436 
437 
438 
439     constructor() public {
440         totalSupply = INITIAL_SUPPLY;
441         balances[msg.sender] = INITIAL_SUPPLY;
442         addRole(msg.sender, ADMIN_ROLE);
443         emit Transfer(address(this), msg.sender, INITIAL_SUPPLY);
444     }
445 
446 
447     function buy(address _referredBy) 
448 
449       payable 
450       public  
451 
452       {
453           require(msg.value >= minPurchaseAmount);
454           require(allowBuy);
455           //uint newTokens = SafeMath.div(msg.value,tokenPrice);
456           //newTokens = SafeMath.mul(newTokens, 1e18);
457           uint newTokens = ethereumToTokens_(msg.value);
458 
459           totalETHReceived = SafeMath.add(totalETHReceived, msg.value);
460 
461           require(SafeMath.add(totalSupply, newTokens) <= maxTokens);
462 
463           balances[msg.sender] = SafeMath.add(balances[msg.sender], newTokens);
464           totalSupply = SafeMath.add(newTokens, totalSupply);
465 
466           uint goldAmount = SafeMath.div(SafeMath.mul(goldPrice,msg.value),tokenPrice);
467           uint operationsAmount = SafeMath.sub(msg.value,goldAmount);
468 
469           uint256 _referralBonus = SafeMath.div(SafeMath.mul(operationsAmount, referralFee),1000);
470 
471           goldAccount = SafeMath.add(goldAmount, goldAccount);
472           uint _dividends = SafeMath.div(SafeMath.mul(dividendRate, operationsAmount),1000);
473 
474           if(
475             // is this a referred purchase?
476             _referredBy != 0x0000000000000000000000000000000000000000 &&
477             _referredBy != msg.sender &&
478             balances[_referredBy] >= minRefStake)
479             {
480                 operationsAmount = SafeMath.sub(operationsAmount,_referralBonus);
481                 //add referral amount to referrer dividend account
482                 referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
483             }
484 
485           uint256 _fee = _dividends * magnitude;
486           profitPerShare_ += (_dividends * magnitude / (totalSupply));
487           _fee = _fee - (_fee-(newTokens * (_dividends * magnitude / (totalSupply))));
488           int256 _updatedPayouts = (int256) ((profitPerShare_ * newTokens) - _fee);
489 
490           payoutsTo_[msg.sender] += _updatedPayouts;
491           operationsAmount = SafeMath.sub(operationsAmount, _dividends);
492           operationsAccount = SafeMath.add(operationsAccount, operationsAmount);
493 
494           pendingGold = SafeMath.add(pendingGold, newTokens);
495           emit Buy(msg.sender, newTokens);
496           emit Transfer(address(this), msg.sender, newTokens);
497     
498     }
499 
500     function sell(uint amount) 
501 
502       public
503   
504       {
505 
506         require(allowSell);
507         require(amount >= minSaleAmount);
508         require(balances[msg.sender] >= amount);
509 
510         //calculate Eth to be returned
511         uint256 _ethereum = tokensToEthereum_(amount);
512         require(_ethereum <= operationsAccount);
513         //burn sold tokens
514         totalSupply = SafeMath.sub(totalSupply, amount);
515 
516         if (pendingGold > amount) {
517             pendingGold = SafeMath.sub(pendingGold, amount);
518         }else{
519             pendingGold = 0;
520         }
521 
522         balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);
523 
524         //payout goes to dividend account
525         int256 _updatedPayouts = (int256) (profitPerShare_ * amount + (_ethereum * magnitude));
526         payoutsTo_[msg.sender] -= _updatedPayouts;    
527 
528         operationsAccount = SafeMath.sub(operationsAccount, _ethereum);  
529         emit onTokenSale(msg.sender, amount); 
530     }
531 
532 
533     function redeemTokensForGold(uint amount)
534 
535     public
536     {
537         //burn tokens that are to be redeemed for physical gold
538         require(allowRedeem);
539         require(balances[msg.sender] >= amount);
540         if(myDividends(true) > 0) withdraw();
541 
542         payoutsTo_[msg.sender] -= (int256) (profitPerShare_ * amount);
543 
544         balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);
545         totalSupply = SafeMath.sub(totalSupply, amount);
546         emit onTokenRedeem(msg.sender, amount);
547     }
548 
549 
550     function getTokenAmount(uint amount) public 
551     
552     returns(uint)
553 
554     {
555         return (amount*1e18)/(tokenPrice);
556     }
557 
558     function depositGold()
559       public
560       payable
561     {
562         goldAccount = SafeMath.add(goldAccount, msg.value);
563     }
564 
565     function depositOperations()
566       public
567       payable
568     {
569         operationsAccount = SafeMath.add(operationsAccount, msg.value);
570     }
571 
572   
573     function tokensToEthereum_(uint256 _tokens)
574        internal
575         view
576         returns(uint256)
577     {
578         uint liquidPrice = SafeMath.div(SafeMath.mul(goldPrice, tokenSellDiscount),1000);
579         uint256 _etherReceived = SafeMath.div(_tokens * liquidPrice, 1e18);
580         return _etherReceived;
581     }
582 
583     function ethereumToTokens_(uint256 _ethereum)
584         public
585         view
586         returns(uint256)
587     {
588         uint256 _tokensReceived = SafeMath.div(_ethereum*1e18, tokenPrice);
589             
590         return _tokensReceived;
591     }
592 
593     function updateGoldReserves(uint newReserves)
594     public
595     onlyRole(ADMIN_ROLE)
596     {
597         totalGoldReserves = newReserves;
598         if (totalSupply > totalGoldReserves) {
599             pendingGold = SafeMath.sub(totalSupply,totalGoldReserves);
600         }else{
601             pendingGold = 0;
602         }
603     }
604 
605     function setTokenPrice(uint newPrice)
606       public
607       onlyRole(ADMIN_ROLE)
608     {
609         require(newPrice >= minTokenPrice);
610         require(newPrice <= maxTokenPrice);
611         tokenPrice = newPrice;
612     }
613 
614     function setGoldPrice(uint newPrice)
615       public
616       onlyRole(ADMIN_ROLE)
617     {
618         require(newPrice >= minGoldPrice);
619         require(newPrice <= maxGoldPrice);
620         goldPrice = newPrice;
621     }
622 
623     function setTokenRange(uint newMax, uint newMin)
624         public
625         onlyRole(ADMIN_ROLE)
626         {
627             minTokenPrice = newMin;
628             maxTokenPrice = newMax;
629         }
630 
631     function setmaxTokens(uint newMax)
632       public
633       onlyRole(ADMIN_ROLE)
634       {
635           maxTokens = newMax;
636       }
637 
638     function setGoldRange(uint newMax, uint newMin)
639       public
640       onlyRole(ADMIN_ROLE)
641       {
642         minGoldPrice = newMin;
643         maxGoldPrice = newMax;
644       }
645 
646     function withDrawGoldAccount(uint amount)
647         public
648         onlyRole(ADMIN_ROLE)
649         {
650           require(amount <= goldAccount);
651           goldAccount = SafeMath.sub(goldAccount, amount);
652           msg.sender.transfer(amount);
653         }
654 
655       function withDrawOperationsAccount(uint amount)
656           public
657           onlyRole(ADMIN_ROLE)
658           {
659             require(amount <= operationsAccount);
660             operationsAccount = SafeMath.sub(operationsAccount, amount);
661             msg.sender.transfer(amount);
662           }
663 
664       function setAllowBuy(bool newAllow)
665           public
666           onlyRole(ADMIN_ROLE)
667           {
668             allowBuy = newAllow;
669           }
670 
671       function setAllowSell(bool newAllow)
672           public
673           onlyRole(ADMIN_ROLE)
674           {
675             allowSell = newAllow;
676           }
677 
678       function setAllowRedeem(bool newAllow)
679           public
680           onlyRole(ADMIN_ROLE)
681           {
682             allowRedeem = newAllow;
683           }
684 
685       function setMinPurchaseAmount(uint newAmount)
686           public 
687           onlyRole(ADMIN_ROLE)
688       {
689           minPurchaseAmount = newAmount;
690       } 
691 
692       function setMinSaleAmount(uint newAmount)
693           public 
694           onlyRole(ADMIN_ROLE)
695       {
696           minSaleAmount = newAmount;
697       } 
698 
699       function setMinRefStake(uint newAmount)
700           public 
701           onlyRole(ADMIN_ROLE)
702       {
703           minRefStake = newAmount;
704       } 
705 
706       function setReferralFee(uint newAmount)
707           public 
708           onlyRole(ADMIN_ROLE)
709       {
710           referralFee = newAmount;
711       } 
712 
713       function setProofofStakeFee(uint newAmount)
714           public 
715           onlyRole(ADMIN_ROLE)
716       {
717           dividendRate = newAmount;
718       } 
719       
720       function setTokenSellDiscount(uint newAmount)
721           public 
722           onlyRole(ADMIN_ROLE)
723       {
724           tokenSellDiscount = newAmount;
725       } 
726       
727 
728       function withdraw()
729           {
730               //require(myDividends() > 0);
731 
732               address _customerAddress = msg.sender;
733               uint256 _dividends = myDividends(false);
734 
735               payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
736 
737               // add ref. bonus
738               _dividends += referralBalance_[_customerAddress];
739               referralBalance_[_customerAddress] = 0;
740 
741               msg.sender.transfer(_dividends);
742 
743               onWithdraw(_customerAddress, _dividends);
744           }
745 
746       function myDividends(bool _includeReferralBonus) 
747           public 
748           view 
749           returns(uint256)
750             {
751                 address _customerAddress = msg.sender;
752                // return dividendsOf(_customerAddress);
753                 return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
754             }
755 
756 
757     /**
758       * Retrieve the dividend balance of any single address.
759       */
760     function dividendsOf(address _customerAddress)
761         view
762         public
763         returns(uint256)
764         {
765             return (uint256) ((int256)(profitPerShare_ * balanceOf(_customerAddress)) - payoutsTo_[_customerAddress]) / magnitude;
766         }
767     
768     function profitShare() 
769         public 
770         view 
771         returns(uint256)
772         {
773             return profitPerShare_;
774         }
775 
776     function payouts() 
777         public 
778         view 
779         returns(int256)
780         {
781             return payoutsTo_[msg.sender];
782         }
783 
784     function getTotalDivs() 
785       public
786       view
787       returns(uint256)
788       {
789           return (profitPerShare_ * totalSupply);
790       }
791 
792 
793       function tokenData() 
794           //Ethereum Balance, MyTokens, TotalTokens, myDividends
795           public 
796           view 
797           returns(uint256, uint256, uint256, uint256, uint256, uint256)
798       {
799           return(address(this).balance, balanceOf(msg.sender), totalSupply, myDividends(true), tokenSellDiscount, goldPrice);
800       }
801 
802 
803   /**
804   * @dev Determine if the address is the owner of the contract
805   * @param _address The address to determine of ownership
806   */
807   function isOwner(address _address) public view returns (bool) {
808     return owner == _address;
809   }
810 
811   /**
812   * @dev Returns the list of MultiSig transfers
813   */
814   function getTransfers() public view returns (address[]) {
815     return transfers;
816   }
817 
818   /**
819   * @dev The GGT ERC20 token uses adminstrators to handle transfering to the crowdsale, vesting and pre-purchasers
820   */
821   function isAdmin(address _address) public view returns (bool) {
822     return hasRole(_address, ADMIN_ROLE);
823   }
824 
825   /**
826   * @dev Set an administrator as the owner, using Open Zepplin RBAC implementation
827   */
828   function setAdmin(address _newAdmin) public onlyOwner {
829     return addRole(_newAdmin, ADMIN_ROLE);
830   }
831 
832   /**
833   * @dev Remove an administrator as the owner, using Open Zepplin RBAC implementation
834   */
835   function removeAdmin(address _oldAdmin) public onlyOwner {
836     return removeRole(_oldAdmin, ADMIN_ROLE);
837   }
838 
839   /**
840   * @dev As an administrator, request the token is made transferable
841   * @param _toState The transfer state being requested
842   */
843   function setTransferable(bool _toState) public onlyRole(ADMIN_ROLE) {
844     require(isTransferable != _toState, "to init a transfer toggle, the toState must change");
845     toggleTransferablePending = true;
846     transferToggleRequester = msg.sender;
847   }
848 
849   /**
850   * @dev As an administrator who did not make the request, approve the transferable state change
851   */
852   function approveTransferableToggle() public onlyRole(ADMIN_ROLE) {
853     require(toggleTransferablePending == true, "transfer toggle not in pending state");
854     require(transferToggleRequester != msg.sender, "the requester cannot approve the transfer toggle");
855     isTransferable = !isTransferable;
856     toggleTransferablePending = false;
857     transferToggleRequester = address(0);
858   }
859 
860   /**
861   * @dev transfer token for a specified address
862   * @param _to The address to transfer to.
863   * @param _value The amount to be transferred.
864   */
865   function _transfer(address _to, address _from, uint256 _value) private returns (bool) {
866     require(_value <= balances[_from], "the balance in the from address is smaller than the tx value");
867 
868     // SafeMath.sub will throw if there is not enough balance.
869     //payoutsTo_[_to] += (int256) (profitPerShare_ * _value);
870 
871   
872     if(myDividends(true) > 0) withdraw();
873     balances[_from] = balances[_from].sub(_value);
874     balances[_to] = balances[_to].add(_value);
875 
876      // update dividend trackers
877     payoutsTo_[_from] -= (int256) (profitPerShare_ * _value);
878     payoutsTo_[_to] += (int256) (profitPerShare_ * _value);
879         
880     // disperse dividends among holders
881     //profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / totalSupply);
882 
883     emit Transfer(_from, _to, _value);
884     return true;
885   }
886 
887   /**
888   * @dev Public transfer token function. This wrapper ensures the token is transferable
889   * @param _to The address to transfer to.
890   * @param _value The amount to be transferred.
891   */
892   function transfer(address _to, uint256 _value) public returns (bool) {
893     require(_to != address(0), "cannot transfer to the zero address");
894 
895     /* We allow holders to return their Tokens to the contract owner at any point */
896     if (_to != owner && msg.sender != crowdsale) {
897       require(isTransferable == true, "GGT is not yet transferable");
898     }
899 
900     /* Transfers from the owner address must use the administrative transfer */
901     require(msg.sender != owner, "the owner of the GGT contract cannot transfer");
902 
903     return _transfer(_to, msg.sender, _value);
904   }
905 
906 
907 
908 
909    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
910         balances[from] = balances[from].sub(tokens);
911         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
912         balances[to] = balances[to].add(tokens);
913         Transfer(from, to, tokens);
914         return true;
915     }
916  
917     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
918     // If this function is called again it overwrites the current allowance with _value.
919     function approve(address spender, uint tokens) public returns (bool success) {
920         allowed[msg.sender][spender] = tokens;
921         Approval(msg.sender, spender, tokens);
922         return true;
923     }
924 
925     // ------------------------------------------------------------------------
926     // Returns the amount of tokens approved by the owner that can be
927     // transferred to the spender's account
928     // ------------------------------------------------------------------------
929     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
930         return allowed[tokenOwner][spender];
931     }
932 
933     // ------------------------------------------------------------------------
934     // Token owner can approve for `spender` to transferFrom(...) `tokens`
935     // from the token owner's account. The `spender` contract function
936     // `receiveApproval(...)` is then executed
937     // ------------------------------------------------------------------------
938     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
939         allowed[msg.sender][spender] = tokens;
940         emit Approval(msg.sender, spender, tokens);
941         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
942         return true;
943     }
944 
945 
946   /**
947   * @dev Request an administrative transfer. This does not move tokens
948   * @param _to The address to transfer to.
949   * @param _quantity The amount to be transferred.
950   */
951   function adminTransfer(address _to, uint256 _quantity) public onlyRole(ADMIN_ROLE) {
952     address newTransfer = new MultiSigTransfer(_quantity, _to, msg.sender);
953     transfers.push(newTransfer);
954   }
955 
956   /**
957   * @dev Approve an administrative transfer. This moves the tokens if the requester
958   * is an admin, but not the same admin as the one who made the request
959   * @param _approvedTransfer The contract address of the multisignature transfer.
960   */
961   function approveTransfer(address _approvedTransfer) public onlyRole(ADMIN_ROLE) returns (bool) {
962     MultiSigTransfer transferToApprove = MultiSigTransfer(_approvedTransfer);
963 
964     uint256 transferQuantity = transferToApprove.quantity();
965     address deliveryAddress = transferToApprove.targetAddress();
966     address requesterAddress = transferToApprove.requesterAddress();
967 
968     require(msg.sender != requesterAddress, "a requester cannot approve an admin transfer");
969 
970     transferToApprove.approveTransfer();
971     return _transfer(deliveryAddress, owner, transferQuantity);
972   }
973 
974   /**
975   * @dev Deny an administrative transfer. This ensures it cannot be approved.
976   * @param _approvedTransfer The contract address of the multisignature transfer.
977   */
978   function denyTransfer(address _approvedTransfer) public onlyRole(ADMIN_ROLE) returns (bool) {
979     MultiSigTransfer transferToApprove = MultiSigTransfer(_approvedTransfer);
980     transferToApprove.denyTransfer();
981   }
982 
983   address public crowdsale = address(0);
984 
985   /**
986   * @dev Any admin can set the current crowdsale address, to allows transfers
987   * from the crowdsale to the purchaser
988   */
989   function setCrowdsaleAddress(address _crowdsaleAddress) public onlyRole(ADMIN_ROLE) {
990     crowdsale = _crowdsaleAddress;
991   }
992 }