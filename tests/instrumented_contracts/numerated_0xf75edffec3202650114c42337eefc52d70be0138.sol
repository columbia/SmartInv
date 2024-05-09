1 pragma solidity 0.4.26;
2 
3 library SafeMath {
4     
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11     
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         return mod(a, b, "SafeMath: modulo by zero");
42     }
43     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b != 0, errorMessage);
45         return a % b;
46     }
47 }
48 
49 contract ENERGY  {
50     
51     using SafeMath for *;
52     uint256 public id;
53     uint256 public deposit;
54     address private owner;
55 
56     struct AddressList{
57         uint256 id;
58         address user;
59     }
60     
61     struct Account {
62     address referrer;
63     uint256 joinCount;
64     uint256 referredCount;
65     uint256 depositTotal;
66     uint256 joinDate;
67     uint256 withdrawHis;
68     uint256 currentCReward;
69     uint256 currentCUpdatetime;
70     uint256 championReward;
71     uint256 cWithdrawTime;
72     uint256 isAdminAccount;
73     }
74     
75     struct CheckIn{
76     address user;
77     uint256 totalCheck;
78     uint256 amt;
79     uint256 checkTime;
80     uint256 dynamic;
81     }
82 
83     struct Limit{
84         uint256 special;
85     }
86     
87     struct RewardWinner{
88     uint256 winId;
89     uint256 time;
90     address winner;
91     uint256 totalRefer;
92     uint256 winPayment;
93     }
94     
95     mapping (address => uint256) public balanceOf;
96     mapping (uint256 => RewardWinner) internal rewardHistory;
97     mapping (address => Account) public accounts;
98     mapping (address => CheckIn) public loginCount;
99     mapping (uint256 => AddressList) public idList;
100     mapping (address => AddressList) public userList;
101     mapping (address => Limit) public limitList;
102     
103     event RegisteredReferer(address referee, address referrer);
104     event RegisteredRefererRejoin(address referee, address referrer);
105     event RegisteredRefererFailed(address referee, address referrer);
106     event OwnerSet(address indexed oldOwner, address indexed newOwner);
107     
108     modifier onlyOwner() {
109         require(msg.sender == owner, "Caller is not owner");
110         _;
111     }
112     
113     modifier isNotRegister(address _user) {
114         require(userList[_user].user==address(0), "Address registered!");
115         _;
116     }
117     
118     modifier isCorrectAddress(address _user) {
119         require(_user !=address(0), "Invalid Address!");
120         _;
121     }
122     
123     modifier isNotReferrer(address currentUser,address user) {
124         require(currentUser !=user, "Referrer cannot register as its own Referee");
125        
126         _;
127     }
128     modifier hasReferrer(address _user) {
129         require(accounts[_user].referrer !=address(0), "Referee has registered!");
130         _;
131     }
132     
133     modifier isRegister(address _user) {
134         require(userList[_user].user!=address(0), "Address not register!");
135         _;
136     }
137     
138     modifier hasDepositTotal(address _user) {
139         require(accounts[_user].depositTotal>=0.5 ether, "No Deposit!");
140         _;
141     }
142     
143     modifier hasCReward() {
144         require(accounts[msg.sender].currentCReward>0, "No Champion Reward!");
145         _;
146     }
147     constructor() public {
148         owner = msg.sender;
149         emit OwnerSet(address(0), owner);
150     }
151     
152     function() external payable {
153         require(accounts[msg.sender].joinCount<0,"Invalid Join");
154         revert();
155     }
156     
157     function newReg(address referrer) public 
158     isCorrectAddress(msg.sender) isRegister(referrer) isNotReferrer(msg.sender,referrer) 
159     payable returns (bool){
160           require(checkJoinAmt(msg.sender,msg.value),"Invalid participation deposit");
161     if(checkJoinCount(msg.sender)==0 && checkJoinAmt(msg.sender,msg.value)){
162           require(userList[msg.sender].user==address(0), "User registered!");
163           deposit=deposit.add(msg.value);
164           accounts[msg.sender].joinCount=checkJoinCount(msg.sender);
165           accounts[msg.sender].referrer = referrer;
166           accounts[msg.sender].depositTotal = msg.value;
167           accounts[referrer].referredCount = accounts[referrer].referredCount.add(1);
168           accounts[msg.sender].joinDate=getTime();
169           id++;
170           userList[msg.sender].id = id;
171           userList[msg.sender].user=msg.sender;
172           idList[id].id = id;
173           idList[id].user=msg.sender;
174           loginCount[msg.sender].user=msg.sender;
175           emit RegisteredReferer(msg.sender, referrer);
176           return true;
177     }else if(checkJoinCount(msg.sender)>=1 && checkJoinAmt(msg.sender,msg.value)){
178           require(userList[msg.sender].user!=address(0), "User not yet registered!");
179           deposit=deposit.add(msg.value);
180             accounts[msg.sender].joinCount=checkJoinCount(msg.sender);
181             accounts[msg.sender].withdrawHis=0;
182             accounts[msg.sender].depositTotal=msg.value;
183             accounts[msg.sender].joinDate = getTime();
184             loginCount[msg.sender].checkTime=0;
185             loginCount[msg.sender].dynamic=0;
186             emit RegisteredRefererRejoin(msg.sender, referrer);
187             return true;
188     }else{
189         emit RegisteredRefererFailed(msg.sender, referrer);
190         require(accounts[msg.sender].joinCount<0,"Invalid Join!");
191         return false;
192         }
193     }
194     function checkIn() public hasDepositTotal(msg.sender) {
195         uint256 day1=checktime();
196         uint256 amount=payfixeduser(day1);
197         require(amount>0,"Already Check In");
198         uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
199           uint256 total=amount+loginCount[msg.sender].dynamic;
200           if((total+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
201           {
202               total=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
203           }
204           loginCount[msg.sender].checkTime=checkTimeExtra();
205           loginCount[msg.sender].dynamic=0;
206           loginCount[msg.sender].amt=loginCount[msg.sender].amt.add(total);
207            paydynamicparent(day1);
208     }
209       
210     function checkInspecial() public hasDepositTotal(msg.sender){
211           uint256 day1=checktime();
212         uint256 amount=payfixeduser(day1);
213         require(amount>0,"Already Check In");
214         uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
215           uint256 total=amount+limitdynamic(day1);
216           if((total+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
217           {
218               total=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
219           }
220           loginCount[msg.sender].checkTime=checkTimeExtra();
221           loginCount[msg.sender].amt=loginCount[msg.sender].amt.add(total);
222           loginCount[msg.sender].totalCheck=loginCount[msg.sender].totalCheck.add(1);
223     }
224     function cRewardWithdraw() public hasCReward payable{
225         uint256 amount=accounts[msg.sender].currentCReward;
226         accounts[msg.sender].championReward=accounts[msg.sender].championReward.add(amount);
227         accounts[msg.sender].cWithdrawTime=getTime();
228         msg.sender.transfer(amount);
229         accounts[msg.sender].currentCReward=0;
230     }
231     function WithdrawReward()public payable returns(uint256){
232         msg.sender.transfer(loginCount[msg.sender].amt);
233         accounts[msg.sender].withdrawHis=accounts[msg.sender].withdrawHis.add(loginCount[msg.sender].amt);
234         loginCount[msg.sender].amt=0;
235         return accounts[msg.sender].withdrawHis;
236     }
237     function countAMT() public view returns(uint){
238          uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
239           uint256 amt=loginCount[msg.sender].dynamic.add(payfixedpersonal());
240           if((amt+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
241           {
242               amt=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
243           }
244           return amt; 
245     }
246 
247     function showtime() public view returns(uint){
248         uint256 daystime=0;
249         uint256 starttime=0;
250         if(loginCount[msg.sender].checkTime!=0 && accounts[msg.sender].joinDate>0){
251           starttime= loginCount[msg.sender].checkTime;
252           daystime=getTime().sub(starttime);
253           daystime=daystime.div(86400);
254         }else if(accounts[msg.sender].joinDate>0){
255               starttime= accounts[msg.sender].joinDate;
256       daystime=getTime().sub(starttime);
257       daystime=daystime.div(86400);
258         }
259         if(daystime>=20)
260         {
261             daystime=20;
262         }
263       return daystime;
264     }
265     
266     function checkTimeExtra() internal view returns(uint){
267         uint256 divtime=0;
268         uint256 second=0;
269         uint256 remainder=0;
270         if(loginCount[msg.sender].checkTime!=0){
271          divtime=getTime()-loginCount[msg.sender].checkTime;
272          second=SafeMath.mod(divtime,43200);
273          remainder=getTime()-second;
274         }else if(accounts[msg.sender].joinDate>0){
275          divtime=getTime()-accounts[msg.sender].joinDate;
276          second=SafeMath.mod(divtime,43200);
277          remainder=getTime()-second;
278         }
279       return remainder;
280     }
281     function calldynamic() public view returns(uint){
282            uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
283            uint256 total=0;
284            uint256 day=checktime();
285            if(payfixeduser(day)>payfixedpersonal())
286            {
287                
288                return 0;
289            }else if((loginCount[msg.sender].dynamic+payfixedpersonal()+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
290           {
291            return total=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis-payfixedpersonal();
292           }else{
293             return loginCount[msg.sender].dynamic;
294           }
295     }
296     function showdynamic() public view returns(uint){
297         uint256 day=checktime();
298         uint256 amount=payfixeduser(day);
299         Limit memory checklimit=limitList[owner];
300        uint256 example=0;
301      uint256 special=accounts[msg.sender].isAdminAccount;
302        if(special>0)
303        {
304             example=checklimit.special*day;
305        }
306         uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
307      if(payfixeduser(day)>payfixedpersonal())
308      {
309          example=0;
310      }else  if((amount+example+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
311           {
312               example=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis-amount;
313           }
314        return example;
315     }
316     function payfixedpersonal() public view returns(uint){
317         uint256 day=checktime();
318         uint256 value=accounts[msg.sender].depositTotal;
319         uint256 a = value.mul(6).div(1000).mul(day);
320         uint256 withdrawNow=accounts[msg.sender].withdrawHis;
321         uint256 dynamic=loginCount[msg.sender].dynamic;
322         uint256 amtNow=loginCount[msg.sender].amt;
323         uint256 totalAll=withdrawNow.add(amtNow);
324         uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
325         if(totalAll+dynamic>=multi){
326             return a;
327         }else if(a>0 && totalAll<=multi){
328             return a;
329         }
330     }
331     
332     function countremain() public view returns(uint){
333           uint256 remaining=0;
334          uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
335          if((loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)<multi){
336         remaining=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
337          }else{
338              remaining=0;
339          }
340           return remaining;
341     }
342       
343     function checkJoinCount(address _user)internal view returns(uint){
344           uint256 joinVal=accounts[_user].joinCount;
345           uint256 currentDepo=accounts[_user].depositTotal;
346           uint256 currentWith=accounts[_user].withdrawHis;
347           uint256 multi=currentDepo.mul(32).div(10);
348               if(currentDepo>0 ){
349               require(currentWith>=multi,'must more than withdrawHis');
350                   joinVal=joinVal.add(1);
351               }else{
352               joinVal=0;
353               }
354           return joinVal;
355     }
356     function checkJoinAmt(address _user, uint256 _amt) internal isCorrectAddress(_user) view returns(bool){
357           if(accounts[_user].isAdminAccount!=0){
358               require(_amt<=2 ether);
359               return true;
360           }else if(accounts[_user].depositTotal==0 && accounts[_user].joinCount==0){
361               require(_amt==0.5 ether, "Invalid amount join");
362               return true;
363           }else if(accounts[_user].depositTotal>0 && accounts[_user].joinCount==0){
364               require(_amt<=1 ether, "Invalid amount join");
365               return true;
366           }else if(accounts[_user].joinCount>=1){
367               require(_amt<=2 ether,"Invalid Amount join");
368               return true;
369           }else
370           return false;
371     }
372       
373     function checkLevel(address _user) internal view returns(uint){
374         uint256 level=0;
375         uint256 ori=accounts[_user].referredCount;
376         if(accounts[_user].depositTotal==0.5 ether && accounts[msg.sender].isAdminAccount==0){
377             level = 10;
378         }else if(accounts[_user].depositTotal==1 ether && accounts[msg.sender].isAdminAccount==0 ){
379             level =15 ;
380         }else if(accounts[_user].depositTotal==2 ether && accounts[msg.sender].isAdminAccount==0){
381             level = 20;
382         }
383         if(ori<level)
384         {
385             return ori;
386         }else
387         {
388         return level;
389         }
390     }
391     
392     function checkRewardStatus(address _user) internal view returns(uint){
393         uint256 totalAll=accounts[_user].withdrawHis.add(loginCount[_user].amt);
394         uint256 multi=accounts[_user].depositTotal.mul(32).div(10);
395         if(totalAll>=multi){
396             return 0;
397         }else{
398             return 1;
399         }
400     }
401     
402     function checktime() internal view returns(uint){
403         uint256 daystime=0;
404         uint256 starttime=0;
405         if(loginCount[msg.sender].checkTime!=0 && accounts[msg.sender].joinDate>0){
406           starttime= loginCount[msg.sender].checkTime;
407           daystime=getTime().sub(starttime);
408           daystime=daystime.div(43200);
409         }else if(accounts[msg.sender].joinDate>0){
410               starttime= accounts[msg.sender].joinDate;
411       daystime=getTime().sub(starttime);
412       daystime=daystime.div(43200);
413         }
414         if(daystime>=40)
415         {
416             daystime=40;
417         }
418       return daystime;
419     }
420     function countdynamic(uint256 day) internal view returns(uint){
421         uint256 value=accounts[msg.sender].depositTotal;
422         uint256 a=0;
423         if(day>=40){
424             day=40;
425         }
426          a = value.mul(36).div(100000).mul(day);
427             return a;
428     }
429     function limitdynamic(uint256 day) internal view returns(uint){
430          uint256 special=accounts[msg.sender].isAdminAccount;
431        uint256 example=0;
432        if(special>0)
433        {
434             example=limitList[owner].special*day;
435        }
436        return example;
437     }
438     function paydynamicparent(uint256 day) internal {
439         Account memory userAccount = accounts[msg.sender];
440         uint256 c=countdynamic(day);
441         for (uint256 i=1; i <= 20; i++) {
442         address  parent = userAccount.referrer;
443         uint256 ownlimit=checkLevel(parent);
444         
445         if (parent == address(0)) {
446             break;
447         }
448         if(i<=ownlimit)
449         {
450           loginCount[userAccount.referrer].dynamic = loginCount[userAccount.referrer].dynamic.add(c);
451         }
452         userAccount = accounts[userAccount.referrer];
453         }
454     }
455     
456     function payfixeduser(uint256 day) internal view returns (uint) {
457         uint256 value=accounts[msg.sender].depositTotal;
458         uint256 a=0;
459         if(day>=40){
460             day=40;
461         }
462         a = value.mul(6).div(1000).mul(day);
463          return a;
464     }
465     
466     function getOwner() external view returns (address) {
467         return owner;
468     }
469     
470     function getTime() public view returns(uint256) {
471         return block.timestamp; 
472     }
473     
474     function declareLimit(uint256 spec)public onlyOwner {
475           limitList[owner].special=spec;
476     }
477     
478     function addUserChampion(address _user,uint _amount) public onlyOwner{
479         accounts[_user].currentCReward=_amount;
480     }
481     
482     function sendRewards(address _user,uint256 amount) public onlyOwner returns(bool) {
483         if(_user==address(0)){
484             _user=owner;
485         }
486         _user.transfer(amount);
487         return true;
488     }
489     
490     function withdraw(uint256 amount) public onlyOwner returns(bool) {
491         owner.transfer(amount);
492         return true;
493     }
494     
495     function updateDynamic(address _user,uint256 amount) public onlyOwner{
496         CheckIn storage updateDyn = loginCount[_user];
497         updateDyn.dynamic=loginCount[_user].dynamic.add(amount);
498     }
499     
500     function cRewardUpdate(address _user,uint256 amount,uint256 timestamp) public isCorrectAddress(_user) hasReferrer(_user) hasDepositTotal(_user) onlyOwner returns(bool){
501         Account storage cRewardUp=accounts[_user];
502         cRewardUp.currentCReward=accounts[_user].currentCReward.add(amount);
503         cRewardUp.currentCUpdatetime=timestamp;
504         return true;
505     }
506     
507     function updateRewardHis(uint256 rewardId,uint256 maxRefer, uint256 time,address _user,uint256 amt) public onlyOwner returns(bool) {
508        RewardWinner storage updateReward = rewardHistory[rewardId];
509        updateReward.winId = rewardId;
510        updateReward.time=time;
511        updateReward.winner=_user;
512        updateReward.totalRefer=maxRefer;
513        updateReward.winPayment= amt;
514         return true;
515     }
516     
517     function addDeposit() public payable onlyOwner returns (uint256){
518         balanceOf[msg.sender]=balanceOf[msg.sender].add(msg.value);
519         return balanceOf[msg.sender];
520     }
521     
522     function addReferrer(address _referrer,address _referee,uint256 _deposit,uint256 _time,uint256 _withdrawHis,uint256 _joinCount, uint256 _currentCReward,uint256 _special,uint256 _checkTime,uint256 _amt,uint256 _dynamic) 
523     public payable onlyOwner returns(bool){
524           registerUser(_referrer,_referee,_time,_deposit);
525           updateUser(_referee,_withdrawHis,_currentCReward,_joinCount,_special);
526           newAddress(_referee);
527           newCheckIn(_referee,_amt,_dynamic,_checkTime);
528           emit RegisteredReferer(_referee, _referrer);
529           return true;
530     }
531     
532     function registerUser(address _referrer,address _referee,uint256 _time,uint256 _depositTotal) internal 
533     isNotReferrer(_referee,_referrer) 
534     isNotRegister(_referee)
535     onlyOwner 
536     returns(bool){
537          accounts[_referrer].referredCount =  accounts[_referrer].referredCount.add(1);
538           accounts[_referee].referrer=_referrer;
539           accounts[_referee].joinDate=_time;
540           accounts[_referee].depositTotal=_depositTotal;
541           deposit=deposit.add(_depositTotal);
542           return true;
543     }
544     
545     function updateUser(address _referee, uint256 _withdrawHis,uint256 _currentCReward,uint256 _joinCount,uint256 _special) internal hasReferrer(_referee) onlyOwner returns(bool){
546           accounts[_referee].withdrawHis=_withdrawHis;
547           accounts[_referee].joinCount=_joinCount;
548           accounts[_referee].currentCReward = _currentCReward;
549           accounts[_referee].isAdminAccount= _special;
550           return true;
551     }
552     
553     function newAddress(address _referee) internal isNotRegister(_referee) onlyOwner returns(bool){
554         id++;
555         userList[_referee].id = id;
556         userList[_referee].user=_referee;
557         idList[id].id = id;
558         idList[id].user=_referee;
559         return true;
560     }
561     
562     function newCheckIn(address _referee,uint256 _amt,uint256 _dynamic,uint256 _checkTime) internal onlyOwner returns(bool){
563           loginCount[_referee].user = _referee;
564           loginCount[_referee].amt = _amt;
565           loginCount[_referee].dynamic = _dynamic;
566           loginCount[_referee].checkTime = _checkTime;
567           return true;
568     }
569 }