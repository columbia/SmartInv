1 pragma solidity 0.4.24;
2   
3 //@title WitToken
4 //@author(luoyuanq233@gmail.com) 
5 //@dev 该合约参考自openzeppelin的erc20实现
6 //1.使用openzeppelin的SafeMath库防止运算溢出
7 //2.使用openzeppelin的Ownable,Roles,RBAC来做权限控制,自定义了ceo,coo,cro等角色  
8 //3.ERC20扩展了ERC20Basic，实现了授权转移
9 //4.BasicToken,StandardToken,PausableToken均是erc20的具体实现
10 //5.BlackListToken加入黑名单方法
11 //6.TwoPhaseToken可以发行和赎回资产,并采用经办复核的二阶段提交
12 //7.UpgradedStandardToken参考自TetherUSD合约,可以在另一个合约升级erc20的方法
13 //8.可以设置交易的手续费率
14 
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address public owner;
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31    constructor() public {
32       owner = msg.sender;
33   }
34 
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57   /**
58  * @title Roles
59  * @author Francisco Giordano (@frangio)
60  * @dev Library for managing addresses assigned to a Role.
61  *      See RBAC.sol for example usage.
62  */
63 library Roles {
64   struct Role {
65     mapping (address => bool) bearer;
66   }
67 
68   /**
69    * @dev give an address access to this role
70    */
71   function add(Role storage role, address addr) internal {
72     role.bearer[addr] = true;
73   }
74 
75   /**
76    * @dev remove an address' access to this role
77    */
78   function remove(Role storage role, address addr) internal {
79     role.bearer[addr] = false;
80   }
81 
82   /**
83    * @dev check if an address has this role
84    * // reverts
85    */
86   function check(Role storage role, address addr) view internal {
87     require(has(role, addr));
88   }
89 
90   /**
91    * @dev check if an address has this role
92    * @return bool
93    */
94   function has(Role storage role, address addr) view internal returns (bool) {
95     return role.bearer[addr];
96   }
97 }
98 
99 /**
100  * @title RBAC (Role-Based Access Control)
101  * @author Matt Condon (@Shrugs)
102  * @dev Stores and provides setters and getters for roles and addresses.
103  *      Supports unlimited numbers of roles and addresses.
104  *      See //contracts/mocks/RBACMock.sol for an example of usage.
105  * This RBAC method uses strings to key roles. It may be beneficial
106  *  for you to write your own implementation of this interface using Enums or similar.
107  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
108  *  to avoid typos.
109  */
110 contract RBAC is Ownable {
111   using Roles for Roles.Role;
112 
113   mapping (string => Roles.Role) private roles;
114 
115   event RoleAdded(address addr, string roleName);
116   event RoleRemoved(address addr, string roleName);
117 
118   /**
119    * A constant role name for indicating admins.
120    */
121   string public constant ROLE_CEO = "ceo";
122   string public constant ROLE_COO = "coo";//运营
123   string public constant ROLE_CRO = "cro";//风控
124   string public constant ROLE_MANAGER = "manager";//经办员
125   string public constant ROLE_REVIEWER = "reviewer";//审核员
126   
127   /**
128    * @dev constructor. Sets msg.sender as ceo by default
129    */
130   constructor() public{
131     addRole(msg.sender, ROLE_CEO);
132   }
133   
134   /**
135    * @dev reverts if addr does not have role
136    * @param addr address
137    * @param roleName the name of the role
138    * // reverts
139    */
140   function checkRole(address addr, string roleName) view internal {
141     roles[roleName].check(addr);
142   }
143 
144   /**
145    * @dev determine if addr has role
146    * @param addr address
147    * @param roleName the name of the role
148    * @return bool
149    */
150   function hasRole(address addr, string roleName) view public returns (bool) {
151     return roles[roleName].has(addr);
152   }
153 
154   function ownerAddCeo(address addr) onlyOwner public {
155     addRole(addr, ROLE_CEO);
156   }
157   
158   function ownerRemoveCeo(address addr) onlyOwner public{
159     removeRole(addr, ROLE_CEO);
160   }
161 
162   function ceoAddCoo(address addr) onlyCEO public {
163     addRole(addr, ROLE_COO);
164   }
165   
166   function ceoRemoveCoo(address addr) onlyCEO public{
167     removeRole(addr, ROLE_COO);
168   }
169   
170   function cooAddManager(address addr) onlyCOO public {
171     addRole(addr, ROLE_MANAGER);
172   }
173   
174   function cooRemoveManager(address addr) onlyCOO public {
175     removeRole(addr, ROLE_MANAGER);
176   }
177   
178   function cooAddReviewer(address addr) onlyCOO public {
179     addRole(addr, ROLE_REVIEWER);
180   }
181   
182   function cooRemoveReviewer(address addr) onlyCOO public {
183     removeRole(addr, ROLE_REVIEWER);
184   }
185   
186   function cooAddCro(address addr) onlyCOO public {
187     addRole(addr, ROLE_CRO);
188   }
189   
190   function cooRemoveCro(address addr) onlyCOO public {
191     removeRole(addr, ROLE_CRO);
192   }
193 
194   /**
195    * @dev add a role to an address
196    * @param addr address
197    * @param roleName the name of the role
198    */
199   function addRole(address addr, string roleName) internal {
200     roles[roleName].add(addr);
201     emit RoleAdded(addr, roleName);
202   }
203 
204   /**
205    * @dev remove a role from an address
206    * @param addr address
207    * @param roleName the name of the role
208    */
209   function removeRole(address addr, string roleName) internal {
210     roles[roleName].remove(addr);
211     emit RoleRemoved(addr, roleName);
212   }
213 
214 
215   /**
216    * @dev modifier to scope access to ceo
217    * // reverts
218    */
219   modifier onlyCEO() {
220     checkRole(msg.sender, ROLE_CEO);
221     _;
222   }
223 
224   /**
225    * @dev modifier to scope access to coo
226    * // reverts
227    */
228   modifier onlyCOO() {
229     checkRole(msg.sender, ROLE_COO);
230     _;
231   }
232   
233   /**
234    * @dev modifier to scope access to cro
235    * // reverts
236    */
237   modifier onlyCRO() {
238     checkRole(msg.sender, ROLE_CRO);
239     _;
240   }
241   
242   /**
243    * @dev modifier to scope access to manager
244    * // reverts
245    */
246   modifier onlyMANAGER() {
247     checkRole(msg.sender, ROLE_MANAGER);
248     _;
249   }
250   
251   /**
252    * @dev modifier to scope access to reviewer
253    * // reverts
254    */
255   modifier onlyREVIEWER() {
256     checkRole(msg.sender, ROLE_REVIEWER);
257     _;
258   }
259 
260 }
261 
262 
263 /**
264  * @title SafeMath
265  * @dev Math operations with safety checks that throw on error
266  */
267 library SafeMath {
268   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269     if (a == 0) {
270       return 0;
271     }
272     uint256 c = a * b;
273     assert(c / a == b);
274     return c;
275   }
276 
277   function div(uint256 a, uint256 b) internal pure returns (uint256) {
278     // assert(b > 0); // Solidity automatically throws when dividing by 0
279     uint256 c = a / b;
280     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281     return c;
282   }
283 
284   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285     assert(b <= a);
286     return a - b;
287   }
288 
289   function add(uint256 a, uint256 b) internal pure returns (uint256) {
290     uint256 c = a + b;
291     assert(c >= a);
292     return c;
293   }
294 }
295 
296 
297 
298 
299 /**
300  * 
301  * @title ERC20Basic
302  * @dev Simpler version of ERC20 interface
303  * @dev see https://github.com/ethereum/EIPs/issues/179
304  */
305 contract ERC20Basic {
306   function totalSupply() public view returns (uint256);
307   function balanceOf(address who) public view returns (uint256);
308   function transfer(address to, uint256 value) public returns (bool);
309   event Transfer(address indexed from, address indexed to, uint256 value);
310 }
311 
312 /**
313  * @title ERC20 interface
314  * @dev see https://github.com/ethereum/EIPs/issues/20
315  */
316 contract ERC20 is ERC20Basic {
317   function allowance(address owner, address spender) public view returns (uint256);
318   function transferFrom(address from, address to, uint256 value) public returns (bool);
319   function approve(address spender, uint256 value) public returns (bool);
320   event Approval(address indexed owner, address indexed spender, uint256 value);
321 }
322 
323 
324 
325 /**
326  * @title Basic token
327  * @dev Basic version of StandardToken, with no allowances.
328  */
329 contract BasicToken is ERC20Basic, RBAC {
330   using SafeMath for uint256;
331 
332   mapping(address => uint256) balances;
333 
334   uint256 totalSupply_;
335   
336   uint256 public basisPointsRate;//手续费率 
337   uint256 public maximumFee;//最大手续费 
338   address public assetOwner;//收取的手续费和增发的资产都到这个地址上, 赎回资产时会从这个地址销毁资产 
339 
340   /**
341   * @dev total number of tokens in existence
342   */
343   function totalSupply() public view returns (uint256) {
344     return totalSupply_;
345   }
346 
347   /**
348   * @dev transfer token for a specified address
349   * @param _to The address to transfer to.
350   * @param _value The amount to be transferred.
351   */
352   function transfer(address _to, uint256 _value) public returns (bool) {
353     require(_to != address(0));
354     require(_value <= balances[msg.sender]);
355 
356     uint256 fee = (_value.mul(basisPointsRate)).div(10000);
357     if (fee > maximumFee) {
358         fee = maximumFee;
359     }
360     uint256 sendAmount = _value.sub(fee);
361     
362     // SafeMath.sub will throw if there is not enough balance.
363     balances[msg.sender] = balances[msg.sender].sub(_value);
364     balances[_to] = balances[_to].add(sendAmount);
365     if (fee > 0) {
366         balances[assetOwner] = balances[assetOwner].add(fee);
367         emit Transfer(msg.sender, assetOwner, fee);
368     }
369     
370     emit Transfer(msg.sender, _to, sendAmount);
371     return true;
372   }
373 
374   /**
375   * @dev Gets the balance of the specified address.
376   * @param _owner The address to query the the balance of.
377   * @return An uint256 representing the amount owned by the passed address.
378   */
379   function balanceOf(address _owner) public view returns (uint256 balance) {
380     return balances[_owner];
381   }
382 
383 }
384 
385 
386 /**
387  * @title Standard ERC20 token
388  *
389  * @dev Implementation of the basic standard token.
390  * @dev https://github.com/ethereum/EIPs/issues/20
391  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
392  */
393 contract StandardToken is ERC20, BasicToken  {
394 
395   mapping (address => mapping (address => uint256)) internal allowed;
396 
397 
398   /**
399    * @dev Transfer tokens from one address to another
400    * @param _from address The address which you want to send tokens from
401    * @param _to address The address which you want to transfer to
402    * @param _value uint256 the amount of tokens to be transferred
403    */
404   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
405     require(_to != address(0));
406     require(_value <= balances[_from]);
407     require(_value <= allowed[_from][msg.sender]);
408 
409     uint256 fee = (_value.mul(basisPointsRate)).div(10000);
410         if (fee > maximumFee) {
411             fee = maximumFee;
412         }
413     uint256 sendAmount = _value.sub(fee);
414     
415     balances[_from] = balances[_from].sub(_value);
416     balances[_to] = balances[_to].add(sendAmount);
417     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
418     if (fee > 0) {
419             balances[assetOwner] = balances[assetOwner].add(fee);
420             emit Transfer(_from, assetOwner, fee);
421         }
422     emit Transfer(_from, _to, sendAmount);
423     return true;
424   }
425 
426   /**
427    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
428    *
429    * Beware that changing an allowance with this method brings the risk that someone may use both the old
430    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
431    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
432    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
433    * @param _spender The address which will spend the funds.
434    * @param _value The amount of tokens to be spent.
435    */
436   function approve(address _spender, uint256 _value) public returns (bool) {
437     allowed[msg.sender][_spender] = _value;
438     emit Approval(msg.sender, _spender, _value);
439     return true;
440   }
441 
442   /**
443    * @dev Function to check the amount of tokens that an owner allowed to a spender.
444    * @param _owner address The address which owns the funds.
445    * @param _spender address The address which will spend the funds.
446    * @return A uint256 specifying the amount of tokens still available for the spender.
447    */
448   function allowance(address _owner, address _spender) public view returns (uint256) {
449     return allowed[_owner][_spender];
450   }
451 
452   /**
453    * @dev Increase the amount of tokens that an owner allowed to a spender.
454    *
455    * approve should be called when allowed[_spender] == 0. To increment
456    * allowed value is better to use this function to avoid 2 calls (and wait until
457    * the first transaction is mined)
458    * From MonolithDAO Token.sol
459    * @param _spender The address which will spend the funds.
460    * @param _addedValue The amount of tokens to increase the allowance by.
461    */
462   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
463     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
464     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
465     return true;
466   }
467 
468   /**
469    * @dev Decrease the amount of tokens that an owner allowed to a spender.
470    *
471    * approve should be called when allowed[_spender] == 0. To decrement
472    * allowed value is better to use this function to avoid 2 calls (and wait until
473    * the first transaction is mined)
474    * From MonolithDAO Token.sol
475    * @param _spender The address which will spend the funds.
476    * @param _subtractedValue The amount of tokens to decrease the allowance by.
477    */
478   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
479     uint oldValue = allowed[msg.sender][_spender];
480     if (_subtractedValue > oldValue) {
481       allowed[msg.sender][_spender] = 0;
482     } else {
483       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
484     }
485     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
486     return true;
487   }
488 
489 }
490 
491 
492 
493 
494 /**
495  * @title Pausable
496  * @dev Base contract which allows children to implement an emergency stop mechanism.
497  */
498 contract Pausable is RBAC {
499   event Pause();
500   event Unpause();
501 
502   bool public paused = false;
503 
504   /**
505    * @dev Modifier to make a function callable only when the contract is not paused.
506    */
507   modifier whenNotPaused() {
508     require(!paused);
509     _;
510   }
511 
512   /**
513    * @dev Modifier to make a function callable only when the contract is paused.
514    */
515   modifier whenPaused() {
516     require(paused);
517     _;
518   }
519 
520   /**
521    * @dev called by the ceo to pause, triggers stopped state
522    */
523   function pause() onlyCEO whenNotPaused public {
524     paused = true;
525     emit Pause();
526   }
527 
528   /**
529    * @dev called by the ceo to unpause, returns to normal state
530    */
531   function unpause() onlyCEO whenPaused public {
532     paused = false;
533     emit Unpause();
534   }
535 }
536 
537 
538 
539 /**
540  * @title Pausable token
541  * @dev StandardToken modified with pausable transfers.
542  **/
543 contract PausableToken is StandardToken, Pausable {
544 
545   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
546     return super.transfer(_to, _value);
547   }
548 
549   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
550     return super.transferFrom(_from, _to, _value);
551   }
552 
553   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
554     return super.approve(_spender, _value);
555   }
556 
557   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
558     return super.increaseApproval(_spender, _addedValue);
559   }
560 
561   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
562     return super.decreaseApproval(_spender, _subtractedValue);
563   }
564 }
565 
566 
567 contract BlackListToken is PausableToken  {
568 
569   
570     function getBlackListStatus(address _maker) external view returns (bool) {
571         return isBlackListed[_maker];
572     }
573 
574     mapping (address => bool) public isBlackListed;
575     
576     function addBlackList (address _evilUser) public onlyCRO {
577         isBlackListed[_evilUser] = true;
578         emit AddedBlackList(_evilUser);
579     }
580 
581     function removeBlackList (address _clearedUser) public onlyCRO {
582         isBlackListed[_clearedUser] = false;
583         emit RemovedBlackList(_clearedUser);
584     }
585 
586     function destroyBlackFunds (address _blackListedUser) public onlyCEO {
587         require(isBlackListed[_blackListedUser]);
588         uint dirtyFunds = balanceOf(_blackListedUser);
589         balances[_blackListedUser] = 0;
590         totalSupply_ = totalSupply_.sub(dirtyFunds);
591         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
592     }
593 
594     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
595 
596     event AddedBlackList(address _user);
597 
598     event RemovedBlackList(address _user);
599 
600 }
601 
602 
603 
604 
605 
606 /**
607 * 增发和赎回token由经办人和复核人配合完成
608 * 1.由经办人角色先执行submitIssue或submitRedeem;
609 * 2.复核人角色再来执行comfirmIsses或comfirmRedeem;
610 * 3.两者提交的参数一致，则增发和赎回才能成功
611 * 4.经办人提交数据后，复核人执行成功后，需要经办人再次提交才能再次执行
612 **/
613 contract TwoPhaseToken is BlackListToken{
614     
615     //保存经办人提交的参数
616     struct MethodParam {
617         string method; //方法名
618         uint value;  //增发或者赎回的数量
619         bool state;  //true表示经办人有提交数据,复核人执行成功后变为false
620     }
621     
622     mapping (string => MethodParam) params;
623     
624     //方法名常量 
625     string public constant ISSUE_METHOD = "issue";
626     string public constant REDEEM_METHOD = "redeem";
627     
628     
629     //经办人提交增发数量
630     function submitIssue(uint _value) public onlyMANAGER {
631         params[ISSUE_METHOD] = MethodParam(ISSUE_METHOD, _value, true);
632         emit SubmitIsses(msg.sender,_value);
633     }
634     
635     //复核人第二次确认增发数量并执行
636     function comfirmIsses(uint _value) public onlyREVIEWER {
637        
638         require(params[ISSUE_METHOD].value == _value);
639         require(params[ISSUE_METHOD].state == true);
640         
641         balances[assetOwner]=balances[assetOwner].add(_value);
642         totalSupply_ = totalSupply_.add(_value);
643         params[ISSUE_METHOD].state=false; 
644         emit ComfirmIsses(msg.sender,_value);
645     }
646     
647     //经办人提交赎回数量
648     function submitRedeem(uint _value) public onlyMANAGER {
649         params[REDEEM_METHOD] = MethodParam(REDEEM_METHOD, _value, true);
650          emit SubmitRedeem(msg.sender,_value);
651     }
652     
653     //复核人第二次确认赎回数量并执行
654     function comfirmRedeem(uint _value) public onlyREVIEWER {
655        
656        require(params[REDEEM_METHOD].value == _value);
657        require(params[REDEEM_METHOD].state == true);
658        
659        balances[assetOwner]=balances[assetOwner].sub(_value);
660        totalSupply_ = totalSupply_.sub(_value);
661        params[REDEEM_METHOD].state=false;
662        emit ComfirmIsses(msg.sender,_value);
663     }
664     
665     //根据方法名，查看经办人提交的参数
666     function getMethodValue(string _method) public view returns(uint){
667         return params[_method].value;
668     }
669     
670     //根据方法名，查看经办人是否有提交数据
671     function getMethodState(string _method) public view returns(bool) {
672       return params[_method].state;
673     }
674    
675      event SubmitRedeem(address submit, uint _value);
676      event ComfirmRedeem(address comfirm, uint _value);
677      event SubmitIsses(address submit, uint _value);
678      event ComfirmIsses(address comfirm, uint _value);
679 
680     
681 }
682 
683 
684 
685 contract UpgradedStandardToken {
686     // those methods are called by the legacy contract
687     function totalSupplyByLegacy() public view returns (uint256);
688     function balanceOfByLegacy(address who) public view returns (uint256);
689     function transferByLegacy(address origSender, address to, uint256 value) public returns (bool);
690     function allowanceByLegacy(address owner, address spender) public view returns (uint256);
691     function transferFromByLegacy(address origSender, address from, address to, uint256 value) public returns (bool);
692     function approveByLegacy(address origSender, address spender, uint256 value) public returns (bool);
693     function increaseApprovalByLegacy(address origSender, address spender, uint addedValue) public returns (bool);
694     function decreaseApprovalByLegacy(address origSende, address spender, uint subtractedValue) public returns (bool);
695 }
696 
697 
698 
699 
700 contract WitToken is TwoPhaseToken {
701     string  public  constant name = "Wealth in Tokens";
702     string  public  constant symbol = "WIT";
703     uint8   public  constant decimals = 18;
704     address public upgradedAddress;
705     bool public deprecated;
706 
707     modifier validDestination( address to ) {
708         require(to != address(0x0));
709         require(to != address(this));
710         _;
711     }
712 
713     constructor ( uint _totalTokenAmount ) public {
714         basisPointsRate = 0;
715         maximumFee = 0;
716         totalSupply_ = _totalTokenAmount;
717         balances[msg.sender] = _totalTokenAmount;
718         deprecated = false;
719         assetOwner = msg.sender;
720         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
721     }
722     
723     
724     
725      // Forward ERC20 methods to upgraded contract if this one is deprecated
726      function totalSupply() public view returns (uint256) {
727          if (deprecated) {
728             return UpgradedStandardToken(upgradedAddress).totalSupplyByLegacy();
729         } else {
730             return totalSupply_;
731         }
732     }
733     
734     // Forward ERC20 methods to upgraded contract if this one is deprecated
735     function balanceOf(address _owner) public view returns (uint256 balance) {
736          if (deprecated) {
737             return UpgradedStandardToken(upgradedAddress).balanceOfByLegacy( _owner);
738         } else {
739            return super.balanceOf(_owner);
740         }
741     }
742 
743     
744     // Forward ERC20 methods to upgraded contract if this one is deprecated
745     function transfer(address _to, uint _value) public validDestination(_to) returns (bool) {
746         require(!isBlackListed[msg.sender]);
747         if (deprecated) {
748             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
749         } else {
750             return super.transfer(_to, _value);
751         }
752         
753     }
754 
755 
756     // Forward ERC20 methods to upgraded contract if this one is deprecated
757     function allowance(address _owner, address _spender) public view returns (uint256) {
758         if (deprecated) {
759             return UpgradedStandardToken(upgradedAddress).allowanceByLegacy(_owner, _spender);
760         } else {
761            return super.allowance(_owner, _spender);
762         }
763         
764     }
765 
766 
767     // Forward ERC20 methods to upgraded contract if this one is deprecated
768     function transferFrom(address _from, address _to, uint _value) public validDestination(_to) returns (bool) {
769         require(!isBlackListed[_from]);
770         if (deprecated) {
771             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
772         } else {
773             return super.transferFrom(_from, _to, _value);
774         }
775        
776     }
777     
778     
779      // Forward ERC20 methods to upgraded contract if this one is deprecated
780      function approve(address _spender, uint256 _value) public returns (bool) {
781           if (deprecated) {
782             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
783         } else {
784             return super.approve(_spender, _value);
785         } 
786     }
787     
788     
789     // Forward ERC20 methods to upgraded contract if this one is deprecated
790     function increaseApproval(address _spender, uint _value) public returns (bool) {
791          if (deprecated) {
792             return UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(msg.sender, _spender, _value);
793         } else {
794             return super.increaseApproval(_spender, _value);
795         } 
796     }
797 
798 
799     // Forward ERC20 methods to upgraded contract if this one is deprecated
800     function decreaseApproval(address _spender, uint _value) public returns (bool) {
801         if (deprecated) {
802             return UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(msg.sender, _spender, _value);
803         } else {
804             return super.decreaseApproval(_spender, _value);
805         } 
806    }
807    
808    
809     // deprecate current contract in favour of a new one
810     function deprecate(address _upgradedAddress) public onlyCEO whenPaused {
811         deprecated = true;
812         upgradedAddress = _upgradedAddress;
813         emit Deprecate(_upgradedAddress);
814     }
815     
816     // Called when contract is deprecated
817     event Deprecate(address newAddress);
818     
819     
820    /**
821    * @dev Set up transaction fees
822    * @param newBasisPoints  A few ten-thousandth (设置手续费率为万分之几)
823    * @param newMaxFee Maximum fee (设置最大手续费,不需要添加decimals)
824    */
825     function setFeeParams(uint newBasisPoints, uint newMaxFee) public onlyCEO {
826        
827         basisPointsRate = newBasisPoints;
828         maximumFee = newMaxFee.mul(uint(10)**decimals);
829         emit FeeParams(basisPointsRate, maximumFee);
830     }
831     
832 
833     function transferAssetOwner(address newAssetOwner) public onlyCEO {
834       require(newAssetOwner != address(0));
835       assetOwner = newAssetOwner;
836       emit TransferAssetOwner(assetOwner, newAssetOwner);
837     }
838     
839     event TransferAssetOwner(address assetOwner, address newAssetOwner);
840     
841      // Called if contract ever adds fees
842     event FeeParams(uint feeBasisPoints, uint maxFee);
843     
844     
845     
846 
847 }