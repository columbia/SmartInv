1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/henry/learning/git/smartContract/truffle/022-sht/contracts-bak/SibbayHealthToken.sol
6 // flattened :  Saturday, 17-Nov-18 06:24:45 UTC
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 }
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     if (a == 0) {
67       return 0;
68     }
69     c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     // uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return a / b;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
96     c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 contract Management is Ownable {
103 
104   /**
105    * 暂停和取消暂停事件
106    * */
107   event Pause();
108   event Unpause();
109 
110   /**
111    * 打开锁定期自动释放事件
112    * 关闭锁定期自动释放事件
113    * 打开强制锁定期自动释放事件
114    * */
115   event OpenAutoFree(address indexed admin, address indexed who);
116   event CloseAutoFree(address indexed admin, address indexed who);
117   event OpenForceAutoFree(address indexed admin, address indexed who);
118 
119   /**
120    * 增加和删除管理员事件
121    * */
122   event AddAdministrator(address indexed admin);
123   event DelAdministrator(address indexed admin);
124 
125   /**
126    * 合约暂停标志, True 暂停，false 未暂停
127    * 锁定余额自动释放开关
128    * 强制锁定余额自动释放开关
129    * 合约管理员
130    * */
131   bool public paused = false;
132   mapping(address => bool) public autoFreeLockBalance;          // false(default) for auto frce, true for not free
133   mapping(address => bool) public forceAutoFreeLockBalance;     // false(default) for not force free, true for froce free
134   mapping(address => bool) public adminList;
135 
136   /**
137    * 构造函数
138    * */
139   constructor() public {
140   }
141 
142   /**
143    * modifier 要求合约正在运行状态
144    */
145   modifier whenNotPaused() {
146     require(!paused);
147     _;
148   }
149 
150   /**
151    * modifier 要求合约暂停状态
152    */
153   modifier whenPaused() {
154     require(paused);
155     _;
156   }
157 
158   /**
159    * 要求是管理员
160    * */
161   modifier whenAdministrator(address who) {
162     require(adminList[who]);
163     _;
164   }
165 
166   /**
167    * 要求不是管理员
168    * */
169   modifier whenNotAdministrator(address who) {
170     require(!adminList[who]);
171     _;
172   }
173 
174   /**
175    * * 暂停合约
176    */
177   function pause() onlyOwner whenNotPaused public {
178     paused = true;
179     emit Pause();
180   }
181 
182   /**
183    * 取消暂停合约
184    */
185   function unpause() onlyOwner whenPaused public {
186     paused = false;
187     emit Unpause();
188   }
189 
190   /**
191    * 打开锁定期自动释放开关
192    * */
193   function openAutoFree(address who) whenAdministrator(msg.sender) public {
194     delete autoFreeLockBalance[who];
195     emit OpenAutoFree(msg.sender, who);
196   }
197 
198   /**
199    * 关闭锁定期自动释放开关
200    * */
201   function closeAutoFree(address who) whenAdministrator(msg.sender) public {
202     autoFreeLockBalance[who] = true;
203     emit CloseAutoFree(msg.sender, who);
204   }
205 
206   /**
207    * 打开强制锁定期自动释放开关
208    * 该开关只能打开，不能关闭
209    * */
210   function openForceAutoFree(address who) onlyOwner public {
211     forceAutoFreeLockBalance[who] = true;
212     emit OpenForceAutoFree(msg.sender, who);
213   }
214 
215   /**
216    * 添加管理员
217    * */
218   function addAdministrator(address who) onlyOwner public {
219     adminList[who] = true;
220     emit AddAdministrator(who);
221   }
222 
223   /**
224    * 删除管理员
225    * */
226   function delAdministrator(address who) onlyOwner public {
227     delete adminList[who];
228     emit DelAdministrator(who);
229   }
230 }
231 
232 contract BasicToken is ERC20Basic {
233   using SafeMath for uint256;
234 
235   /**
236    * 账户总余额
237    * */
238   mapping(address => uint256) balances;
239 
240   /**
241    * 总供应量
242    * */
243   uint256 totalSupply_;
244 
245   /**
246    * 获取总供应量
247    * */
248   function totalSupply() public view returns (uint256) {
249     return totalSupply_;
250   }
251 
252 }
253 
254 contract ERC20 is ERC20Basic {
255   function allowance(address owner, address spender)
256     public view returns (uint256);
257 
258   function transferFrom(address from, address to, uint256 value)
259     public returns (bool);
260 
261   function approve(address spender, uint256 value) public returns (bool);
262   event Approval(
263     address indexed owner,
264     address indexed spender,
265     uint256 value
266   );
267 }
268 
269 contract StandardToken is ERC20, BasicToken {
270 
271   // 记录代理账户
272   // 第一个address是token的所有者，即被代理账户
273   // 第二个address是token的使用者，即代理账户
274   mapping (address => mapping (address => uint256)) internal allowed;
275 
276   // 代理转账事件
277   // spender: 代理
278   // from: token所有者
279   // to: token接收账户
280   // value: token的转账数量
281   event TransferFrom(address indexed spender,
282                      address indexed from,
283                      address indexed to,
284                      uint256 value);
285 
286 
287   /**
288    * 设置代理
289    * _spender 代理账户
290    * _value 代理额度
291    */
292   function approve(address _spender, uint256 _value) public returns (bool) {
293     allowed[msg.sender][_spender] = _value;
294     emit Approval(msg.sender, _spender, _value);
295     return true;
296   }
297 
298   /**
299    * 查询代理额度
300    * _owner token拥有者账户
301    * _spender 代理账户
302    */
303   function allowance(
304     address _owner,
305     address _spender
306    )
307     public
308     view
309     returns (uint256)
310   {
311     return allowed[_owner][_spender];
312   }
313 
314   /**
315    * 提高代理额度
316    * _spender 代理账户
317    * _addValue 需要提高的代理额度
318    */
319   function increaseApproval(
320     address _spender,
321     uint _addedValue
322   )
323     public
324     returns (bool)
325   {
326     allowed[msg.sender][_spender] = (
327       allowed[msg.sender][_spender].add(_addedValue));
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * 降低代理额度
334    * _spender 代理账户
335    * _subtractedValue 降低的代理额度
336    */
337   function decreaseApproval(
338     address _spender,
339     uint _subtractedValue
340   )
341     public
342     returns (bool)
343   {
344     uint oldValue = allowed[msg.sender][_spender];
345     if (_subtractedValue > oldValue) {
346       allowed[msg.sender][_spender] = 0;
347     } else {
348       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
349     }
350     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351     return true;
352   }
353 
354 }
355 
356 contract SibbayHealthToken is StandardToken, Management {
357 
358   string public constant name = "Sibbay Health Token"; // solium-disable-line uppercase
359   string public constant symbol = "SHT"; // solium-disable-line uppercase
360   uint8 public constant decimals = 18; // solium-disable-line uppercase
361 
362   /**
363    * 常量
364    * 单位量, 即1个token有多少wei(假定token的最小单位为wei)
365    * */
366   uint256 constant internal MAGNITUDE = 10 ** uint256(decimals);
367 
368   uint256 public constant INITIAL_SUPPLY = 1000000000 * MAGNITUDE;
369 
370   // 设置赎回价格事件
371   event SetSellPrice(address indexed admin, uint256 price);
372   // 锁定期转账事件
373   event TransferByDate(address indexed from, address indexed to, uint256[] values, uint256[] dates);
374   event TransferFromByDate(address indexed spender, address indexed from, address indexed to, uint256[] values, uint256[] dates);
375   // 关闭赎回事件
376   event CloseSell(address indexed who);
377   // 赎回事件
378   event Sell(address indexed from, address indexed to, uint256 tokenValue, uint256 etherValue);
379   // withdraw 事件
380   event Withdraw(address indexed who, uint256 etherValue);
381   // 添加token到fundAccount账户
382   event AddTokenToFund(address indexed who, address indexed from, uint256 value);
383   // refresh 事件
384   event Refresh(address indexed from, address indexed who);
385 
386   /**
387    * 将锁定期的map做成一个list
388    * value 锁定的余额
389    * _next 下个锁定期的到期时间
390    * */
391   struct Element {
392     uint256 value;
393     uint256 next;
394   }
395 
396   /**
397    * 账户
398    * lockedBalances 锁定余额
399    * lockedElement 锁定期余额
400    * start_date 锁定期最早到期时间
401    * end_date 锁定期最晚到期时间
402    * */
403   struct Account {
404     uint256 lockedBalances;
405     mapping(uint256 => Element) lockedElement;
406     uint256 start_date;
407     uint256 end_date;
408   }
409 
410   /**
411    * 所有账户
412    * */
413   mapping(address => Account) public accounts;
414 
415   /**
416    * sellPrice: token 赎回价格, 即1 token的赎回价格是多少wei(wei为以太币最小单位)
417    * fundAccount: 特殊资金账户，赎回token，接收购买token资金
418    * sellFlag: 赎回标记
419    * */
420   uint256 public sellPrice;
421   address public fundAccount;
422   bool public sellFlag;
423 
424   /**
425    * 需求：owner 每年释放的金额不得超过年初余额的10%
426    * curYear:  当前年初时间
427    * YEAR:  一年365天的时间
428    * vault: owner限制额度
429    * VAULT_FLOOR_VALUE: vault 最低限值
430    * */
431   uint256 public curYear;
432   uint256 constant internal YEAR = 365 * 24 * 3600;
433   uint256 public vault;
434   uint256 constant internal VAULT_FLOOR_VALUE = 10000000 * MAGNITUDE;
435 
436   /**
437    * 合约构造函数
438    * 初始化合约的总供应量
439    */
440   constructor(address _owner, address _fund) public {
441     // 要求_owner, _fund不为0
442     require(_owner != address(0));
443     require(_fund != address(0));
444 
445     // 设置owner, fund
446     owner = _owner;
447     fundAccount = _fund;
448 
449     // 初始化owner是管理员
450     adminList[owner] = true;
451 
452     // 初始化发行量
453     totalSupply_ = INITIAL_SUPPLY;
454     balances[owner] = INITIAL_SUPPLY;
455     emit Transfer(0x0, owner, INITIAL_SUPPLY);
456 
457     /**
458      * 初始化合约属性
459      * 赎回价格
460      * 赎回标记为false
461      * */
462     sellPrice = 0;
463     sellFlag = true;
464 
465     /**
466      * 初始化owner限制额度
467      * 2018/01/01 00:00:00
468      * */
469     vault = totalSupply_.mul(10).div(100);
470     curYear = 1514736000;
471   }
472 
473   /**
474    * fallback函数
475    * */
476   function () external payable {
477   }
478 
479   /**
480    * modifier 要求开启赎回token
481    * */
482   modifier whenOpenSell()
483   {
484     require(sellFlag);
485     _;
486   }
487 
488   /**
489    * modifier 要求关闭赎回token
490    * */
491   modifier whenCloseSell()
492   {
493     require(!sellFlag);
494     _;
495   }
496 
497   /**
498    * 刷新owner限制余额vault
499    * */
500   function refreshVault(address _who, uint256 _value) internal
501   {
502     uint256 balance;
503 
504     // 只对owner操作
505     if (_who != owner)
506       return ;
507     // 记录balance of owner
508     balance = balances[owner];
509     // 如果是新的一年, 则计算vault为当前余额的10%
510     if (now >= (curYear + YEAR))
511     {
512       if (balance <= VAULT_FLOOR_VALUE)
513         vault = balance;
514       else
515         vault = balance.mul(10).div(100);
516       curYear = curYear.add(YEAR);
517     }
518 
519     // vault 必须大于等于 _value
520     require(vault >= _value);
521     vault = vault.sub(_value);
522     return ;
523   }
524 
525   /**
526    * 重新计算到期的锁定期余额, 内部接口
527    * _who: 账户地址
528    * */
529   function refreshlockedBalances(address _who, bool _update) internal returns (uint256)
530   {
531     uint256 tmp_date = accounts[_who].start_date;
532     uint256 tmp_value = accounts[_who].lockedElement[tmp_date].value;
533     uint256 tmp_balances = 0;
534     uint256 tmp_var;
535 
536     // 强制自动释放打开则跳过判断，直接释放锁定期余额
537     if (!forceAutoFreeLockBalance[_who])
538     {
539       // 强制自动释放未打开，则判断自动释放开关
540       if(autoFreeLockBalance[_who])
541       {
542         // 自动释放开关未打开(true), 直接返回0
543         return 0;
544       }
545     }
546 
547     // 锁定期到期
548     while(tmp_date != 0 &&
549           tmp_date <= now)
550     {
551       // 记录到期余额
552       tmp_balances = tmp_balances.add(tmp_value);
553 
554       // 记录 tmp_date
555       tmp_var = tmp_date;
556 
557       // 跳到下一个锁定期
558       tmp_date = accounts[_who].lockedElement[tmp_date].next;
559       tmp_value = accounts[_who].lockedElement[tmp_date].value;
560 
561       // delete 锁定期余额
562       if (_update)
563         delete accounts[_who].lockedElement[tmp_var];
564     }
565 
566     // return expired balance
567     if(!_update)
568       return tmp_balances;
569 
570     // 修改锁定期数据
571     accounts[_who].start_date = tmp_date;
572     accounts[_who].lockedBalances = accounts[_who].lockedBalances.sub(tmp_balances);
573     balances[_who] = balances[_who].add(tmp_balances);
574 
575     // 将最早和最晚时间的标志，都置0，即最初状态
576     if (accounts[_who].start_date == 0)
577         accounts[_who].end_date = 0;
578 
579     return tmp_balances;
580   }
581 
582   /**
583    * 可用余额转账，内部接口
584    * _from token的拥有者
585    * _to token的接收者
586    * _value token的数量
587    * */
588   function transferAvailableBalances(
589     address _from,
590     address _to,
591     uint256 _value
592   )
593     internal
594   {
595     // 检查可用余额
596     require(_value <= balances[_from]);
597 
598     // 修改可用余额
599     balances[_from] = balances[_from].sub(_value);
600     balances[_to] = balances[_to].add(_value);
601 
602     // 触发转账事件
603     if(_from == msg.sender)
604       emit Transfer(_from, _to, _value);
605     else
606       emit TransferFrom(msg.sender, _from, _to, _value);
607   }
608 
609   /**
610    * 锁定余额转账，内部接口
611    * _from token的拥有者
612    * _to token的接收者
613    * _value token的数量
614    * */
615   function transferLockedBalances(
616     address _from,
617     address _to,
618     uint256 _value
619   )
620     internal
621   {
622     // 检查可用余额
623     require(_value <= balances[_from]);
624 
625     // 修改可用余额和锁定余额
626     balances[_from] = balances[_from].sub(_value);
627     accounts[_to].lockedBalances = accounts[_to].lockedBalances.add(_value);
628   }
629 
630   /**
631    * 回传以太币, 内部接口
632    * _from token来源账户
633    * _to token目标账户
634    * _value 为token数目
635    * */
636   function transferEther(
637     address _from,
638     address _to,
639     uint256 _value
640   )
641     internal
642   {
643     /**
644      * 要求 _to 账户接收地址为特殊账户地址
645      * 这里只能为return，不能为revert
646      * 普通转账在这里返回, 不赎回ether
647      * */
648     if (_to != fundAccount)
649         return ;
650 
651     /**
652      * 没有打开赎回功能，不能向fundAccount转账
653      * */
654     require(sellFlag);
655 
656     /**
657      * 赎回价格必须大于0
658      * 赎回的token必须大于0
659      * */
660     require(_value > 0);
661 
662     // 赎回的以太币必须小于账户余额, evalue 单位是wei，即以太币的最小单位
663     uint256 evalue = _value.mul(sellPrice).div(MAGNITUDE);
664     require(evalue <= address(this).balance);
665 
666     // 回传以太币
667     if (evalue > 0)
668     {
669       _from.transfer(evalue);
670       emit Sell(_from, _to, _value, evalue);
671     }
672   }
673 
674   /**
675    * 取回合约上所有的以太币
676    * 只有owner才能取回
677    * */
678   function withdraw() public onlyOwner {
679     uint256 value = address(this).balance;
680     owner.transfer(value);
681     emit Withdraw(msg.sender, value);
682   }
683 
684   /**
685    * 从from账户向fundAccount添加token
686    * */
687   function addTokenToFund(address _from, uint256 _value) 
688     whenNotPaused
689     public
690   {
691     if (_from != msg.sender)
692     {
693       // 检查代理额度
694       require(_value <= allowed[_from][msg.sender]);
695 
696       // 修改代理额度
697       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
698     }
699 
700     // 刷新vault余额
701     refreshVault(_from, _value);
702 
703     // 修改可用账户余额
704     transferAvailableBalances(_from, fundAccount, _value);
705     emit AddTokenToFund(msg.sender, _from, _value);
706   }
707 
708   /**
709    * 转账
710    * */
711   function transfer(
712     address _to,
713     uint256 _value
714   )
715     public
716     whenNotPaused
717     returns (bool)
718   {
719     // 不能给地址0转账
720     require(_to != address(0));
721 
722     /**
723      * 获取到期的锁定期余额
724      * */
725     refreshlockedBalances(msg.sender, true);
726     refreshlockedBalances(_to, true);
727 
728     // 刷新vault余额
729     refreshVault(msg.sender, _value);
730 
731     // 修改可用账户余额
732     transferAvailableBalances(msg.sender, _to, _value);
733 
734     // 回传以太币
735     transferEther(msg.sender, _to, _value);
736 
737     return true;
738   }
739 
740   /**
741    * 代理转账
742    * 代理从 _from 转账 _value 到 _to
743    * */
744   function transferFrom(
745     address _from,
746     address _to,
747     uint256 _value
748   )
749     public
750     whenNotPaused
751     returns (bool)
752   {
753     // 不能向赎回地址发送token
754     require(_to != fundAccount);
755 
756     // 不能向0地址转账
757     require(_to != address(0));
758 
759     /**
760      * 获取到期的锁定期余额
761      * */
762     refreshlockedBalances(_from, true);
763     refreshlockedBalances(_to, true);
764 
765     // 检查代理额度
766     require(_value <= allowed[_from][msg.sender]);
767 
768     // 修改代理额度
769     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
770 
771     // 刷新vault余额
772     refreshVault(_from, _value);
773 
774     // 修改可用账户余额
775     transferAvailableBalances(_from, _to, _value);
776 
777     return true;
778   }
779 
780   /**
781    * 设定代理和代理额度
782    * 设定代理为 _spender 额度为 _value
783    * */
784   function approve(
785     address _spender,
786     uint256 _value
787   )
788     public
789     whenNotPaused
790     returns (bool)
791   {
792     return super.approve(_spender, _value);
793   }
794 
795   /**
796    * 提高代理的代理额度
797    * 提高代理 _spender 的代理额度 _addedValue
798    * */
799   function increaseApproval(
800     address _spender,
801     uint _addedValue
802   )
803     public
804     whenNotPaused
805     returns (bool success)
806   {
807     return super.increaseApproval(_spender, _addedValue);
808   }
809 
810   /**
811    * 降低代理的代理额度
812    * 降低代理 _spender 的代理额度 _subtractedValue
813    * */
814   function decreaseApproval(
815     address _spender,
816     uint _subtractedValue
817   )
818     public
819     whenNotPaused
820     returns (bool success)
821   {
822     return super.decreaseApproval(_spender, _subtractedValue);
823   }
824 
825   /**
826    * 批量转账 token
827    * 批量用户 _receivers
828    * 对应的转账数量 _values
829    * */
830   function batchTransfer(
831     address[] _receivers,
832     uint256[] _values
833   )
834     public
835     whenNotPaused
836   {
837     // 判断接收账号和token数量为一一对应
838     require(_receivers.length > 0 && _receivers.length == _values.length);
839 
840     /**
841      * 获取到期的锁定期余额
842      * */
843     refreshlockedBalances(msg.sender, true);
844 
845     // 判断可用余额足够
846     uint32 i = 0;
847     uint256 total = 0;
848     for (i = 0; i < _values.length; i ++)
849     {
850       total = total.add(_values[i]);
851     }
852     require(total <= balances[msg.sender]);
853 
854     // 刷新vault余额
855     refreshVault(msg.sender, total);
856 
857     // 一一 转账
858     for (i = 0; i < _receivers.length; i ++)
859     {
860       // 不能向赎回地址发送token
861       require(_receivers[i] != fundAccount);
862 
863       // 不能向0地址转账
864       require(_receivers[i] != address(0));
865 
866       refreshlockedBalances(_receivers[i], true);
867       // 修改可用账户余额
868       transferAvailableBalances(msg.sender, _receivers[i], _values[i]);
869     }
870   }
871 
872   /**
873    * 代理批量转账 token
874    * 被代理人 _from
875    * 批量用户 _receivers
876    * 对应的转账数量 _values
877    * */
878   function batchTransferFrom(
879     address _from,
880     address[] _receivers,
881     uint256[] _values
882   )
883     public
884     whenNotPaused
885   {
886     // 判断接收账号和token数量为一一对应
887     require(_receivers.length > 0 && _receivers.length == _values.length);
888 
889     /**
890      * 获取到期的锁定期余额
891      * */
892     refreshlockedBalances(_from, true);
893 
894     // 判断可用余额足够
895     uint32 i = 0;
896     uint256 total = 0;
897     for (i = 0; i < _values.length; i ++)
898     {
899       total = total.add(_values[i]);
900     }
901     require(total <= balances[_from]);
902 
903     // 判断代理额度足够
904     require(total <= allowed[_from][msg.sender]);
905 
906     // 修改代理额度
907     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(total);
908 
909     // 刷新vault余额
910     refreshVault(_from, total);
911 
912     // 一一 转账
913     for (i = 0; i < _receivers.length; i ++)
914     {
915       // 不能向赎回地址发送token
916       require(_receivers[i] != fundAccount);
917 
918       // 不能向0地址转账
919       require(_receivers[i] != address(0));
920 
921       refreshlockedBalances(_receivers[i], true);
922       // 修改可用账户余额
923       transferAvailableBalances(_from, _receivers[i], _values[i]);
924     }
925   }
926 
927   /**
928    * 带有锁定期的转账, 当锁定期到期之后，锁定token数量将转入可用余额
929    * _receiver 转账接收账户
930    * _values 转账数量
931    * _dates 锁定期，即到期时间
932    *        格式：UTC时间，单位秒，即从1970年1月1日开始到指定时间所经历的秒
933    * */
934   function transferByDate(
935     address _receiver,
936     uint256[] _values,
937     uint256[] _dates
938   )
939     public
940     whenNotPaused
941   {
942     // 判断接收账号和token数量为一一对应
943     require(_values.length > 0 &&
944         _values.length == _dates.length);
945 
946     // 不能向赎回地址发送token
947     require(_receiver != fundAccount);
948 
949     // 不能向0地址转账
950     require(_receiver != address(0));
951 
952     /**
953      * 获取到期的锁定期余额
954      * */
955     refreshlockedBalances(msg.sender, true);
956     refreshlockedBalances(_receiver, true);
957 
958     // 判断可用余额足够
959     uint32 i = 0;
960     uint256 total = 0;
961     for (i = 0; i < _values.length; i ++)
962     {
963       total = total.add(_values[i]);
964     }
965     require(total <= balances[msg.sender]);
966 
967     // 刷新vault余额
968     refreshVault(msg.sender, total);
969 
970     // 转账
971     for(i = 0; i < _values.length; i ++)
972     {
973       transferByDateSingle(msg.sender, _receiver, _values[i], _dates[i]);
974     }
975 
976     emit TransferByDate(msg.sender, _receiver, _values, _dates);
977   }
978 
979   /**
980    * 代理带有锁定期的转账, 当锁定期到期之后，锁定token数量将转入可用余额
981    * _from 被代理账户
982    * _receiver 转账接收账户
983    * _values 转账数量
984    * _dates 锁定期，即到期时间
985    *        格式：UTC时间，单位秒，即从1970年1月1日开始到指定时间所经历的秒
986    * */
987   function transferFromByDate(
988     address _from,
989     address _receiver,
990     uint256[] _values,
991     uint256[] _dates
992   )
993     public
994     whenNotPaused
995   {
996     // 判断接收账号和token数量为一一对应
997     require(_values.length > 0 &&
998         _values.length == _dates.length);
999 
1000     // 不能向赎回地址发送token
1001     require(_receiver != fundAccount);
1002 
1003     // 不能向0地址转账
1004     require(_receiver != address(0));
1005 
1006     /**
1007      * 获取到期的锁定期余额
1008      * */
1009     refreshlockedBalances(_from, true);
1010     refreshlockedBalances(_receiver, true);
1011 
1012     // 判断可用余额足够
1013     uint32 i = 0;
1014     uint256 total = 0;
1015     for (i = 0; i < _values.length; i ++)
1016     {
1017       total = total.add(_values[i]);
1018     }
1019     require(total <= balances[_from]);
1020 
1021     // 判断代理额度足够
1022     require(total <= allowed[_from][msg.sender]);
1023 
1024     // 修改代理额度
1025     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(total);
1026 
1027     // 刷新vault余额
1028     refreshVault(_from, total);
1029 
1030     // 转账
1031     for(i = 0; i < _values.length; i ++)
1032     {
1033       transferByDateSingle(_from, _receiver, _values[i], _dates[i]);
1034     }
1035 
1036     emit TransferFromByDate(msg.sender, _from, _receiver, _values, _dates);
1037   }
1038 
1039   /**
1040    * _from token拥有者
1041    * _to 转账接收账户
1042    * _value 转账数量
1043    * _date 锁定期，即到期时间
1044    *       格式：UTC时间，单位秒，即从1970年1月1日开始到指定时间所经历的秒
1045    * */
1046   function transferByDateSingle(
1047     address _from,
1048     address _to,
1049     uint256 _value,
1050     uint256 _date
1051   )
1052     internal
1053   {
1054     uint256 start_date = accounts[_to].start_date;
1055     uint256 end_date = accounts[_to].end_date;
1056     uint256 tmp_var = accounts[_to].lockedElement[_date].value;
1057     uint256 tmp_date;
1058 
1059     if (_value == 0)
1060     {
1061         // 不做任何处理
1062         return ;
1063     }
1064 
1065     if (_date <= now)
1066     {
1067       // 到期时间比当前早，直接转入可用余额
1068       // 修改可用账户余额
1069       transferAvailableBalances(_from, _to, _value);
1070 
1071       return ;
1072     }
1073 
1074     if (start_date == 0)
1075     {
1076       // 还没有收到过锁定期转账
1077       // 最早时间和最晚时间一样
1078       accounts[_to].start_date = _date;
1079       accounts[_to].end_date = _date;
1080       accounts[_to].lockedElement[_date].value = _value;
1081     }
1082     else if (tmp_var > 0)
1083     {
1084       // 收到过相同的锁定期
1085       accounts[_to].lockedElement[_date].value = tmp_var.add(_value);
1086     }
1087     else if (_date < start_date)
1088     {
1089       // 锁定期比最早到期的还早
1090       // 添加锁定期，并加入到锁定期列表
1091       accounts[_to].lockedElement[_date].value = _value;
1092       accounts[_to].lockedElement[_date].next = start_date;
1093       accounts[_to].start_date = _date;
1094     }
1095     else if (_date > end_date)
1096     {
1097       // 锁定期比最晚到期还晚
1098       // 添加锁定期，并加入到锁定期列表
1099       accounts[_to].lockedElement[_date].value = _value;
1100       accounts[_to].lockedElement[end_date].next = _date;
1101       accounts[_to].end_date = _date;
1102     }
1103     else
1104     {
1105       /**
1106        * 锁定期在 最早和最晚之间
1107        * 首先找到插入的位置
1108        * 然后在插入的位置插入数据
1109        * tmp_var 即 tmp_next
1110        * */
1111       tmp_date = start_date;
1112       tmp_var = accounts[_to].lockedElement[tmp_date].next;
1113       while(tmp_var < _date)
1114       {
1115         tmp_date = tmp_var;
1116         tmp_var = accounts[_to].lockedElement[tmp_date].next;
1117       }
1118 
1119       // 记录锁定期并加入列表
1120       accounts[_to].lockedElement[_date].value = _value;
1121       accounts[_to].lockedElement[_date].next = tmp_var;
1122       accounts[_to].lockedElement[tmp_date].next = _date;
1123     }
1124 
1125     // 锁定期转账
1126     transferLockedBalances(_from, _to, _value);
1127 
1128     return ;
1129   }
1130 
1131   /**
1132    * sell tokens
1133    * */
1134   function sell(uint256 _value) public whenOpenSell whenNotPaused {
1135     transfer(fundAccount, _value);
1136   }
1137 
1138   /**
1139    * 设置token赎回价格
1140    * */
1141   function setSellPrice(uint256 price) public whenAdministrator(msg.sender) {
1142     require(price > 0);
1143     sellPrice = price;
1144 
1145     emit SetSellPrice(msg.sender, price);
1146   }
1147 
1148   /**
1149    * 关闭购买赎回token
1150    * */
1151   function closeSell() public whenOpenSell onlyOwner {
1152     sellFlag = false;
1153     emit CloseSell(msg.sender);
1154   }
1155 
1156   /**
1157    * 重新计算账号的lockbalance
1158    * */
1159   function refresh(address _who) public whenNotPaused {
1160     refreshlockedBalances(_who, true);
1161     emit Refresh(msg.sender, _who);
1162   }
1163 
1164   /**
1165    * 查询账户可用余额
1166    * */
1167   function availableBalanceOf(address _owner) public view returns (uint256) {
1168     return (balances[_owner] + refreshlockedBalances(_owner, false));
1169   }
1170 
1171   /**
1172    * 查询账户总余额
1173    * */
1174   function balanceOf(address _owner) public view returns (uint256) {
1175     return balances[_owner] + accounts[_owner].lockedBalances;
1176   }
1177 
1178   /**
1179    * 获取锁定余额
1180    * */
1181   function lockedBalanceOf(address _who) public view returns (uint256) {
1182     return (accounts[_who].lockedBalances - refreshlockedBalances(_who, false));
1183   }
1184 
1185   /**
1186    * 根据日期获取锁定余额
1187    * 返回：锁定余额，下一个锁定期
1188    * */
1189   function lockedBalanceOfByDate(address _who, uint256 date) public view returns (uint256, uint256) {
1190     return (accounts[_who].lockedElement[date].value, accounts[_who].lockedElement[date].next);
1191   }
1192 
1193 }