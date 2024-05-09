1 pragma solidity ^0.4.24;
2 
3 
4 contract Ownable {
5 
6   address public owner;
7   
8   mapping(address => uint8) public operators;
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   constructor() 
13     public {
14     owner = msg.sender;
15   }
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the operator
27    */
28   modifier onlyOperator() {
29     require(operators[msg.sender] == uint8(1)); 
30     _;
31   }
32 
33   /**
34    * @dev operator management
35    */
36   function operatorManager(address[] _operators,uint8 flag) 
37     public 
38     onlyOwner 
39     returns(bool){
40       for(uint8 i = 0; i< _operators.length; i++) {
41         if(flag == uint8(0)){
42           operators[_operators[i]] = 1;
43         } else {
44           delete operators[_operators[i]];
45         }
46       }
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) 
54     public onlyOwner {
55     require(newOwner != address(0));
56     owner = newOwner;
57     emit OwnershipTransferred(owner, newOwner);
58   }
59 
60 }
61 
62 
63 /**
64  * @title Pausable
65  * @dev Base contract which allows children to implement an emergency stop mechanism.
66  */
67 contract Pausable is Ownable {
68 
69   event Pause();
70 
71   event Unpause();
72 
73   bool public paused = false;
74 
75   /**
76    * @dev modifier to allow actions only when the contract IS paused
77    */
78   modifier whenNotPaused() {
79     require(!paused);
80     _;
81   }
82 
83   /**
84    * @dev modifier to allow actions only when the contract IS NOT paused
85    */
86   modifier whenPaused {
87     require(paused);
88     _;
89   }
90 
91   /**
92    * @dev called by the owner to pause, triggers stopped state
93    */
94   function pause() public onlyOwner whenNotPaused 
95     returns (bool) {
96     paused = true;
97     emit Pause();
98     return true;
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() public onlyOwner whenPaused 
105     returns (bool) {
106     paused = false;
107     emit Unpause();
108     return true;
109   }
110 }
111 
112 
113 // ERC20 Token
114 contract ERC20Token {
115 
116     function balanceOf(address _owner) constant public returns (uint256);
117 
118     function transfer(address _to, uint256 _value) public returns (bool);
119 
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121 }
122 
123 
124 /**
125  *  预测事件合约对象 
126  *  @author linq <1018053166@qq.com>
127  */
128 contract GuessBaseBiz is Pausable {
129     
130   // MOS合约地址 
131   address public mosContractAddress = 0x420a43153DA24B9e2aedcEC2B8158A8653a3317e;
132   // 平台地址
133   address public platformAddress = 0xe0F969610699f88612518930D88C0dAB39f67985;
134   // 平台手续费
135   uint256 public serviceChargeRate = 5;
136   // 平台维护费
137   uint256 public maintenanceChargeRate = 0;
138   // 单次上限
139   uint256 public upperLimit = 1000 * 10 ** 18;
140   // 单次下限
141   uint256 public lowerLimit = 1 * 10 ** 18;
142   
143   
144   ERC20Token MOS;
145   
146   // =============================== Event ===============================
147     
148   // 创建预测事件成功后广播
149   event CreateGuess(uint256 indexed id, address indexed creator);
150 
151 //   直投事件
152 //   event Deposit(uint256 indexed id,address indexed participant,uint256 optionId,uint256 bean);
153 
154   // 代投事件  
155   event DepositAgent(address indexed participant, uint256 indexed id, uint256 optionId, uint256 totalBean);
156 
157   // 公布选项事件 
158   event PublishOption(uint256 indexed id, uint256 indexed optionId, uint256 odds);
159 
160   // 预测事件流拍事件
161   event Abortive(uint256 indexed id);
162   
163   constructor() public {
164       MOS = ERC20Token(mosContractAddress);
165   }
166 
167   struct Guess {
168     // 预测事件ID
169     uint256 id;
170     // 预测事件创建者
171     address creator;
172     // 预测标题
173     string title;
174     // 数据源名称+数据源链接
175     string source;
176     // 预测事件分类
177     string category;
178     // 是否下架 1.是 0.否
179     uint8 disabled;
180     // 预测事件描述
181     bytes desc;
182     // 开始时间
183     uint256 startAt;
184     // 封盘时间  
185     uint256 endAt; 
186     // 是否结束
187     uint8 finished; 
188     // 是否流拍
189     uint8 abortive; 
190     // // 选项ID
191     // uint256[] optionIds;
192     // // 选项名称
193     // bytes32[] optionNames;
194   }
195 
196 //   // 订单
197 //   struct Order {
198 //     address user;
199 //     uint256 bean;
200 //   }
201 
202   // 平台代理订单
203   struct AgentOrder {
204     address participant;
205     string ipfsBase58;
206     string dataHash;
207     uint256 bean;
208   }
209   
210   struct Option {
211     // 选项ID
212     uint256 id;
213     // 选项名称
214     bytes32 name;
215   } 
216   
217 
218   // 存储所有的预测事件
219   mapping (uint256 => Guess) public guesses;
220   // 存储所有的预测事件选项 
221   mapping (uint256 => Option[]) public options;
222 
223   // 存储所有用户直投订单
224 //   mapping (uint256 => mapping(uint256 => Order[])) public orders;
225 
226   // 通过预测事件ID和选项ID，存储该选项所有参与的地址
227   mapping (uint256 => mapping (uint256 => AgentOrder[])) public agentOrders;
228   
229   // 存储事件总投注 
230   mapping (uint256 => uint256) public guessTotalBean;
231   
232   // 存储某选项总投注 
233   mapping (uint256 => mapping(uint256 => uint256)) public optionTotalBean;
234 
235   // 存储某选项某用户总投注 
236 //   mapping (uint256 => mapping(address => uint256)) public userOptionTotalBean;
237 
238   /**
239    * 预测事件状态
240    */
241   enum GuessStatus {
242     // 未开始
243     NotStarted, 
244     // 进行中
245     Progress,
246     // 待公布
247     Deadline,
248     // 已结束
249     Finished,
250     // 流拍
251     Abortive
252   }
253 
254   // 判断是否为禁用状态
255   function disabled(uint256 id) public view returns(bool) {
256       if(guesses[id].disabled == 0){
257           return false;
258       }else {
259           return true;
260       }
261   }
262 
263  /**
264    * 获取预测事件状态
265    * 
266    * 未开始
267    *     未到开始时间
268    * 进行中
269    *     在开始到结束时间范围内
270    * 待公布/已截止
271    *     已经过了结束时间，并且finished为0
272    * 已结束
273    *     已经过了结束时间，并且finished为1,abortive=0
274    * 流拍
275    *     abortive=1，并且finished为1 流拍。（退币）
276    */
277   function getGuessStatus(uint256 guessId) 
278     internal 
279     view
280     returns(GuessStatus) {
281       GuessStatus gs;
282       Guess memory guess = guesses[guessId];
283       uint256 _now = now; 
284       if(guess.startAt > _now) {
285         gs = GuessStatus.NotStarted;
286       } else if((guess.startAt <= _now && _now <= guess.endAt)
287                  && guess.finished == 0 
288                  && guess.abortive == 0 ) {
289         gs = GuessStatus.Progress;
290       } else if(_now > guess.endAt && guess.finished == 0) {
291         gs = GuessStatus.Deadline;
292       } else if(_now > guess.endAt && guess.finished == 1 && guess.abortive == 0) {
293         gs = GuessStatus.Finished;  
294       } else if(guess.abortive == 1 && guess.finished == 1){
295         gs = GuessStatus.Abortive; 
296       }
297     return gs;
298   }
299   
300   //判断选项是否存在
301   function optionExist(uint256 guessId,uint256 optionId)
302     internal
303     view
304     returns(bool){
305       Option[] memory _options = options[guessId];
306       for (uint8 i = 0; i < _options.length; i++) {
307          if(optionId == _options[i].id){
308             return true;
309          }
310       }
311       return false;
312   }
313     
314   function() public payable {
315   }
316 
317   /**
318    * 修改预测系统变量
319    * @author linq
320    */
321   function modifyVariable
322     (
323         address _platformAddress, 
324         uint256 _serviceChargeRate, 
325         uint256 _maintenanceChargeRate,
326         uint256 _upperLimit,
327         uint256 _lowerLimit
328     ) 
329     public 
330     onlyOwner {
331       platformAddress = _platformAddress;
332       serviceChargeRate = _serviceChargeRate;
333       maintenanceChargeRate = _maintenanceChargeRate;
334       upperLimit = _upperLimit * 10 ** 18;
335       lowerLimit = _lowerLimit * 10 ** 18;
336   }
337   
338    // 创建预测事件
339   function createGuess(
340        uint256 _id, 
341        string _title,
342        string _source, 
343        string _category,
344        uint8 _disabled,
345        bytes _desc, 
346        uint256 _startAt, 
347        uint256 _endAt,
348        uint256[] _optionId, 
349        bytes32[] _optionName
350        ) 
351        public 
352        whenNotPaused {
353         require(guesses[_id].id == uint256(0), "The current guess already exists !!!");
354         require(_optionId.length == _optionName.length, "please check options !!!");
355         
356         guesses[_id] = Guess(_id,
357               msg.sender,
358               _title,
359               _source,
360               _category,
361               _disabled,
362               _desc,
363               _startAt,
364               _endAt,
365               0,
366               0
367             );
368             
369         Option[] storage _options = options[_id];
370         for (uint8 i = 0;i < _optionId.length; i++) {
371             require(!optionExist(_id,_optionId[i]),"The current optionId already exists !!!");
372             _options.push(Option(_optionId[i],_optionName[i]));
373         }
374     
375     emit CreateGuess(_id, msg.sender);
376   }
377 
378 
379     /**
380      * 审核|更新预测事件
381      */
382     function auditGuess
383     (
384         uint256 _id,
385         string _title,
386         uint8 _disabled,
387         bytes _desc, 
388         uint256 _endAt) 
389         public 
390         onlyOwner
391     {
392         require(guesses[_id].id != uint256(0), "The current guess not exists !!!");
393         require(getGuessStatus(_id) == GuessStatus.NotStarted, "The guess cannot audit !!!");
394         Guess storage guess = guesses[_id];
395         guess.title = _title;
396         guess.disabled = _disabled;
397         guess.desc = _desc;
398         guess.endAt = _endAt;
399    }
400 
401   /**
402    * 用户直接参与事件预测
403    */ 
404 //   function deposit(uint256 id, uint256 optionId, uint256 bean) 
405 //     public
406 //     payable
407 //     whenNotPaused
408 //     returns (bool) {
409 //       require(!disabled(id), "The guess disabled!!!");
410 //       require(getGuessStatus(id) == GuessStatus.Progress, "The guess cannot participate !!!");
411 //       require(bean >= lowerLimit && bean <= upperLimit, "Bean quantity nonconformity!!!");
412       
413 //       // 存储用户订单
414 //       Order memory order = Order(msg.sender, bean);
415 //       orders[id][optionId].push(order);
416 //       // 某用户订单该选项总投注数
417 //       userOptionTotalBean[optionId][msg.sender] += bean;
418 //       // 存储事件总投注
419 //       guessTotalBean[id] += bean;
420 //       MOS.transferFrom(msg.sender, address(this), bean);
421     
422 //       emit Deposit(id, msg.sender, optionId, bean);
423 //       return true;
424 //   }
425 
426    /**
427     * 平台代理用户参与事件预测
428     */
429   function depositAgent
430   (
431       uint256 id, 
432       uint256 optionId, 
433       string ipfsBase58,
434       string dataHash,
435       uint256 totalBean
436   ) 
437     public
438     onlyOperator
439     whenNotPaused
440     returns (bool) {
441     require(guesses[id].id != uint256(0), "The current guess not exists !!!");
442     require(optionExist(id, optionId),"The current optionId not exists !!!");
443     require(!disabled(id), "The guess disabled!!!");
444     require(getGuessStatus(id) == GuessStatus.Deadline, "The guess cannot participate !!!");
445     
446     // 通过预测事件ID和选项ID，存储该选项所有参与的地址
447     AgentOrder[] storage _agentOrders = agentOrders[id][optionId];
448     
449      AgentOrder memory agentOrder = AgentOrder(msg.sender,ipfsBase58,dataHash,totalBean);
450     _agentOrders.push(agentOrder);
451    
452     MOS.transferFrom(msg.sender, address(this), totalBean);
453     
454     // 某用户订单该选项总投注数
455     // userOptionTotalBean[optionId][msg.sender] += totalBean;
456     // 订单选项总投注 
457     optionTotalBean[id][optionId] += totalBean;
458     // 存储事件总投注
459     guessTotalBean[id] += totalBean;
460     
461     emit DepositAgent(msg.sender, id, optionId, totalBean);
462     return true;
463   }
464   
465 
466     /**
467      * 公布事件的结果
468      */ 
469     function publishOption(uint256 id, uint256 optionId) 
470       public 
471       onlyOwner
472       whenNotPaused
473       returns (bool) {
474       require(guesses[id].id != uint256(0), "The current guess not exists !!!");
475       require(optionExist(id, optionId),"The current optionId not exists !!!");
476       require(!disabled(id), "The guess disabled!!!");
477       require(getGuessStatus(id) == GuessStatus.Deadline, "The guess cannot publish !!!");
478       Guess storage guess = guesses[id];
479       guess.finished = 1;
480       // 该预测时间总投注 
481       uint256 totalBean = guessTotalBean[id];
482       // 成功选项投注总数
483       uint256 _optionTotalBean = optionTotalBean[id][optionId];
484       // 判断是否低赔率事件
485       uint256 odds = totalBean * (100 - serviceChargeRate - maintenanceChargeRate) / _optionTotalBean;
486       
487       AgentOrder[] memory _agentOrders = agentOrders[id][optionId];
488       if(odds >= uint256(100)){
489         // 平台收取手续费
490         uint256 platformFee = totalBean * (serviceChargeRate + maintenanceChargeRate) / 100;
491         MOS.transfer(platformAddress, platformFee);
492         
493         for(uint8 i = 0; i< _agentOrders.length; i++){
494             MOS.transfer(_agentOrders[i].participant, (totalBean - platformFee) 
495                         * _agentOrders[i].bean 
496                         / _optionTotalBean);
497         }
498       } else {
499         // 低赔率事件，平台不收取手续费
500         for(uint8 j = 0; j< _agentOrders.length; j++){
501             MOS.transfer(_agentOrders[j].participant, totalBean
502                         * _agentOrders[j].bean
503                         / _optionTotalBean);
504         }
505       }
506 
507       emit PublishOption(id, optionId, odds);
508       return true;
509     }
510     
511     
512     /**
513      * 事件流拍
514      */
515     function abortive(uint256 id) 
516         public 
517         onlyOwner
518         returns(bool) {
519         require(guesses[id].id != uint256(0), "The current guess not exists !!!");
520         require(getGuessStatus(id) == GuessStatus.Progress ||
521                 getGuessStatus(id) == GuessStatus.Deadline, "The guess cannot abortive !!!");
522     
523         Guess storage guess = guesses[id];
524         guess.abortive = 1;
525         guess.finished = 1;
526         // 退回
527         Option[] memory _options = options[id];
528         
529         for(uint8 i = 0; i< _options.length;i ++){
530             //代投退回
531             AgentOrder[] memory _agentOrders = agentOrders[id][_options[i].id];
532             for(uint8 j = 0; j < _agentOrders.length; j++){
533                 uint256 _bean = _agentOrders[j].bean;
534                 MOS.transfer(_agentOrders[j].participant, _bean);
535             }
536         }
537         emit Abortive(id);
538         return true;
539     }
540     
541     // /**
542     //  * 获取事件投注总额 
543     //  */ 
544     // function guessTotalBeanOf(uint256 id) public view returns(uint256){
545     //     return guessTotalBean[id];
546     // }
547     
548     // /**
549     //  * 获取事件选项代投订单信息
550     //  */ 
551     // function agentOrdersOf(uint256 id,uint256 optionId) 
552     //     public 
553     //     view 
554     //     returns(
555     //         address participant,
556     //         address[] users,
557     //         uint256[] beans
558     //     ) {
559     //     AgentOrder[] memory agentOrder = agentOrders[id][optionId];
560     //     return (
561     //         agentOrder.participant, 
562     //         agentOrder.users, 
563     //         agentOrder.beans
564     //     );
565     // }
566     
567     
568     // /**
569     //  * 获取用户直投订单 
570     //  */ 
571     // function ordersOf(uint256 id, uint256 optionId) public view 
572     //     returns(address[] users,uint256[] beans){
573     //     Order[] memory _orders = orders[id][optionId];
574     //     address[] memory _users;
575     //     uint256[] memory _beans;
576         
577     //     for (uint8 i = 0; i < _orders.length; i++) {
578     //         _users[i] = _orders[i].user;
579     //         _beans[i] = _orders[i].bean;
580     //     }
581     //     return (_users, _beans);
582     // }
583 
584 }
585 
586 
587 contract MosesContract is GuessBaseBiz {
588 //   // MOS合约地址 
589 //   address internal INITIAL_MOS_CONTRACT_ADDRESS = 0x001439818dd11823c45fff01af0cd6c50934e27ac0;
590 //   // 平台地址
591 //   address internal INITIAL_PLATFORM_ADDRESS = 0x00063150d38ac0b008abe411ab7e4fb8228ecead3e;
592 //   // 平台手续费
593 //   uint256 internal INITIAL_SERVICE_CHARGE_RATE = 5;
594 //   // 平台维护费
595 //   uint256 internal INITIAL_MAINTENANCE_CHARGE_RATE = 0;
596 //   // 单次上限
597 //   uint256 UPPER_LIMIT = 1000 * 10 ** 18;
598 //   // 单次下限
599 //   uint256 LOWER_LIMIT = 1 * 10 ** 18;
600   
601   
602   constructor(address[] _operators) public {
603     for(uint8 i = 0; i< _operators.length; i++) {
604         operators[_operators[i]] = uint8(1);
605     }
606   }
607 
608     /**
609      *  Recovery donated ether
610      */
611     function collectEtherBack(address collectorAddress) public onlyOwner {
612         uint256 b = address(this).balance;
613         require(b > 0);
614         require(collectorAddress != 0x0);
615 
616         collectorAddress.transfer(b);
617     }
618 
619     /**
620     *  Recycle other ERC20 tokens
621     */
622     function collectOtherTokens(address tokenContract, address collectorAddress) onlyOwner public returns (bool) {
623         ERC20Token t = ERC20Token(tokenContract);
624 
625         uint256 b = t.balanceOf(address(this));
626         return t.transfer(collectorAddress, b);
627     }
628 
629 }