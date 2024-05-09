1 pragma solidity ^0.4.24;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library AddressUtils {
7 
8   /**
9    * Returns whether the target address is a contract
10    * @dev This function will return false if invoked during the constructor of a contract,
11    * as the code is not actually created until after the constructor finishes.
12    * @param addr address to check
13    * @return whether the target address is a contract
14    */
15   function isContract(address addr) internal view returns (bool) {
16     uint256 size;
17     // XXX Currently there is no better way to check if there is a contract in an address
18     // than to check the size of the code at that address.
19     // See https://ethereum.stackexchange.com/a/14016/36603
20     // for more details about how this works.
21     // TODO Check this again before the Serenity release, because all addresses will be
22     // contracts then.
23     // solium-disable-next-line security/no-inline-assembly
24     assembly { size := extcodesize(addr) }
25     return size > 0;
26   }
27 
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, throws on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43     if (a == 0) {
44       return 0;
45     }
46 
47     c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     // uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return a / b;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86   address public owner;
87 
88 
89   event OwnershipRenounced(address indexed previousOwner);
90   event OwnershipTransferred(
91     address indexed previousOwner,
92     address indexed newOwner
93   );
94 
95 
96   /**
97    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98    * account.
99    */
100   constructor() public {
101     owner = msg.sender;
102   }
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112   /**
113    * @dev Allows the current owner to relinquish control of the contract.
114    * @notice Renouncing to ownership will leave the contract without an owner.
115    * It will not be possible to call the functions with the `onlyOwner`
116    * modifier anymore.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipRenounced(owner);
120     owner = address(0);
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param _newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address _newOwner) public onlyOwner {
128     _transferOwnership(_newOwner);
129   }
130 
131   /**
132    * @dev Transfers control of the contract to a newOwner.
133    * @param _newOwner The address to transfer ownership to.
134    */
135   function _transferOwnership(address _newOwner) internal {
136     require(_newOwner != address(0));
137     emit OwnershipTransferred(owner, _newOwner);
138     owner = _newOwner;
139   }
140 }
141 
142 /**
143  * @title Roles
144  * @author Francisco Giordano (@frangio)
145  * @dev Library for managing addresses assigned to a Role.
146  * See RBAC.sol for example usage.
147  */
148 library Roles {
149   struct Role {
150     mapping (address => bool) bearer;
151   }
152 
153   /**
154    * @dev give an address access to this role
155    */
156   function add(Role storage role, address addr)
157     internal
158   {
159     role.bearer[addr] = true;
160   }
161 
162   /**
163    * @dev remove an address' access to this role
164    */
165   function remove(Role storage role, address addr)
166     internal
167   {
168     role.bearer[addr] = false;
169   }
170 
171   /**
172    * @dev check if an address has this role
173    * // reverts
174    */
175   function check(Role storage role, address addr)
176     view
177     internal
178   {
179     require(has(role, addr));
180   }
181 
182   /**
183    * @dev check if an address has this role
184    * @return bool
185    */
186   function has(Role storage role, address addr)
187     view
188     internal
189     returns (bool)
190   {
191     return role.bearer[addr];
192   }
193 }
194 
195 /**
196  * @title RBAC (Role-Based Access Control)
197  * @author Matt Condon (@Shrugs)
198  * @dev Stores and provides setters and getters for roles and addresses.
199  * Supports unlimited numbers of roles and addresses.
200  * See //contracts/mocks/RBACMock.sol for an example of usage.
201  * This RBAC method uses strings to key roles. It may be beneficial
202  * for you to write your own implementation of this interface using Enums or similar.
203  */
204 contract RBAC {
205   using Roles for Roles.Role;
206 
207   mapping (string => Roles.Role) private roles;
208 
209   event RoleAdded(address indexed operator, string role);
210   event RoleRemoved(address indexed operator, string role);
211 
212   /**
213    * @dev reverts if addr does not have role
214    * @param _operator address
215    * @param _role the name of the role
216    * // reverts
217    */
218   function checkRole(address _operator, string _role)
219     view
220     public
221   {
222     roles[_role].check(_operator);
223   }
224 
225   /**
226    * @dev determine if addr has role
227    * @param _operator address
228    * @param _role the name of the role
229    * @return bool
230    */
231   function hasRole(address _operator, string _role)
232     view
233     public
234     returns (bool)
235   {
236     return roles[_role].has(_operator);
237   }
238 
239   /**
240    * @dev add a role to an address
241    * @param _operator address
242    * @param _role the name of the role
243    */
244   function addRole(address _operator, string _role)
245     internal
246   {
247     roles[_role].add(_operator);
248     emit RoleAdded(_operator, _role);
249   }
250 
251   /**
252    * @dev remove a role from an address
253    * @param _operator address
254    * @param _role the name of the role
255    */
256   function removeRole(address _operator, string _role)
257     internal
258   {
259     roles[_role].remove(_operator);
260     emit RoleRemoved(_operator, _role);
261   }
262 
263   /**
264    * @dev modifier to scope access to a single role (uses msg.sender as addr)
265    * @param _role the name of the role
266    * // reverts
267    */
268   modifier onlyRole(string _role)
269   {
270     checkRole(msg.sender, _role);
271     _;
272   }
273 
274   /**
275    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
276    * @param _roles the names of the roles to scope access to
277    * // reverts
278    *
279    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
280    *  see: https://github.com/ethereum/solidity/issues/2467
281    */
282   // modifier onlyRoles(string[] _roles) {
283   //     bool hasAnyRole = false;
284   //     for (uint8 i = 0; i < _roles.length; i++) {
285   //         if (hasRole(msg.sender, _roles[i])) {
286   //             hasAnyRole = true;
287   //             break;
288   //         }
289   //     }
290 
291   //     require(hasAnyRole);
292 
293   //     _;
294   // }
295 }
296 
297 /**
298  * @title ERC20Basic
299  * @dev Simpler version of ERC20 interface
300  * See https://github.com/ethereum/EIPs/issues/179
301  */
302 contract ERC20Basic {
303   function totalSupply() public view returns (uint256);
304   function balanceOf(address who) public view returns (uint256);
305   function transfer(address to, uint256 value) public returns (bool);
306   event Transfer(address indexed from, address indexed to, uint256 value);
307 }
308 
309 /**
310  * @title ERC20 interface
311  * @dev see https://github.com/ethereum/EIPs/issues/20
312  */
313 contract ERC20 is ERC20Basic {
314   function allowance(address owner, address spender)
315     public view returns (uint256);
316 
317   function transferFrom(address from, address to, uint256 value)
318     public returns (bool);
319 
320   function approve(address spender, uint256 value) public returns (bool);
321   event Approval(
322     address indexed owner,
323     address indexed spender,
324     uint256 value
325   );
326 }
327 
328 /**
329  * @title Basic token
330  * @dev Basic version of StandardToken, with no allowances.
331  */
332 contract BasicToken is ERC20Basic {
333   using SafeMath for uint256;
334 
335   mapping(address => uint256) internal balances;
336 
337   uint256 internal totalSupply_;
338 
339   /**
340   * @dev Total number of tokens in existence
341   */
342   function totalSupply() public view returns (uint256) {
343     return totalSupply_;
344   }
345 
346   /**
347   * @dev Transfer token for a specified address
348   * @param _to The address to transfer to.
349   * @param _value The amount to be transferred.
350   */
351   function transfer(address _to, uint256 _value) public returns (bool) {
352     require(_value <= balances[msg.sender]);
353     require(_to != address(0));
354 
355     balances[msg.sender] = balances[msg.sender].sub(_value);
356     balances[_to] = balances[_to].add(_value);
357     emit Transfer(msg.sender, _to, _value);
358     return true;
359   }
360 
361   /**
362   * @dev Gets the balance of the specified address.
363   * @param _owner The address to query the the balance of.
364   * @return An uint256 representing the amount owned by the passed address.
365   */
366   function balanceOf(address _owner) public view returns (uint256) {
367     return balances[_owner];
368   }
369 
370 }
371 
372 /**
373  * @title Standard ERC20 token
374  *
375  * @dev Implementation of the basic standard token.
376  * https://github.com/ethereum/EIPs/issues/20
377  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
378  */
379 contract StandardToken is ERC20, BasicToken {
380 
381   mapping (address => mapping (address => uint256)) internal allowed;
382 
383   /**
384    * @dev Transfer tokens from one address to another
385    * @param _from address The address which you want to send tokens from
386    * @param _to address The address which you want to transfer to
387    * @param _value uint256 the amount of tokens to be transferred
388    */
389   function transferFrom(
390     address _from,
391     address _to,
392     uint256 _value
393   )
394     public
395     returns (bool)
396   {
397     require(_value <= balances[_from]);
398     require(_value <= allowed[_from][msg.sender]);
399     require(_to != address(0));
400 
401     balances[_from] = balances[_from].sub(_value);
402     balances[_to] = balances[_to].add(_value);
403     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
404     emit Transfer(_from, _to, _value);
405     return true;
406   }
407 
408   /**
409    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
410    * Beware that changing an allowance with this method brings the risk that someone may use both the old
411    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
412    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
413    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
414    * @param _spender The address which will spend the funds.
415    * @param _value The amount of tokens to be spent.
416    */
417   function approve(address _spender, uint256 _value) public returns (bool) {
418     require(_spender != address(0));
419     allowed[msg.sender][_spender] = _value;
420     emit Approval(msg.sender, _spender, _value);
421     return true;
422   }
423 
424   /**
425    * @dev Function to check the amount of tokens that an owner allowed to a spender.
426    * @param _owner address The address which owns the funds.
427    * @param _spender address The address which will spend the funds.
428    * @return A uint256 specifying the amount of tokens still available for the spender.
429    */
430   function allowance(
431     address _owner,
432     address _spender
433    )
434     public
435     view
436     returns (uint256)
437   {
438     return allowed[_owner][_spender];
439   }
440 
441   /**
442    * @dev Increase the amount of tokens that an owner allowed to a spender.
443    * approve should be called when allowed[_spender] == 0. To increment
444    * allowed value is better to use this function to avoid 2 calls (and wait until
445    * the first transaction is mined)
446    * From MonolithDAO Token.sol
447    * @param _spender The address which will spend the funds.
448    * @param _addedValue The amount of tokens to increase the allowance by.
449    */
450   function increaseApproval(
451     address _spender,
452     uint256 _addedValue
453   )
454     public
455     returns (bool)
456   {
457     require(_spender != address(0));
458     allowed[msg.sender][_spender] = (
459       allowed[msg.sender][_spender].add(_addedValue));
460     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
461     return true;
462   }
463 
464   /**
465    * @dev Decrease the amount of tokens that an owner allowed to a spender.
466    * approve should be called when allowed[_spender] == 0. To decrement
467    * allowed value is better to use this function to avoid 2 calls (and wait until
468    * the first transaction is mined)
469    * From MonolithDAO Token.sol
470    * @param _spender The address which will spend the funds.
471    * @param _subtractedValue The amount of tokens to decrease the allowance by.
472    */
473   function decreaseApproval(
474     address _spender,
475     uint256 _subtractedValue
476   )
477     public
478     returns (bool)
479   {
480     require(_spender != address(0));
481     uint256 oldValue = allowed[msg.sender][_spender];
482     if (_subtractedValue >= oldValue) {
483       allowed[msg.sender][_spender] = 0;
484     } else {
485       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
486     }
487     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
488     return true;
489   }
490 
491 }
492 
493 contract IdaToken is Ownable, RBAC, StandardToken {
494     using AddressUtils for address;
495     using SafeMath for uint256;
496 
497     string public name    = "IDA";
498     string public symbol  = "IDA";
499     uint8 public decimals = 18;
500 
501     // 初始发行量 100 亿
502     uint256 public constant INITIAL_SUPPLY          = 10000000000;
503     // 基石轮额度 3.96 亿
504     uint256 public constant FOOTSTONE_ROUND_AMOUNT  = 396000000;
505     // 私募额度 12 亿
506     uint256 public constant PRIVATE_SALE_AMOUNT     = 1200000000;
507     // 2019/05/01 之前的 Owner 锁仓额度 50 亿
508     uint256 public constant OWNER_LOCKED_IN_COMMON     = 5000000000;
509     // 通用额度 72.04 亿 （IDA 基金会、研发、生态建设、社区建设、运营）
510     uint256 public constant COMMON_PURPOSE_AMOUNT   = 7204000000;
511     // 团队预留额度1 1.2 亿
512     uint256 public constant TEAM_RESERVED_AMOUNT1   = 120000000;
513     // 团队预留额度2 3.6 亿
514     uint256 public constant TEAM_RESERVED_AMOUNT2   = 360000000;
515     // 团队预留额度3 3.6 亿
516     uint256 public constant TEAM_RESERVED_AMOUNT3   = 360000000;
517     // 团队预留额度4 3.6 亿
518     uint256 public constant TEAM_RESERVED_AMOUNT4   = 360000000;
519 
520     // 私募中的 Ether 兑换比率，1 Ether = 10000 IDA
521     uint256 public constant EXCHANGE_RATE_IN_PRIVATE_SALE = 10000;
522 
523     // 2018/10/01 00:00:01 的时间戳常数
524     uint256 public constant TIMESTAMP_OF_20181001000001 = 1538352001;
525     // 2018/10/02 00:00:01 的时间戳常数
526     uint256 public constant TIMESTAMP_OF_20181002000001 = 1538438401;
527     // 2018/11/01 00:00:01 的时间戳常数
528     uint256 public constant TIMESTAMP_OF_20181101000001 = 1541030401;
529     // 2019/02/01 00:00:01 的时间戳常数
530     uint256 public constant TIMESTAMP_OF_20190201000001 = 1548979201;
531     // 2019/05/01 00:00:01 的时间戳常数
532     uint256 public constant TIMESTAMP_OF_20190501000001 = 1556668801;
533     // 2019/08/01 00:00:01 的时间戳常数
534     uint256 public constant TIMESTAMP_OF_20190801000001 = 1564617601;
535     // 2019/11/01 00:00:01 的时间戳常数
536     uint256 public constant TIMESTAMP_OF_20191101000001 = 1572566401;
537     // 2020/11/01 00:00:01 的时间戳常数
538     uint256 public constant TIMESTAMP_OF_20201101000001 = 1604188801;
539     // 2021/11/01 00:00:01 的时间戳常数
540     uint256 public constant TIMESTAMP_OF_20211101000001 = 1635724801;
541 
542     // Role constant of Partner Whitelist
543     string public constant ROLE_PARTNERWHITELIST = "partnerWhitelist";
544     // Role constant of Privatesale Whitelist
545     string public constant ROLE_PRIVATESALEWHITELIST = "privateSaleWhitelist";
546 
547     // 由 Owner 分发的总数额
548     uint256 public totalOwnerReleased;
549     // 所有 partner 的已分发额总数
550     uint256 public totalPartnersReleased;
551     // 所有私募代理人的已分发数额总数
552     uint256 public totalPrivateSalesReleased;
553     // 通用额度的已分发数额总数
554     uint256 public totalCommonReleased;
555     // 团队保留额度的已分发数额总数1
556     uint256 public totalTeamReleased1;
557     // 团队保留额度的已分发数额总数2
558     uint256 public totalTeamReleased2;
559     // 团队保留额度的已分发数额总数3
560     uint256 public totalTeamReleased3;
561     // 团队保留额度的已分发数额总数4
562     uint256 public totalTeamReleased4;
563 
564     // Partner 地址数组
565     address[] private partners;
566     // Partner 地址在数组中索引
567     mapping (address => uint256) private partnersIndex;
568     // 私募代理人地址数组
569     address[] private privateSaleAgents;
570     // 私募代理人地址在数组中的索引
571     mapping (address => uint256) private privateSaleAgentsIndex;
572 
573     // Partner 限额映射
574     mapping (address => uint256) private partnersAmountLimit;
575     // Partner 实际已转账额度映射
576     mapping (address => uint256) private partnersWithdrawed;
577     // 私募代理人实际转出（售出）的 token 数量映射
578     mapping (address => uint256) private privateSalesReleased;
579 
580     // Owner 的钱包地址
581     address ownerWallet;
582 
583     // Log 特定的转账函数操作
584     event TransferLog(address from, address to, bytes32 functionName, uint256 value);
585 
586     /**
587      * @dev 构造函数时需传入 Owner 指定的钱包地址
588      * @param _ownerWallet Owner 的钱包地址
589      */
590     constructor(address _ownerWallet) public {
591         ownerWallet = _ownerWallet;
592         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
593         balances[msg.sender] = totalSupply_;
594     }
595 
596     /**
597      * @dev 变更 Owner 的钱包地址
598      * @param _ownerWallet Owner 的钱包地址
599      */
600     function changeOwnerWallet(address _ownerWallet) public onlyOwner {
601         ownerWallet = _ownerWallet;
602     }
603 
604     /**
605      * @dev 添加 partner 地址到白名单并设置其限额
606      * @param _addr Partner 地址
607      * @param _amount Partner 的持有限额
608      */
609     function addAddressToPartnerWhiteList(address _addr, uint256 _amount)
610         public onlyOwner
611     {
612         // 仅允许在 2018/11/01 00:00:01 之前调用
613         require(block.timestamp < TIMESTAMP_OF_20181101000001);
614         // 如 _addr 不在白名单内，则执行添加处理
615         if (!hasRole(_addr, ROLE_PARTNERWHITELIST)) {
616             addRole(_addr, ROLE_PARTNERWHITELIST);
617             // 把给定地址加入 partner 数组
618             partnersIndex[_addr] = partners.length;
619             partners.push(_addr);
620         }
621         // Owner 可以多次调用此函数以达到修改 partner 授权上限的效果
622         partnersAmountLimit[_addr] = _amount;
623     }
624 
625     /**
626      * @dev 将 partner 地址从白名单移除
627      * @param _addr Partner 地址
628      */
629     function removeAddressFromPartnerWhiteList(address _addr)
630         public onlyOwner
631     {
632         // 仅允许在 2018/11/01 00:00:01 之前调用
633         require(block.timestamp < TIMESTAMP_OF_20181101000001);
634         // 仅允许 _addr 已在白名单内时使用
635         require(hasRole(_addr, ROLE_PARTNERWHITELIST));
636 
637         removeRole(_addr, ROLE_PARTNERWHITELIST);
638         partnersAmountLimit[_addr] = 0;
639         // 把给定地址从 partner 数组中删除
640         uint256 partnerIndex = partnersIndex[_addr];
641         uint256 lastPartnerIndex = partners.length.sub(1);
642         address lastPartner = partners[lastPartnerIndex];
643         partners[partnerIndex] = lastPartner;
644         delete partners[lastPartnerIndex];
645         partners.length--;
646         partnersIndex[_addr] = 0;
647         partnersIndex[lastPartner] = partnerIndex;
648     }
649 
650     /**
651      * @dev 添加私募代理人地址到白名单并设置其限额
652      * @param _addr 私募代理人地址
653      * @param _amount 私募代理人的转账限额
654      */
655     function addAddressToPrivateWhiteList(address _addr, uint256 _amount)
656         public onlyOwner
657     {
658         // 仅允许在 2018/10/02 00:00:01 之前调用
659         require(block.timestamp < TIMESTAMP_OF_20181002000001);
660         // 检查 _addr 是否已在白名单内以保证 approve 函数仅会被调用一次；
661         // 后续如还需要更改授权额度，
662         // 请直接使用安全的 increaseApproval 和 decreaseApproval 函数
663         require(!hasRole(_addr, ROLE_PRIVATESALEWHITELIST));
664 
665         addRole(_addr, ROLE_PRIVATESALEWHITELIST);
666         approve(_addr, _amount);
667         // 把给定地址加入私募代理人数组
668         privateSaleAgentsIndex[_addr] = privateSaleAgents.length;
669         privateSaleAgents.push(_addr);
670     }
671 
672     /**
673      * @dev 将私募代理人地址从白名单移除
674      * @param _addr 私募代理人地址
675      */
676     function removeAddressFromPrivateWhiteList(address _addr)
677         public onlyOwner
678     {
679         // 仅允许在 2018/10/02 00:00:01 之前调用
680         require(block.timestamp < TIMESTAMP_OF_20181002000001);
681         // 仅允许 _addr 已在白名单内时使用
682         require(hasRole(_addr, ROLE_PRIVATESALEWHITELIST));
683 
684         removeRole(_addr, ROLE_PRIVATESALEWHITELIST);
685         approve(_addr, 0);
686         // 把给定地址从私募代理人数组中删除
687         uint256 agentIndex = privateSaleAgentsIndex[_addr];
688         uint256 lastAgentIndex = privateSaleAgents.length.sub(1);
689         address lastAgent = privateSaleAgents[lastAgentIndex];
690         privateSaleAgents[agentIndex] = lastAgent;
691         delete privateSaleAgents[lastAgentIndex];
692         privateSaleAgents.length--;
693         privateSaleAgentsIndex[_addr] = 0;
694         privateSaleAgentsIndex[lastAgent] = agentIndex;
695     }
696 
697     /**
698      * @dev 允许接受转账的 fallback 函数
699      */
700     function() external payable {
701         privateSale(msg.sender);
702     }
703 
704     /**
705      * @dev 私募处理
706      * @param _beneficiary 收取 token 地址
707      */
708     function privateSale(address _beneficiary)
709         public payable onlyRole(ROLE_PRIVATESALEWHITELIST)
710     {
711         // 仅允许 EOA 购买
712         require(msg.sender == tx.origin);
713         require(!msg.sender.isContract());
714         // 仅允许在 2018/10/02 00:00:01 之前购买
715         require(block.timestamp < TIMESTAMP_OF_20181002000001);
716 
717         uint256 purchaseValue = msg.value.mul(EXCHANGE_RATE_IN_PRIVATE_SALE);
718         transferFrom(owner, _beneficiary, purchaseValue);
719     }
720 
721     /**
722      * @dev 人工私募处理
723      * @param _addr 收取 token 地址
724      * @param _amount 转账 token 数量
725      */
726     function withdrawPrivateCoinByMan(address _addr, uint256 _amount)
727         public onlyRole(ROLE_PRIVATESALEWHITELIST)
728     {
729         // 仅允许在 2018/10/02 00:00:01 之前购买
730         require(block.timestamp < TIMESTAMP_OF_20181002000001);
731         // 仅允许 EOA 获得转账
732         require(!_addr.isContract());
733 
734         transferFrom(owner, _addr, _amount);
735     }
736 
737     /**
738      * @dev 私募余额提取
739      * @param _amount 提取 token 数量
740      */
741     function withdrawRemainPrivateCoin(uint256 _amount) public onlyOwner {
742         // 仅允许在 2018/10/01 00:00:01 之后提取
743         require(block.timestamp >= TIMESTAMP_OF_20181001000001);
744         require(transfer(ownerWallet, _amount));
745         emit TransferLog(owner, ownerWallet, bytes32("withdrawRemainPrivateCoin"), _amount);
746     }
747 
748     /**
749      * @dev 私募转账处理(从 Owner 持有的余额中转出)
750      * @param _to 转入地址
751      * @param _amount 转账数量
752      */
753     function _privateSaleTransferFromOwner(address _to, uint256 _amount)
754         private returns (bool)
755     {
756         uint256 newTotalPrivateSaleAmount = totalPrivateSalesReleased.add(_amount);
757         // 检查私募转账总额是否超限
758         require(newTotalPrivateSaleAmount <= PRIVATE_SALE_AMOUNT.mul(10 ** uint256(decimals)));
759 
760         bool result = super.transferFrom(owner, _to, _amount);
761         privateSalesReleased[msg.sender] = privateSalesReleased[msg.sender].add(_amount);
762         totalPrivateSalesReleased = newTotalPrivateSaleAmount;
763         return result;
764     }
765 
766     /**
767      * @dev 合约余额提取
768      */
769     function withdrawFunds() public onlyOwner {
770         ownerWallet.transfer(address(this).balance);
771     }
772 
773     /**
774      * @dev 获取所有 Partner 地址
775      * @return 所有 Partner 地址
776      */
777     function getPartnerAddresses() public onlyOwner view returns (address[]) {
778         return partners;
779     }
780 
781     /**
782      * @dev 获取所有私募代理人地址
783      * @return 所有私募代理人地址
784      */
785     function getPrivateSaleAgentAddresses() public onlyOwner view returns (address[]) {
786         return privateSaleAgents;
787     }
788 
789     /**
790      * @dev 获得私募代理人地址已转出（售出）的 token 数量
791      * @param _addr 私募代理人地址
792      * @return 私募代理人地址的已转出的 token 数量
793      */
794     function privateSaleReleased(address _addr) public view returns (uint256) {
795         return privateSalesReleased[_addr];
796     }
797 
798     /**
799      * @dev 获得 Partner 地址的提取限额
800      * @param _addr Partner 的地址
801      * @return Partner 地址的提取限额
802      */
803     function partnerAmountLimit(address _addr) public view returns (uint256) {
804         return partnersAmountLimit[_addr];
805     }
806 
807     /**
808      * @dev 获得 Partner 地址的已提取 token 数量
809      * @param _addr Partner 的地址
810      * @return Partner 地址的已提取 token 数量
811      */
812     function partnerWithdrawed(address _addr) public view returns (uint256) {
813         return partnersWithdrawed[_addr];
814     }
815 
816     /**
817      * @dev 给 Partner 地址分发 token
818      * @param _addr Partner 的地址
819      * @param _amount 分发的 token 数量
820      */
821     function withdrawToPartner(address _addr, uint256 _amount)
822         public onlyOwner
823     {
824         require(hasRole(_addr, ROLE_PARTNERWHITELIST));
825         // 仅允许在 2018/11/01 00:00:01 之前分发
826         require(block.timestamp < TIMESTAMP_OF_20181101000001);
827 
828         uint256 newTotalReleased = totalPartnersReleased.add(_amount);
829         require(newTotalReleased <= FOOTSTONE_ROUND_AMOUNT.mul(10 ** uint256(decimals)));
830 
831         uint256 newPartnerAmount = balanceOf(_addr).add(_amount);
832         require(newPartnerAmount <= partnersAmountLimit[_addr]);
833 
834         totalPartnersReleased = newTotalReleased;
835         transfer(_addr, _amount);
836         emit TransferLog(owner, _addr, bytes32("withdrawToPartner"), _amount);
837     }
838 
839     /**
840      * @dev 计算 Partner 地址的可提取 token 数量，返回其与 _value 之间较小的那个值
841      * @param _addr Partner 的地址
842      * @param _value 想要提取的 token 数量
843      * @return Partner 地址当前可提取的 token 数量，
844      *         如果 _value 较小，则返回 _value 的数值
845      */
846     function _permittedPartnerTranferValue(address _addr, uint256 _value)
847         private view returns (uint256)
848     {
849         uint256 limit = balanceOf(_addr);
850         uint256 withdrawed = partnersWithdrawed[_addr];
851         uint256 total = withdrawed.add(limit);
852         uint256 time = block.timestamp;
853 
854         require(limit > 0);
855 
856         if (time >= TIMESTAMP_OF_20191101000001) {
857             // 2019/11/01 00:00:01 之后可提取 100%
858             limit = total;
859         } else if (time >= TIMESTAMP_OF_20190801000001) {
860             // 2019/08/01 00:00:01 之后最多提取 75%
861             limit = total.mul(75).div(100);
862         } else if (time >= TIMESTAMP_OF_20190501000001) {
863             // 2019/05/01 00:00:01 之后最多提取 50%
864             limit = total.div(2);
865         } else if (time >= TIMESTAMP_OF_20190201000001) {
866             // 2019/02/01 00:00:01 之后最多提取 25%
867             limit = total.mul(25).div(100);
868         } else {
869             // 2019/02/01 00:00:01 之前不可提取
870             limit = 0;
871         }
872         if (withdrawed >= limit) {
873             limit = 0;
874         } else {
875             limit = limit.sub(withdrawed);
876         }
877         if (_value < limit) {
878             limit = _value;
879         }
880         return limit;
881     }
882 
883     /**
884      * @dev 重写基础合约的 transferFrom 函数
885      */
886     function transferFrom(
887         address _from,
888         address _to,
889         uint256 _value
890     )
891         public
892         returns (bool)
893     {
894         bool result;
895         address sender = msg.sender;
896 
897         if (_from == owner) {
898             if (hasRole(sender, ROLE_PRIVATESALEWHITELIST)) {
899                 // 仅允许在 2018/10/02 00:00:01 之前购买
900                 require(block.timestamp < TIMESTAMP_OF_20181002000001);
901 
902                 result = _privateSaleTransferFromOwner(_to, _value);
903             } else {
904                 revert();
905             }
906         } else {
907             result = super.transferFrom(_from, _to, _value);
908         }
909         return result;
910     }
911 
912     /**
913      * @dev 通用额度提取
914      * @param _amount 提取 token 数量
915      */
916     function withdrawCommonCoin(uint256 _amount) public onlyOwner {
917         // 仅允许在 2018/11/01 00:00:01 之后提取
918         require(block.timestamp >= TIMESTAMP_OF_20181101000001);
919         require(transfer(ownerWallet, _amount));
920         emit TransferLog(owner, ownerWallet, bytes32("withdrawCommonCoin"), _amount);
921         totalCommonReleased = totalCommonReleased.add(_amount);
922     }
923 
924     /**
925      * @dev 团队预留额度1提取
926      * @param _amount 提取 token 数量
927      */
928     function withdrawToTeamStep1(uint256 _amount) public onlyOwner {
929         // 仅允许在 2019/02/01 00:00:01 之后提取
930         require(block.timestamp >= TIMESTAMP_OF_20190201000001);
931         require(transfer(ownerWallet, _amount));
932         emit TransferLog(owner, ownerWallet, bytes32("withdrawToTeamStep1"), _amount);
933         totalTeamReleased1 = totalTeamReleased1.add(_amount);
934     }
935 
936     /**
937      * @dev 团队预留额度2提取
938      * @param _amount 提取 token 数量
939      */
940     function withdrawToTeamStep2(uint256 _amount) public onlyOwner {
941         // 仅允许在 2019/11/01 00:00:01 之后提取
942         require(block.timestamp >= TIMESTAMP_OF_20191101000001);
943         require(transfer(ownerWallet, _amount));
944         emit TransferLog(owner, ownerWallet, bytes32("withdrawToTeamStep2"), _amount);
945         totalTeamReleased2 = totalTeamReleased2.add(_amount);
946     }
947 
948     /**
949      * @dev 团队预留额度3提取
950      * @param _amount 提取 token 数量
951      */
952     function withdrawToTeamStep3(uint256 _amount) public onlyOwner {
953         // 仅允许在 2020/11/01 00:00:01 之后提取
954         require(block.timestamp >= TIMESTAMP_OF_20201101000001);
955         require(transfer(ownerWallet, _amount));
956         emit TransferLog(owner, ownerWallet, bytes32("withdrawToTeamStep3"), _amount);
957         totalTeamReleased3 = totalTeamReleased3.add(_amount);
958     }
959 
960     /**
961      * @dev 团队预留额度4提取
962      * @param _amount 提取 token 数量
963      */
964     function withdrawToTeamStep4(uint256 _amount) public onlyOwner {
965         // 仅允许在 2021/11/01 00:00:01 之后提取
966         require(block.timestamp >= TIMESTAMP_OF_20211101000001);
967         require(transfer(ownerWallet, _amount));
968         emit TransferLog(owner, ownerWallet, bytes32("withdrawToTeamStep4"), _amount);
969         totalTeamReleased4 = totalTeamReleased4.add(_amount);
970     }
971 
972     /**
973      * @dev 重写基础合约的 transfer 函数
974      */
975     function transfer(address _to, uint256 _value) public returns (bool) {
976         bool result;
977         uint256 limit;
978 
979         if (msg.sender == owner) {
980             limit = _ownerReleaseLimit();
981             uint256 newTotalOwnerReleased = totalOwnerReleased.add(_value);
982             require(newTotalOwnerReleased <= limit);
983             result = super.transfer(_to, _value);
984             totalOwnerReleased = newTotalOwnerReleased;
985         } else if (hasRole(msg.sender, ROLE_PARTNERWHITELIST)) {
986             limit = _permittedPartnerTranferValue(msg.sender, _value);
987             if (limit > 0) {
988                 result = super.transfer(_to, limit);
989                 partnersWithdrawed[msg.sender] = partnersWithdrawed[msg.sender].add(limit);
990             } else {
991                 revert();
992             }
993         } else {
994             result = super.transfer(_to, _value);
995         }
996         return result;
997     }
998 
999     /**
1000      * @dev 计算 Owner 的转账额度
1001      * @return Owner 的当前转账额度
1002      */
1003    function _ownerReleaseLimit() private view returns (uint256) {
1004         uint256 time = block.timestamp;
1005         uint256 limit;
1006         uint256 amount;
1007 
1008         // 基石轮额度作为默认限额
1009         limit = FOOTSTONE_ROUND_AMOUNT.mul(10 ** uint256(decimals));
1010         if (time >= TIMESTAMP_OF_20181001000001) {
1011             // 2018/10/1 之后，最大限额需要增加私募剩余额度
1012             amount = PRIVATE_SALE_AMOUNT.mul(10 ** uint256(decimals));
1013             if (totalPrivateSalesReleased < amount) {
1014                 limit = limit.add(amount).sub(totalPrivateSalesReleased);
1015             }
1016         }
1017         if (time >= TIMESTAMP_OF_20181101000001) {
1018             // 2018/11/1 之后，最大限额需要增加通用提取额度中减去锁仓额度以外的额度
1019             limit = limit.add(COMMON_PURPOSE_AMOUNT.sub(OWNER_LOCKED_IN_COMMON).mul(10 ** uint256(decimals)));
1020         }
1021         if (time >= TIMESTAMP_OF_20190201000001) {
1022             // 2019/2/1 之后，最大限额需要增加团队预留额度1
1023             limit = limit.add(TEAM_RESERVED_AMOUNT1.mul(10 ** uint256(decimals)));
1024         }
1025         if (time >= TIMESTAMP_OF_20190501000001) {
1026             // 2019/5/1 之后，最大限额需要增加通用额度中的锁仓额度
1027             limit = limit.add(OWNER_LOCKED_IN_COMMON.mul(10 ** uint256(decimals)));
1028         }
1029         if (time >= TIMESTAMP_OF_20191101000001) {
1030             // 2019/11/1 之后，最大限额需要增加团队预留额度2
1031             limit = limit.add(TEAM_RESERVED_AMOUNT2.mul(10 ** uint256(decimals)));
1032         }
1033         if (time >= TIMESTAMP_OF_20201101000001) {
1034             // 2020/11/1 之后，最大限额需要增加团队预留额度3
1035             limit = limit.add(TEAM_RESERVED_AMOUNT3.mul(10 ** uint256(decimals)));
1036         }
1037         if (time >= TIMESTAMP_OF_20211101000001) {
1038             // 2021/11/1 之后，最大限额需要增加团队预留额度4
1039             limit = limit.add(TEAM_RESERVED_AMOUNT4.mul(10 ** uint256(decimals)));
1040         }
1041         return limit;
1042     }
1043 }