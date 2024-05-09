1 pragma solidity ^0.4.23;
2 /*
3  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐
4  *             ║ ║├┤ ├┤ ││  │├─┤│   │ KOL Community Foundation│ │ ║║║├┤ ├┴┐╚═╗│ │ ├┤
5  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘
6  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
7  *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │
8  *   └────┤ Dev:Jack Koe ├─────────────┤ Special for: KOL  ├───────────────┤ 20200513   ├──┘
9  *        └─────────────────────────────────────────────────────────────────────────────┘
10  */
11 
12  library SafeMath {
13    function mul(uint a, uint b) internal pure  returns (uint) {
14      uint c = a * b;
15      require(a == 0 || c / a == b);
16      return c;
17    }
18    function div(uint a, uint b) internal pure returns (uint) {
19      require(b > 0);
20      uint c = a / b;
21      require(a == b * c + a % b);
22      return c;
23    }
24    function sub(uint a, uint b) internal pure returns (uint) {
25      require(b <= a);
26      return a - b;
27    }
28    function add(uint a, uint b) internal pure returns (uint) {
29      uint c = a + b;
30      require(c >= a);
31      return c;
32    }
33    function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
34      return a >= b ? a : b;
35    }
36    function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
37      return a < b ? a : b;
38    }
39    function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
40      return a >= b ? a : b;
41    }
42    function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
43      return a < b ? a : b;
44    }
45  }
46 
47  /**
48   * title KOL Promotion contract
49   * dev visit: https://github.com/jackoelv/KOL/
50  */
51 
52  contract ERC20Basic {
53    uint public totalSupply;
54    function balanceOf(address who) public constant returns (uint);
55    function transfer(address to, uint value) public;
56    event Transfer(address indexed from, address indexed to, uint value);
57  }
58 
59  contract ERC20 is ERC20Basic {
60    function allowance(address owner, address spender) public constant returns (uint);
61    function transferFrom(address from, address to, uint value) public;
62    function approve(address spender, uint value) public;
63    event Approval(address indexed owner, address indexed spender, uint value);
64  }
65 
66  /**
67   * title KOL Promotion contract
68   * dev visit: https://github.com/jackoelv/KOL/
69  */
70 
71  contract BasicToken is ERC20Basic {
72 
73    using SafeMath for uint;
74 
75    mapping(address => uint) balances;
76 
77    function transfer(address _to, uint _value) public{
78      balances[msg.sender] = balances[msg.sender].sub(_value);
79      balances[_to] = balances[_to].add(_value);
80      emit Transfer(msg.sender, _to, _value);
81    }
82 
83    function balanceOf(address _owner) public constant returns (uint balance) {
84      return balances[_owner];
85    }
86  }
87 
88  /**
89   * title KOL Promotion contract
90   * dev visit: https://github.com/jackoelv/KOL/
91  */
92 
93  contract StandardToken is BasicToken, ERC20 {
94    mapping (address => mapping (address => uint)) allowed;
95    uint256 public userSupplyed;
96 
97    function transferFrom(address _from, address _to, uint _value) public {
98      balances[_to] = balances[_to].add(_value);
99      balances[_from] = balances[_from].sub(_value);
100      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101      emit Transfer(_from, _to, _value);
102    }
103 
104    function approve(address _spender, uint _value) public{
105      require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
106      allowed[msg.sender][_spender] = _value;
107      emit Approval(msg.sender, _spender, _value);
108    }
109 
110    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
111      return allowed[_owner][_spender];
112    }
113  }
114  contract KOL is StandardToken {
115  }
116 
117  /**
118   * title KOL Promotion contract
119   * dev visit: https://github.com/jackoelv/KOL/
120  */
121 
122  contract Ownable {
123      address public owner;
124 
125      constructor() public{
126          owner = msg.sender;
127      }
128 
129      modifier onlyOwner {
130          require(msg.sender == owner);
131          _;
132      }
133      function transferOwnership(address newOwner) onlyOwner public{
134          if (newOwner != address(0)) {
135              owner = newOwner;
136          }
137      }
138  }
139  /**
140   * title KOL Promotion contract
141   * dev visit: https://github.com/jackoelv/KOL/
142  */
143 contract KOLPro is Ownable{
144   using SafeMath for uint256;
145   string public name = "KOL Promotion";
146   KOL public kol;
147   address public draw;
148   address private receiver;
149 
150   uint256 public begin;
151   uint256 public end;
152 
153   uint256 public iCode;
154   uint256 public every = 1 days;
155   uint256 public totalRegister;
156   uint256 public totalBalance;
157 
158   uint8 public  userLevel1 = 20;
159   uint8 public  userLevel2 = 10;
160   uint8 public maxlevel = 9;
161 
162   uint16 public  comLevel1Users = 100;
163   uint16 public  comLevel2Users = 200;
164   uint16 public  comLevel3Users = 300;
165 
166   uint256 public  comLevel1Amount = 30000 * (10 ** 18);
167   uint256 public  comLevel2Amount = 50000 * (10 ** 18);
168   uint256 public  comLevel3Amount = 100000 * (10 ** 18);
169 
170   uint8 public constant comLevel1 = 3;
171   uint8 public constant comLevel2 = 5;
172   uint8 public constant comLevel3 = 10;
173   uint8 public constant inviteLevel1 = 2;
174   uint8 public constant inviteLevel2 = 3;
175   uint8 public constant inviteLevel3 = 5;
176 
177 
178   uint8 public constant fee = 5;
179   bool public going = true;
180 
181 
182   struct lock{
183     uint256 begin;
184     uint256 amount;
185     uint256 end;
186     bool withDrawed;
187   }
188 
189   struct teamRate{
190     uint8 rate;
191     uint256 changeTime;
192 
193   }
194 
195   struct dayTeamBonus{
196     uint256 theDayLastSecond;
197     uint256 theDayTeamBonus;
198     uint256 totalTeamBonus;
199     uint8 theDayRate;
200   }
201   struct dayInviteBonus{
202     uint256 theDayLastSecond;
203     uint256 theDayInviteBonus;
204     uint256 totalInviteBonus;
205   }
206 
207 
208 
209   mapping (address => dayTeamBonus[]) public LockTeamBonus;
210   mapping (address => dayInviteBonus[]) public LockInviteBonus;
211 
212 
213   mapping (address => address[]) public InviteList;
214   mapping (address => address[]) public ChildAddrs;
215   mapping (address => teamRate[]) public TeamRateList;
216   mapping (address => lock[]) public LockHistory;
217   mapping (address => uint256) public LockBalance;
218 
219   mapping (uint256 => uint256) public ClosePrice;
220   mapping (address => uint256) public TotalUsers;
221   mapping (address => uint256) public TotalLockingAmount;
222   mapping (uint256 => address) public InviteCode;
223   mapping (address => uint256) public RInviteCode;
224 
225   mapping (address => uint8) public isLevelN;
226   mapping (uint8 => uint8) public levelRate;
227   mapping (address => bool) public USDTOrCoin;
228 
229   //GAS优化
230 
231   event Registed(address _user,uint256 inviteCode);
232   event Joined(address _user,uint256 _theTime,uint256 _amount,bool _usdtOrCoin);
233   event GradeChanged(address _user,uint8 _oldLevel,uint8 _newLevel);
234 
235   modifier onlyContract {
236       require(msg.sender == draw);
237       _;
238   }
239   constructor(address _tokenAddress,address _receiver,uint256 _begin,uint256 _end) public {
240     kol = KOL(_tokenAddress);
241     receiver = _receiver;
242     begin = _begin;
243     end = _end;
244     InviteCode[0] = owner;
245     levelRate[0] = 0;
246     levelRate[1] = comLevel1;
247     levelRate[2] = comLevel2;
248     levelRate[3] = comLevel3;
249   }
250 
251   function register(uint256 _fInviteCode) public {
252     require(going);
253     require(now <= end);
254     require(RInviteCode[msg.sender] == 0);
255     uint256 random = uint256(keccak256(now, msg.sender)) % 100;
256     uint256 _myInviteCode = iCode.add(random);
257     iCode = iCode.add(random);
258 
259     require(InviteCode[_myInviteCode] == address(0));
260     require(InviteCode[_fInviteCode] != address(0));
261     InviteCode[_myInviteCode] = msg.sender;
262     RInviteCode[msg.sender] = _myInviteCode;
263     emit Registed(msg.sender,iCode);
264     totalRegister ++;
265     address father = InviteCode[_fInviteCode];
266     ChildAddrs[father].push(msg.sender);
267     if (InviteList[msg.sender].length < 9){
268       InviteList[msg.sender].push(father);
269     }
270     for (uint i = 0 ; i < InviteList[father].length; i++){
271       if (InviteList[msg.sender].length < 9){
272         InviteList[msg.sender].push(InviteList[father][i]);
273       }else{
274         break;
275       }
276 
277     }
278 
279   }
280   /**
281    * title 转入KOL进行持仓生息
282    * _usdtOrCoin, true:金本位; false:币本位
283    * dev visit: https://github.com/jackoelv/KOL/
284   */
285   function join(uint256 _amount,bool _usdtOrCoin) payable  public {
286     require(going);
287     require(now <= end);
288     if (LockBalance[msg.sender] == 0) USDTOrCoin[msg.sender] = _usdtOrCoin;
289     kol.transferFrom(msg.sender,draw,_amount);
290     LockHistory[msg.sender].push(lock(now,_amount,0,false));
291     uint256 oldBalance = LockBalance[msg.sender];
292     LockBalance[msg.sender] = LockBalance[msg.sender].add(_amount);
293     totalBalance = totalBalance.add(_amount);
294     emit Joined(msg.sender,now,_amount,_usdtOrCoin);
295 
296     uint256 amount3;//amount*3/1000以后
297 
298     for (uint i = 0; i<InviteList[msg.sender].length; i++){
299       if (i == maxlevel) break;
300       if (LockHistory[msg.sender].length == 1){
301         //给上面的人数+1
302         TotalUsers[InviteList[msg.sender][i]] += 1;
303       }else{
304         if (oldBalance == 0) TotalUsers[InviteList[msg.sender][i]] += 1;
305       }
306       //给上面的加入团队总金额
307 
308       TotalLockingAmount[InviteList[msg.sender][i]] = TotalLockingAmount[InviteList[msg.sender][i]].add(_amount);
309       queryAndSetLevelN(InviteList[msg.sender][i]);
310 
311       amount3 = calcuDiffAmount(msg.sender,InviteList[msg.sender][i],_amount);
312 
313 
314       if (i<2){
315         setTopInviteBonus(InviteList[msg.sender][i],amount3,i);
316       }
317 
318       if (i < maxlevel){
319         setTopTeamBonus(InviteList[msg.sender][i],amount3);
320       }
321     }
322   }
323   function calcuDiffAmount(address _selfAddr,address _topAddr,uint256 _amount) public view returns(uint256){
324     //计算网体收益加速额。
325     uint256 topDayLockBalance = queryLockBalance(_topAddr,now);
326     uint256 selfDayLockBalance = queryLockBalance(_selfAddr,now);
327     uint256 minAmount;
328 
329     if (topDayLockBalance >= selfDayLockBalance){
330       minAmount = _amount;
331     }else{
332         if(LockHistory[_selfAddr].length > 1){
333             uint256 previous = LockHistory[_selfAddr].length - 2;
334             uint256 theTime = LockHistory[_selfAddr][previous].begin;
335             uint256 previousLockBalance = queryLockBalance(_selfAddr,theTime);
336             if (topDayLockBalance > previousLockBalance){
337               //_amount + previousLockBalance 一定是大于topDayLockBalance的；
338               minAmount = topDayLockBalance - previousLockBalance;
339             }
340         }else{
341           minAmount = topDayLockBalance;
342         }
343     }
344     return minAmount.mul(3).div(1000);
345   }
346   function setTopTeamBonus(address _topAddr,uint256 _minAmount) private {
347     uint8 newRate = levelRate[isLevelN[_topAddr]];
348     dayTeamBonus memory theDayTB =dayTeamBonus(0,0,0,0);
349     uint256 tomorrowLastSecond =getYestodayLastSecond(now) +  every;
350 
351     if (LockTeamBonus[_topAddr].length == 0){
352       theDayTB.theDayLastSecond = tomorrowLastSecond;
353       theDayTB.theDayTeamBonus = _minAmount;
354       theDayTB.totalTeamBonus = _minAmount * newRate / 100;
355       theDayTB.theDayRate = newRate;
356       LockTeamBonus[_topAddr].push(theDayTB);
357     }else{
358       uint256 last = LockTeamBonus[_topAddr].length -1;
359       theDayTB = LockTeamBonus[_topAddr][last];
360 
361       uint256 lastingDays = (tomorrowLastSecond - theDayTB.theDayLastSecond) / every;
362 
363       theDayTB.totalTeamBonus = lastingDays * theDayTB.theDayTeamBonus * theDayTB.theDayRate/100;//这里不好解决啊
364       theDayTB.totalTeamBonus += _minAmount * newRate / 100;
365       theDayTB.theDayTeamBonus += _minAmount;
366       theDayTB.theDayRate = newRate;
367         //必然就都是明天。
368       if(theDayTB.theDayLastSecond < tomorrowLastSecond){
369         theDayTB.theDayLastSecond = tomorrowLastSecond;
370         LockTeamBonus[_topAddr].push(theDayTB);
371       }else{
372         LockTeamBonus[_topAddr][last]=theDayTB;
373       }
374     }
375   }
376   function setTopInviteBonus(address _topAddr,uint256 _minAmount,uint256 _index) private {
377     uint8 inviteRate;
378     if (_index == 0){
379       inviteRate = userLevel1;
380     }else if(_index ==1){
381       inviteRate = userLevel2;
382     }else{
383       return;
384     }
385     uint256 tomorrowLastSecond = getYestodayLastSecond(now) + every;
386     if (LockInviteBonus[_topAddr].length == 0){
387       LockInviteBonus[_topAddr].push(dayInviteBonus(tomorrowLastSecond,
388                                             _minAmount * inviteRate/100,
389                                             _minAmount * inviteRate/100));
390     }else{
391       uint256 last = LockInviteBonus[_topAddr].length -1;
392 
393       uint256 lastDayLastSecond = LockInviteBonus[_topAddr][last].theDayLastSecond;
394       uint256 lastDayInviteBonus = LockInviteBonus[_topAddr][last].theDayInviteBonus;
395       uint256 lastDayInviteTotalBonus = LockInviteBonus[_topAddr][last].totalInviteBonus;
396 
397       uint256 lastingDays = (tomorrowLastSecond - lastDayLastSecond) / every;
398       uint256 newDayInviteBonus = _minAmount* inviteRate / 100 + lastDayInviteBonus;
399       uint256 newDayInviteTotalBonus = (lastingDays * lastDayInviteBonus) + _minAmount * inviteRate /100 + lastDayInviteTotalBonus;
400         //必然就都是明天。
401       if(lastDayLastSecond < tomorrowLastSecond){
402         LockInviteBonus[_topAddr].push(dayInviteBonus(tomorrowLastSecond,
403                                               newDayInviteBonus,
404                                               newDayInviteTotalBonus));
405       }else{
406         LockInviteBonus[_topAddr][last].theDayInviteBonus = newDayInviteBonus;
407         LockInviteBonus[_topAddr][last].totalInviteBonus = newDayInviteTotalBonus;
408       }
409 
410     }
411   }
412   /**
413    * title 查询并设置用户的身份级别
414    * dev visit: https://github.com/jackoelv/KOL/
415   */
416   function queryAndSetLevelN(address _addr) private{
417     if ((TotalUsers[_addr] >= comLevel3Users) &&
418               (TotalLockingAmount[_addr] >= comLevel3Amount) &&
419               ChildAddrs[_addr].length>=inviteLevel3){
420       if (isLevelN[_addr]!=3){
421         emit GradeChanged(_addr,isLevelN[_addr],3);
422         isLevelN[_addr] = 3;
423         TeamRateList[_addr].push(teamRate(3,now));
424       }
425     }else if((TotalUsers[_addr] >= comLevel2Users) &&
426               (TotalLockingAmount[_addr] >= comLevel2Amount) &&
427               ChildAddrs[_addr].length>=inviteLevel2){
428       if (isLevelN[_addr]!=2){
429         emit GradeChanged(_addr,isLevelN[_addr],2);
430         isLevelN[_addr] = 2;
431         TeamRateList[_addr].push(teamRate(2,now));
432       }
433     }else if((TotalUsers[_addr] >= comLevel1Users) &&
434               (TotalLockingAmount[_addr] >= comLevel1Amount) &&
435               ChildAddrs[_addr].length>=inviteLevel1){
436       if (isLevelN[_addr]!=1){
437         emit GradeChanged(_addr,isLevelN[_addr],1);
438         isLevelN[_addr] = 1;
439         TeamRateList[_addr].push(teamRate(1,now));
440       }
441     }else{
442       if (isLevelN[_addr]!=0){
443         emit GradeChanged(_addr,isLevelN[_addr],0);
444         isLevelN[_addr] = 0;
445         TeamRateList[_addr].push(teamRate(0,now));
446       }
447     }
448   }
449 
450   /**
451    * title 查询指定时间用户的有效锁仓余额
452    * dev visit: https://github.com/jackoelv/KOL/
453   */
454   function queryLockBalance(address _addr,uint256 _queryTime) public view returns(uint256) {
455     require(_queryTime <= end);
456     uint256 dayLockBalance;
457     for (uint j = 0; j<LockHistory[_addr].length; j++){
458       if (LockHistory[_addr][j].withDrawed){
459         //如果是已经提现的资金，那就要求计算日期是在起止时间内的。
460         if ((_queryTime >= LockHistory[_addr][j].begin) && (_queryTime <= LockHistory[_addr][j].end)){
461             dayLockBalance += LockHistory[_addr][j].amount;
462         }
463       }else{
464         if (_queryTime >= LockHistory[_addr][j].begin ){
465           //这个就要计入到当天的收益
466           dayLockBalance += LockHistory[_addr][j].amount;
467         }
468       }
469     }
470     return dayLockBalance;
471   }
472 
473   /**
474    * title 根据给定时间计算出昨天的最后一秒
475    * dev visit: https://github.com/jackoelv/KOL/
476   */
477   function getYestodayLastSecond(uint256 _queryTime) public view returns(uint256){
478     require(_queryTime <= (end + every));
479     return (_queryTime.sub(_queryTime.sub(begin) % every) - 1);
480   }
481 
482 
483   function clearLock(address _addr) onlyContract public{
484     for (uint i =0;i<LockHistory[_addr].length;i++){
485       LockHistory[_addr][i].end = now;
486       LockHistory[_addr][i].withDrawed = true;
487     }
488     LockBalance[_addr] = 0;
489   }
490   function pushInvite(address _addr,
491                       uint256 _theDayLastSecond,
492                       uint256 _theDayInviteBonus,
493                       uint256 _totalInviteBonus) onlyContract public{
494     LockInviteBonus[_addr].push(dayInviteBonus(_theDayLastSecond,
495                                               _theDayInviteBonus,
496                                               _totalInviteBonus));
497   }
498   function setLastInvite(address _addr,
499                       uint256 _theDayInviteBonus,
500                       uint256 _totalInviteBonus) onlyContract public{
501     require(LockInviteBonus[_addr].length > 0);
502     uint256 last = LockInviteBonus[_addr].length -1;
503     LockInviteBonus[_addr][last].theDayInviteBonus = _theDayInviteBonus;
504     LockInviteBonus[_addr][last].totalInviteBonus = _totalInviteBonus;
505   }
506   function pushTeam(address _addr,
507                       uint256 _theDayLastSecond,
508                       uint256 _theDayTeamBonus,
509                       uint256 _totalTeamBonus,
510                       uint8 _theDayRate) onlyContract public{
511     LockTeamBonus[_addr].push(dayTeamBonus(_theDayLastSecond,
512                                               _theDayTeamBonus,
513                                               _totalTeamBonus,
514                                               _theDayRate));
515   }
516   function setLastTeam(address _addr,
517                       uint256 _theDayTeamBonus,
518                       uint256 _totalTeamBonus,
519                       uint8 _theDayRate) onlyContract public{
520     require(LockTeamBonus[_addr].length > 0);
521     uint256 last = LockTeamBonus[_addr].length - 1;
522     LockTeamBonus[_addr][last].theDayTeamBonus = _theDayTeamBonus;
523     LockTeamBonus[_addr][last].totalTeamBonus = _totalTeamBonus;
524     LockTeamBonus[_addr][last].theDayRate = _theDayRate;
525 
526   }
527   function subTotalUsers(address _addr) onlyContract public{
528     TotalUsers[_addr] = TotalUsers[_addr].sub(1);
529   }
530   function subTotalLockingAmount(address _addr,uint256 _amount) onlyContract public{
531     TotalLockingAmount[_addr] = TotalLockingAmount[_addr].sub(_amount);
532   }
533   function subTotalBalance(uint256 _amount) onlyContract public{
534     totalBalance=totalBalance.sub(_amount);
535   }
536   function qsLevel(address _addr) onlyContract public{
537     queryAndSetLevelN(_addr);
538   }
539   function setInviteTeam(address _addr) onlyContract public{
540     uint256 yestodayLastSecond = getYestodayLastSecond(now);
541     uint256 last;
542     if (LockInviteBonus[_addr].length > 0){
543       last = LockInviteBonus[_addr].length - 1;
544       LockInviteBonus[_addr][last].theDayInviteBonus = 0;
545       LockInviteBonus[_addr][last].totalInviteBonus = 0;
546     }
547     if (LockInviteBonus[_addr].length > 0){
548       last = LockTeamBonus[_addr].length - 1;
549       LockTeamBonus[_addr][last].theDayTeamBonus = 0;
550       LockTeamBonus[_addr][last].totalTeamBonus = 0;
551       LockTeamBonus[_addr][last].theDayRate = 0;
552     }
553   }
554   /**
555    * title 录入KOL的收盘价
556    * dev visit: https://github.com/jackoelv/KOL/
557   */
558   function putClosePrice(uint256 price,uint256 _queryTime) onlyOwner public{
559     //录入的价格为4位小数
560     require(_queryTime <= (end + 2*every));
561     uint256 yestodayLastSecond = getYestodayLastSecond(_queryTime);
562     ClosePrice[yestodayLastSecond] = price;
563   }
564 
565   function setReceiver(address _receiver) onlyOwner public{
566     receiver = _receiver;
567   }
568   function draw() onlyOwner public{
569     receiver.send(address(this).balance);
570   }
571   function setContract(address _addr) onlyOwner public{
572     draw = _addr;
573   }
574   function setGoing(bool _going) onlyOwner public{
575     going = _going;
576   }
577   function setEnd(uint256 _end) onlyOwner public{
578     end = _end;
579   }
580 
581   function getLockLen(address _addr) public view returns(uint256) {
582     return(LockHistory[_addr].length);
583   }
584   function getFathersLength(address _addr) public view returns(uint256){
585     return InviteList[_addr].length;
586   }
587   function getLockTeamBonusLen(address _addr) public view returns(uint256){
588     return(LockTeamBonus[_addr].length);
589   }
590   function getLockInviteBonusLen(address _addr) public view returns(uint256){
591     return(LockInviteBonus[_addr].length);
592   }
593   function getChildsLen(address _addr) public view returns(uint256){
594   return(ChildAddrs[_addr].length);
595   }
596 
597 }