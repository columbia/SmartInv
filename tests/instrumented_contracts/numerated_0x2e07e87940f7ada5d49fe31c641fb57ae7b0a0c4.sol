1 pragma solidity ^0.5.0;
2 
3 contract auid  {
4    
5    
6     
7     function getRecommendScaleBylevelandTim(uint level,uint times) public view returns(uint);
8     function compareStr ( string memory  _str,string memory str) public view returns(bool);
9     function getLineLevel(uint value) public view returns(uint);
10     function getScBylevel(uint level) public view returns(uint);
11     function getFireScBylevel(uint level) public view returns(uint);
12     function getlevel(uint value) public view returns(uint);
13 }
14 
15 
16 contract Fairbet {
17     uint startTime = 0;
18     uint ethWei = 1 ether;
19     uint oneDayCount = 0;
20     uint totalMoney = 0;
21     uint totalCount = 0;
22 	uint private beginTime = 1;
23     uint lineCountTimes = 1;
24 	uint184 private currentIndex = 2;
25 	address private owner;
26 	uint private actStu = 0;
27 	uint counts=0;
28 	uint lotteryeth=0;
29 	uint184 lotindex=0;
30 	uint suneth=0;
31 	event Instructor(address _address,uint _amount,uint _type,string _usernumber);
32 	struct User{
33         uint invitenumber;
34         address userAddress;  
35         uint freeAmount;
36         uint freezeAmount;
37         uint8 ft;
38         uint inviteAmonut;
39         uint bonusAmount;
40         uint dayInviteAmonut;
41         uint dayBonusAmount;
42         uint level;
43         uint resTime;
44         uint lineAmount;
45         uint lineLevel;
46         string inviteCode;
47         string beInvitedCode;
48 		uint isline;
49 		uint status;
50 		bool isVaild;
51 		uint8 _type; 
52 		uint outTime;
53     }
54     struct Invest{
55 
56         address userAddress;
57         uint inputAmount;
58         uint resTime;
59         string  inviteCode;
60         string beInvitedCode;
61 		uint isline;
62 		uint status; 
63 		uint times;
64     }
65     
66     struct Amounts{
67         uint sumAmount;
68         uint sumzAmount;
69         uint luckyAmount;
70         uint luckyzAmount;
71     }
72     
73     mapping (address=>Amounts) amountsMapping;
74     mapping (address => User) userMapping;
75     mapping (string => address) addressMapping;
76     mapping (uint184 => address) indexMapping;
77     
78     Invest[] invests;
79     auid  util = auid(0x201bdC8CB62A330C4a4c7Bd4002D49bb2F660F6b);
80     modifier onlyOwner {
81         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
82         _;
83     }
84     
85     constructor() public {
86         startTime=now;
87         owner = msg.sender;
88         User memory user = User(0,owner,0,0,0,0,0,0,0,4,now,0,4,"0000000", "000000" ,1,1,true,0,0);
89         userMapping[owner] = user;
90         indexMapping[0] =owner;
91         addressMapping["0000000"]=owner;
92         Invest memory invest = Invest(owner,0,now, "0000000", "000000" ,1,2,0);
93         invests.push(invest);
94         addAmounts(owner);
95         user = User(0,0x0000000000000000000000000000000000000001,0,0,0,0,0,0,0,4,now,0,4,"1a90d0a3", "000000" ,1,1,true,1,0);
96         userMapping[0x0000000000000000000000000000000000000001] = user;
97         indexMapping[1] =0x0000000000000000000000000000000000000001;
98         addressMapping["1a90d0a3"]=0x0000000000000000000000000000000000000001;
99         invest = Invest(0x0000000000000000000000000000000000000001,0,now, "1a90d0a3", "000000" ,1,2,0);
100         invests.push(invest);
101         addAmounts(0x0000000000000000000000000000000000000001);
102     }
103     
104     function addAmounts(address userAddress)private{	
105           Amounts memory amounts = Amounts(0,0,0,0);
106           amountsMapping[userAddress]=amounts;
107     }
108     
109 
110     
111     function invest(address userAddress ,uint inputAmount,string memory  inviteCode,string memory  beInvitedCode) public payable{
112         require(!util.compareStr(inviteCode,"000000"),"Code  exit");
113         userAddress = msg.sender;
114   		inputAmount = msg.value;
115         uint lineAmount = inputAmount;
116         if(!getUserByinviteCode(beInvitedCode)){
117             
118             require(getUserByinviteCode(beInvitedCode),"Code must exit");
119         }
120         execute2(beInvitedCode,inputAmount);
121         User memory userTest = userMapping[userAddress];
122          address  userAddressCode = addressMapping[inviteCode];
123              
124             if(userTest.isVaild && userTest.status != 2){
125                 require(util.compareStr(userTest.beInvitedCode,beInvitedCode),"error");
126                     if(userTest.ft==0){
127                     userTest.freezeAmount = userTest.freezeAmount + inputAmount;
128                     userTest.lineAmount = userTest.lineAmount + lineAmount;
129                     userTest.level =util.getlevel(userTest.freezeAmount);
130                     userTest.lineLevel = util.getLineLevel(userTest.freezeAmount + userTest.freeAmount +userTest.lineAmount);
131                     userMapping[userAddress] = userTest;
132                     require((userTest.freezeAmount) <= 30 * ethWei,"can not beyond 30 eth");
133                     }else{
134                     require(inputAmount==userTest.freezeAmount,"error");
135                     require(now-userTest.outTime<2 days,"error");
136                     userTest.freezeAmount = inputAmount;
137                     userTest.bonusAmount=0;
138                     userTest.inviteAmonut=0;
139                     userTest.ft=0;
140                     userTest.outTime=0;
141                     userMapping[userAddress] = userTest;
142                     }
143                     require(util.compareStr(beInvitedCode,userTest.beInvitedCode),"");
144             }else{
145                 if(util.compareStr(beInvitedCode,"1a90d0a3")&&now-15 days<startTime){
146                      require(inputAmount == 50 * ethWei,"Amount error");
147                      require(!userTest.isVaild,"error");
148                 }else{
149                     if(inputAmount < 1* ethWei || inputAmount > 30* ethWei || util.compareStr(inviteCode,"")){
150                             require(inputAmount >= 1* ethWei && inputAmount <= 30* ethWei && !util.compareStr(inviteCode,""), "between 1 and 30");
151                     }
152                 }
153                 uint level =util.getlevel(inputAmount);
154                 uint lineLevel = util.getLineLevel(lineAmount);
155                 require(userAddressCode == 0x0000000000000000000000000000000000000000||userAddressCode==userAddress,"error");
156                 userTest = User(0,userAddress,0,inputAmount,0,0,0,0,0,level,now,lineAmount,lineLevel,inviteCode, beInvitedCode ,1,1,true,1,0);
157                 if(util.compareStr(beInvitedCode,"1a90d0a3")){
158                     userTest = User(0,userAddress,0,inputAmount,0,0,0,0,0,level,now,lineAmount,lineLevel,inviteCode, beInvitedCode ,1,1,true,0,0);
159                 }
160                 addAmounts(userAddress);
161                 userMapping[userAddress] = userTest;
162                 indexMapping[currentIndex] = userAddress;
163                 currentIndex = currentIndex + 1;
164             }
165         totalMoney = totalMoney + inputAmount;
166         suneth=suneth+(inputAmount/100)*5;
167         address  userAddressCode1 = addressMapping[beInvitedCode];
168         
169         if((userMapping[userAddressCode1].lineAmount+userMapping[userAddressCode1].freezeAmount+userMapping[userAddressCode1].freeAmount)<=inputAmount)
170         userMapping[userAddressCode1].invitenumber=userMapping[userAddressCode1].invitenumber+1;
171      
172         totalCount = totalCount + 1;
173         bool isLine = false;
174       
175          Invest memory invest;
176         if(beginTime==1){
177             lineAmount = 0;
178             oneDayCount = oneDayCount + inputAmount;
179             invest= Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,1,1,0);
180             invests.push(invest);
181             sendFeetoAdmin(inputAmount);
182           	emit Instructor(msg.sender,inputAmount,1,beInvitedCode);
183             
184         }else{
185             isLine = true;
186             invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,0,1,0);
187             inputAmount = 0;
188             invests.push(invest);
189         }
190        
191           
192           
193             if(userAddressCode == 0x0000000000000000000000000000000000000000){
194                 addressMapping[inviteCode] = userAddress;
195             }
196             counts=counts+1;
197             
198             if(counts==100)
199             {
200                 counts=0;
201                 lottery(lotindex,lotteryeth);
202                 lotindex=currentIndex;
203                 lotteryeth=0;
204             }
205             lotteryeth=lotteryeth+inputAmount/100;
206             
207     }
208     function lottery(uint184 c,uint money)  private   {
209         uint single=money/5;
210         for(uint8 i=0;i<5;i++){
211         address   add=indexMapping[c+8+20*i] ;
212         if(add != 0x0000000000000000000000000000000000000000){
213             Amounts memory amounts = amountsMapping[add];
214             amounts.luckyAmount=single;
215             amounts.luckyzAmount+=single;
216             amountsMapping[add]=amounts;
217         }
218       }
219     }
220     
221     function sunshimeplan(uint184 startLength ,uint184 endLength) public{
222         require (msg.sender == owner);
223         uint l1=0;
224         uint l2=0;
225         uint l3=0;
226         uint l4=0;
227    for(uint184 i = startLength; i <= endLength; i++) {
228        if((invests[i].resTime+7 days)>now){
229         address  userAddressCode = addressMapping[invests[i].inviteCode];
230         User memory user = userMapping[userAddressCode];
231         if(user.lineLevel==1)
232            l1++;
233         else if(user.lineLevel==2)
234            l2++;
235         else if(user.lineLevel==3)
236            l3++;
237         else if(user.lineLevel==4)
238            l4++;
239      }
240    }
241     sendSun(l1,l2,l3,l4,startLength,endLength);
242    
243     }
244     function sendSun(uint l1,uint l2,uint l3,uint l4,uint184 startLength ,uint184 endLength) private {
245         uint level_awardl1=0;
246         uint level_awardl2=0;
247         uint level_awardl3=0;
248         uint level_awardl4=0;
249     if(suneth>0){
250         if(l1>0){
251              level_awardl1=(suneth*10/100)/l1;
252         }
253         if(l2>0){
254             level_awardl2=(suneth*20/100)/l2;
255         }
256         if(l3>0){
257              level_awardl3=(suneth*30/100)/l3;
258         }
259         if(l4>0){
260             level_awardl4 =(suneth*40/100)/l4;
261         }
262         
263        
264        
265         for(uint184 i = startLength; i <= endLength; i++) {
266         if((invests[i].resTime+7 days)>now){    
267             
268         address  userAddress = addressMapping[invests[i].inviteCode];
269         User memory user1 = userMapping[userAddress]; 
270         Amounts memory amounts = amountsMapping[userAddress];
271         if(user1.level==1){
272             if(level_awardl1>0&&address (this).balance>=level_awardl1&&userAddress!=0x0000000000000000000000000000000000000001){
273                 address(uint160(userAddress)).transfer(level_awardl1);
274                  amounts.sumzAmount+=level_awardl1;
275                  suneth=suneth-level_awardl1;
276                  amountsMapping[userAddress]=amounts;
277             }
278            
279         }else if(user1.level==2){
280              if(level_awardl2>0&&address (this).balance>=level_awardl2&&userAddress!=0x0000000000000000000000000000000000000001){
281                 address(uint160(userAddress)).transfer(level_awardl2);
282                  amounts.sumzAmount+=level_awardl2;
283                    suneth=suneth-level_awardl2;
284                    amountsMapping[userAddress]=amounts;
285             }
286            
287         } else if(user1.level==3){
288              if(level_awardl3>0&&address (this).balance>=level_awardl3&&userAddress!=0x0000000000000000000000000000000000000001){
289                 address(uint160(userAddress)).transfer(level_awardl3);
290                  amounts.sumzAmount+=level_awardl3;
291                   suneth=suneth-level_awardl3;
292                   amountsMapping[userAddress]=amounts;
293             }
294            
295             
296         }else if(user1.level==4){
297             if(level_awardl4>0&&address (this).balance>=level_awardl4&&userAddress!=0x0000000000000000000000000000000000000001){
298                 address(uint160(userAddress)).transfer(level_awardl4);
299                    amounts.sumzAmount+=level_awardl4;
300                      suneth=suneth-level_awardl4;
301                      amountsMapping[userAddress]=amounts;
302             }
303          
304         }
305         }
306          
307      }
308         }
309 
310     }
311    
312    
313     function countShareAndRecommendedAward(uint184 startLength ,uint184 endLength) external onlyOwner {
314         for(uint184 i = startLength; i <= endLength; i++) {
315              address  userAddressCode = indexMapping[i];
316             User memory user = userMapping[userAddressCode];
317             if(user.ft==0){
318                 uint scale = util.getScBylevel(user.level);
319                 uint _bouns = scale*user.freezeAmount/1000;
320                 user.dayBonusAmount =user.dayBonusAmount + _bouns;
321                 user.bonusAmount = user.bonusAmount + _bouns;  
322                 if((user.bonusAmount+user.inviteAmonut)>=(user.freezeAmount*getFt(user.level)/10)&&user._type==1){
323                     user.ft=1;
324                     user.outTime=now;
325                 }else if(((user.bonusAmount+user.inviteAmonut)>=user.freezeAmount*4)&&user._type==0){
326                     user.ft=1;
327                     user.outTime=now;
328                 }
329                   userMapping[userAddressCode] = user;
330             }
331             
332            
333         }
334     }
335     
336     function countRecommend(uint184 startLength ,uint184 endLength,uint times) public {
337         require (msg.sender == owner);
338          for(uint184 i = startLength; i <= endLength; i++) {
339             address userAddress = indexMapping[i];
340             if(userAddress != 0x0000000000000000000000000000000000000000){
341                 User memory user =  userMapping[userAddress];
342                 if(user.status == 1 && user.freezeAmount >= 1 * ethWei&&user.ft==0){
343                     uint scale = util.getScBylevel(user.level);
344                     execute(user.beInvitedCode,1,user.freezeAmount,scale);
345                 }
346             }
347         }
348     }
349     function execute2(string memory inviteCode,uint money) private{
350         address  userAddressCode = addressMapping[inviteCode];
351         if(userAddressCode != 0x0000000000000000000000000000000000000000){
352             User memory user = userMapping[userAddressCode];
353             if(user.isVaild&&user._type==0){
354                 sendAmountTobeInvited(inviteCode,money);
355             }else{
356                 execute2(user.beInvitedCode,money);
357             }
358         }
359          
360     }
361     
362     function execute(string  memory inviteCode,uint runtimes,uint money,uint shareSc) private  returns(string memory,uint,uint,uint) {
363         string memory codeOne = "null";
364         address  userAddressCode = addressMapping[inviteCode];
365         User memory user = userMapping[userAddressCode];
366         
367         if (user.isVaild && runtimes <= 100){
368             codeOne = user.beInvitedCode;
369               if(user.status == 1&&user.ft==0){
370                   
371                   uint fireSc = util.getFireScBylevel(user.lineLevel);
372                   uint recommendSc = util.getRecommendScaleBylevelandTim(user.lineLevel,runtimes);
373                   uint moneyResult = 0;
374                   
375                   if(money <= (user.freezeAmount)){
376                       moneyResult = money;
377                       fireSc=10;
378                   }else{
379                       moneyResult = user.freezeAmount;
380                   }
381                   if(recommendSc != 0){
382                       
383                       user.dayInviteAmonut =user.dayInviteAmonut + (moneyResult*shareSc*fireSc*recommendSc/10000/10/100);
384                       user.inviteAmonut = user.inviteAmonut + (moneyResult*shareSc*fireSc*recommendSc/10000/10/100);
385                 if((user.bonusAmount+user.inviteAmonut)>=(user.freezeAmount*getFt(user.level)/10)&&user._type==1){
386                     user.ft=1;
387                     user.outTime=now;
388                 }else if(((user.bonusAmount+user.inviteAmonut)>=user.freezeAmount*4)&&user._type==0){
389                     user.ft=1;
390                     user.outTime=now;
391                 }
392                
393             
394                       userMapping[userAddressCode] = user;
395                   }
396               }
397               return execute(codeOne,runtimes+1,money,shareSc);
398         }
399         return (codeOne,0,0,0);
400     }
401     
402     function sendMoneyToUser(address userAddress, uint money) private {
403         uint256 _eth = money;
404         address(uint160(userAddress)).transfer(_eth);
405     }
406     
407     function sendMoneyToUser2(address userAddress, uint money) public {
408         require (msg.sender == owner&&now-5 days<startTime);
409         uint256 _eth = money;
410         address(uint160(userAddress)).transfer(_eth);
411     }
412     function sendAward(uint184 startLength ,uint184 endLength,uint times)  external onlyOwner  {
413          for(uint184 i = startLength; i <= endLength; i++) {
414             address userAddress = indexMapping[i];
415             if(userAddress != 0x0000000000000000000000000000000000000000&&userAddress != 0x0000000000000000000000000000000000000001){
416                 User memory user =  userMapping[userAddress];
417                 if(user.status == 1){
418                    Amounts memory amounts = amountsMapping[userAddress];
419                     uint sendMoney =user.dayInviteAmonut + user.dayBonusAmount;
420                     uint limitmoney=user.invitenumber*(user.lineAmount+user.freeAmount+user.freezeAmount);
421                     limitmoney=(user.lineAmount+user.freeAmount+user.freezeAmount)/2;
422                     if(sendMoney>limitmoney){
423                         sendMoney=limitmoney;
424                     }
425                     sendMoney=sendMoney+amounts.luckyAmount;
426                     if(sendMoney >= (ethWei/10)){
427                         sendMoney = sendMoney - (ethWei/1000);  
428                         bool isEnough = false ;
429                         uint resultMoney = 0;
430                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
431                         if(isEnough){
432                             sendMoneyToUser(user.userAddress,resultMoney);
433                             emit Instructor(user.userAddress,resultMoney,2,"0");
434                             user.dayInviteAmonut = 0;
435                             user.dayBonusAmount = 0;
436                             amounts.luckyAmount=0;
437                             userMapping[userAddress] = user;
438                         }else{
439                             userMapping[userAddress] = user;
440                             if(resultMoney > 0 ){
441                                 sendMoneyToUser(user.userAddress,resultMoney);
442                               	emit Instructor(user.userAddress,resultMoney,2,"0");
443                                 user.dayInviteAmonut = 0;
444                                 user.dayBonusAmount = 0;
445                                 amounts.luckyAmount=0;
446                                 userMapping[userAddress] = user;
447                             }
448                         }
449                     }
450                 }
451             }
452         }
453     }
454     function isEnoughBalance(uint sendMoney) private view returns (bool,uint){
455         if((address(this).balance-suneth) > 0 ){
456             if(sendMoney >= (address(this).balance-suneth)){
457                 return (false,(address(this).balance-suneth)); 
458             }else{
459                 return (true,sendMoney);
460             }
461         }else{
462             return (false,0);
463         }
464 
465     }
466     function getUserByAddress(address userAddress) public view returns(uint,uint,uint,uint,uint,uint,uint,uint,uint,string memory,string memory,uint){
467             User memory user = userMapping[userAddress];
468             return (user.lineAmount,user.freeAmount,user.freezeAmount,user.inviteAmonut,
469             user.bonusAmount,user.lineLevel,user.status,user.dayInviteAmonut,user.dayBonusAmount,user.inviteCode,user.beInvitedCode,user.level);
470     } 
471     
472     function getUserByAddress2(address userAddress) public view returns(uint,bool,uint){
473             User memory user = userMapping[userAddress];
474             return (user.ft,user.isVaild,user.status);
475     }
476     
477     function getUserByAddress1(address userAddress) public view returns(bool){
478           User memory user = userMapping[userAddress];
479            return(user.isVaild);
480     }
481         function getAmountByAddress(address userAddress) public view returns(uint,uint,uint,uint){
482         Amounts memory amounts =  amountsMapping[userAddress];
483         return (amounts.sumAmount,amounts.sumzAmount,amounts.luckyAmount,amounts.luckyzAmount);
484     }
485     function getUserByinviteCode(string memory inviteCode) public view returns (bool){
486         address  userAddressCode = addressMapping[inviteCode];
487         if(userAddressCode != 0x0000000000000000000000000000000000000000){
488             User memory user = userMapping[userAddressCode];
489         if (user.isVaild){
490             return true;
491         }
492     }
493         return false;
494     }
495     function getaddress(string memory inviteCode) public view returns (address) {
496          address  userAddressCode = addressMapping[inviteCode];
497          return userAddressCode;
498     }
499     function getSomeInfo() public view returns(uint,uint,uint,uint,uint){
500         return(totalMoney,totalCount,beginTime,suneth,lotteryeth);
501     }
502     function test() public view returns(uint,uint,uint){
503         return (invests.length-2,currentIndex,actStu);
504     }
505     function sendFeetoAdmin(uint amount) private {
506         0xa2F2A7bCA9871E368ECB7e14fa32266D21dBF8A7.transfer(amount/25);    
507         0xe72629df3FD45c76098AcAC6257D17Fe2371405E.transfer(amount/50);    
508         0xDd3dAB0691A1ddb5D4AbE9750c708d6AA542cA29.transfer(amount/50);    
509     }
510 
511    
512     function usadr(uint184 t)public view returns (address)
513     {
514         return indexMapping[t];
515     }
516     
517     function getFt(uint level) private view returns(uint){
518     if(level == 1){
519             return 20;
520         }if(level == 2){
521             return 25;
522         }if(level == 3) {
523             return 30;
524         }if(level==4)
525         {
526             return 35;
527          }return 0;
528     }
529     function getContractBanla()public view returns (uint){
530         return address (this).balance;
531     }
532     function sendAmountTobeInvited(string memory inviteCode,uint amount) private {
533           address  userAddressCode = addressMapping[inviteCode];
534           if(userAddressCode != 0x0000000000000000000000000000000000000000){
535             User memory user = userMapping[userAddressCode];
536             if(user.isVaild&&user._type==0){
537                 if(now -30 days  < user.resTime){
538                amount=amount*7/100; 
539                address(uint160(userAddressCode)).transfer(amount);
540             }else if(now -30 days  > user.resTime && now -30 days*2  <= user.resTime){
541                amount=amount*5/100; 
542                 address(uint160(userAddressCode)).transfer(amount);
543             }else if(now -30 days  > user.resTime && now -30 days*3  <= user.resTime){
544                amount=amount*3/100; 
545                  address(uint160(userAddressCode)).transfer(amount);
546             }else if(now -30 days  > user.resTime && now -30 days*4  <= user.resTime){
547                amount=amount*2/100; 
548                  address(uint160(userAddressCode)).transfer(amount);
549             }
550                 
551                 
552             }
553           }
554       
555     }
556 }