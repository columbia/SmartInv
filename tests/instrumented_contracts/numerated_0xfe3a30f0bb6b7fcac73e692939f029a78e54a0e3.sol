1 pragma solidity ^0.4.26;
2 
3 contract  UtilEtherLevel  {
4 
5  uint ethWei = 1 ether;
6     //getlevel
7     function getlevel(uint value) public view returns(uint){
8         if(value >= 1 * ethWei && value <= 5 * ethWei){
9             
10             return 1;
11             
12         }if(value >= 6 * ethWei && value <= 10 * ethWei){
13             
14             return 2;
15             
16         }if(value >= 11 * ethWei && value <= 15 * ethWei){
17             
18             return 3;
19             
20         }
21             return 0;
22     }
23     //getLinelevel
24     function getLineLevel(uint value) public view returns(uint){
25         if(value >= 1 * ethWei && value <= 5 * ethWei){
26             
27             return 1;
28             
29         }if(value >= 6 * ethWei && value <= 10 * ethWei){
30             
31             return 2;
32             
33         }if(value >= 11 * ethWei){
34             
35             return 3;
36         }
37     }
38     
39     //level-commend  /1000
40     function getScBylevel(uint level) public pure returns(uint){
41         if(level == 1){
42             
43             return 5;
44             
45         }if(level == 2){
46             
47             return 7;
48             
49         }if(level == 3) {
50             
51             return 10;
52         }
53         return 0;
54     }
55     
56     //level fire scale   /10
57     function getFireScBylevel(uint level) public pure returns(uint){
58         if(level == 1){
59             
60             return 3;
61             
62         }if(level == 2){
63             
64             return 6;
65             
66         }if(level == 3) {
67             
68             return 10;
69             
70         }return 0;
71     }
72     
73     //level and times => invite scale /100
74     function getRecommendScaleBylevelandTim(uint level,uint times) public pure returns(uint){
75         if(level == 1 && times == 1){ 
76             
77             return 50;
78             
79         }if(level == 2 && times == 1){
80             
81             return 70;
82             
83         }if(level == 2 && times == 2){
84             
85             return 50;
86             
87         }if(level == 3) {
88             if(times == 1){
89                 
90                 return 100;
91                 
92             }if(times == 2){
93                 
94                 return 80;
95                 
96             }if(times == 3){
97                 
98                 return 60;
99                 
100             }if(times >= 4 && times <= 10){
101                 
102                 return 10;
103                 
104             }if(times >= 11 && times <= 20){
105                 
106                 return 5;
107                 
108             }if(times >= 21){
109                 
110                 return 1;
111                 
112             }
113         } return 0;
114     }
115     
116     
117      function compareStr(string memory _str, string memory str) public pure returns(bool) {
118         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
119             return true;
120         }
121         return false;
122     }
123 }
124 contract Etherhonor is UtilEtherLevel {
125 
126 /**
127  * https://www.etherhonor.com
128  * https://www.etherhonor.com/home
129 */
130 
131     uint ethWei = 1 ether;
132     uint allCount = 0;
133     uint oneDayCount = 0;
134     uint totalMoney = 0;
135     uint totalCount = 0;
136 	uint private beginTime = 1;
137     uint lineCountTimes = 1;
138 	uint private currentIndex = 0;
139 	address private owner;
140 	uint private actStu = 0;
141 
142 	constructor () public {
143         owner = msg.sender;
144     }
145 	struct User{
146 
147         address ethAddress;
148         uint freeAmount;
149         uint freezeAmount;
150         uint rechargeAmount;
151         uint withdrawlsAmount;
152         uint inviteAmonut;
153         uint bonusAmount;
154         uint dayInviteAmonut;
155         uint dayBonusAmount;
156         uint level;
157         uint resTime;
158         uint lineAmount;
159         uint lineLevel;
160         string inviteCode;
161         string beInvitedCode;
162 		uint isline;
163 		uint status; 
164 		bool isVaild;
165     }
166 
167     struct BonusGame{
168 
169         address ethAddress;
170         uint inputAmount;
171         uint resTime;
172         string inviteCode;
173         string beInvitedCode;
174 		uint isline;
175 		uint status;
176 		uint times;
177     }
178 
179     mapping (address => User) userMapping;
180     mapping (string => address) addressMapping;
181     mapping (uint => address) indexMapping;
182 
183     BonusGame[] game;
184 
185 
186     modifier onlyOwner {
187         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
188         _;
189     }
190 
191     function () public payable {
192     }
193 
194      function invest(address ethAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode) public payable{
195 
196         ethAddress = msg.sender;
197   		inputAmount = msg.value;
198         uint lineAmount = inputAmount;
199 
200         if(!getUserByinviteCode(beInvitedCode)){
201           
202             require(getUserByinviteCode(beInvitedCode),"Code must exit");
203         }
204         if(inputAmount < 1 * ethWei || inputAmount > 15 * ethWei || compareStr(inviteCode,"")){
205           
206             require(inputAmount >= 1 * ethWei && inputAmount <= 15 * ethWei && !compareStr(inviteCode,""), "between 1 and 15");
207         }
208         User storage userTest = userMapping[ethAddress];
209         if(userTest.isVaild && userTest.status != 2){
210             if((userTest.lineAmount + userTest.freezeAmount + lineAmount)> (15 * ethWei)){
211              
212                 require((userTest.lineAmount + userTest.freezeAmount + lineAmount) <= 15 * ethWei,"can not beyond 15 eth");
213                 return;
214             }
215         }
216        totalMoney = totalMoney + inputAmount;
217         totalCount = totalCount + 1;
218         bool isLine = false;
219 
220         uint level =getlevel(inputAmount);
221         uint lineLevel = getLineLevel(lineAmount);
222         if(beginTime==1){
223             
224             lineAmount = 0;
225             oneDayCount = oneDayCount + inputAmount;
226             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode ,1,1,0);
227             game.push(invest);
228             sendFeetoAdmin(inputAmount);
229 			sendFeetoLuckdraw(inputAmount);
230 			
231         }else{
232             
233             allCount = allCount + inputAmount;
234             isLine = true;
235             invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode ,0,1,0);
236             inputAmount = 0;
237             game.push(invest);
238             
239         }
240           User memory user = userMapping[ethAddress];
241             if(user.isVaild && user.status == 1){
242                 
243                 user.freezeAmount = user.freezeAmount + inputAmount;
244                 user.rechargeAmount = user.rechargeAmount + inputAmount;
245                 user.lineAmount = user.lineAmount + lineAmount;
246                 level =getlevel(user.freezeAmount);
247                 lineLevel = getLineLevel(user.freezeAmount + user.freeAmount +user.lineAmount);
248                 user.level = level;
249                 user.lineLevel = lineLevel;
250                 userMapping[ethAddress] = user;
251 
252             }else{
253                 if(isLine){
254                     level = 0;
255                 }
256                 if(user.isVaild){
257                     
258                    inviteCode = user.inviteCode;
259                    beInvitedCode = user.beInvitedCode;
260                    
261                 }
262                 user = User(ethAddress,0,inputAmount,inputAmount,0,0,0,0,0,level,now,lineAmount,lineLevel,inviteCode, beInvitedCode ,1,1,true);
263                 userMapping[ethAddress] = user;
264 
265                 indexMapping[currentIndex] = ethAddress;
266                 currentIndex = currentIndex + 1;
267             }
268             
269             address  ethAddressCode = addressMapping[inviteCode];
270             
271             if(ethAddressCode == 0x0000000000000000000000000000000000000000){
272                 
273                 addressMapping[inviteCode] = ethAddress;
274                 
275             }
276 
277     }
278 
279       function registerUserInfo(address ethAddress ,uint freezeAmount,string  inviteCode,string  beInvitedCode ,uint freeAmount,uint times) public {
280           
281         require(actStu == 0,"this action was closed");
282         freezeAmount = freezeAmount * ethWei;
283         freeAmount = freeAmount * ethWei;
284         uint level =getlevel(freezeAmount);
285         uint lineLevel = getLineLevel(freezeAmount + freeAmount);
286         
287         if(beginTime==1 && freezeAmount > 0){
288             
289             BonusGame memory invest = BonusGame(ethAddress,freezeAmount,now, inviteCode, beInvitedCode ,1,1,times);
290             game.push(invest);
291             
292         }
293           User memory user = userMapping[ethAddress];
294             if(user.isVaild){
295                 
296                 user.freeAmount = user.freeAmount + freeAmount;
297                 user.freezeAmount = user.freezeAmount +  freezeAmount;
298                 user.rechargeAmount = user.rechargeAmount + freezeAmount +freezeAmount;
299                 user.level =getlevel(user.freezeAmount);
300                 user.lineLevel = getLineLevel(user.freezeAmount + user.freeAmount +user.lineAmount);
301                 userMapping[ethAddress] = user;
302                 
303             }else{
304                 
305                 user = User(ethAddress,freeAmount,freezeAmount,freeAmount+freezeAmount,0,0,0,0,0,level,now,0,lineLevel,inviteCode, beInvitedCode ,1,1,true);
306                 userMapping[ethAddress] = user;
307 
308                 indexMapping[currentIndex] = ethAddress;
309                 currentIndex = currentIndex + 1;
310             }
311             address  ethAddressCode = addressMapping[inviteCode];
312             
313             if(ethAddressCode == 0x0000000000000000000000000000000000000000){
314                 
315                 addressMapping[inviteCode] = ethAddress;
316             }
317 
318     }
319 
320     function ethWithDraw(address ethAddress) public{
321        
322         require (msg.sender == ethAddress, "account diffrent");
323 
324          User memory user = userMapping[ethAddress];
325          uint sendMoney  = user.freeAmount;
326 
327         bool isEnough = false ;
328         uint resultMoney = 0;
329         
330         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
331 
332             user.withdrawlsAmount =user.withdrawlsAmount + resultMoney;
333             user.freeAmount = user.freeAmount - resultMoney;
334             user.level = getlevel(user.freezeAmount);
335             user.lineLevel = getLineLevel(user.freezeAmount + user.freeAmount);
336             userMapping[ethAddress] = user;
337             
338             if(resultMoney > 0 ){
339                 ethAddress.transfer(resultMoney);
340             }
341     }
342 
343 
344     function countShareAndRecommendedAward(uint startLength ,uint endLength) public {
345         
346          require ((msg.sender == owner || msg.sender == 0xa07BB3BD83E54ADA45CAE042338ceD3787b38768
347          || msg.sender == 0xD0192309e756Ffda15f0F781c8A64F6F600CF618 || msg.sender == 0x3F9E8379fB6475e8b46B8F21C0140413027E72c2
348          || msg.sender == 0xB5FBd52c80711aFfE4C79B94c4B782ddB9b3f006 || msg.sender == 0x3079B3918CD9c1f66B2B836d94d02bE510ff68Ee
349          || msg.sender == 0xE9B598DE79b63313C0f565972A5E12d7add8A1B4), "");
350 
351         for(uint i = startLength; i < endLength; i++) {
352             BonusGame memory invest = game[i];
353              address  ethAddressCode = addressMapping[invest.inviteCode];
354             User memory user = userMapping[ethAddressCode];
355             if(invest.isline==1 && invest.status == 1 && now < (invest.resTime + 5 days ) && invest.times <5){
356                 
357                 game[i].times = invest.times + 1;
358                 uint scale = getScBylevel(user.level);
359                 user.dayBonusAmount =user.dayBonusAmount + scale*invest.inputAmount/1000;
360                 user.bonusAmount = user.bonusAmount + scale*invest.inputAmount/1000;
361                 userMapping[ethAddressCode] = user;
362 
363             }else if(invest.isline==1 && invest.status == 1 && ( now >= (invest.resTime + 5 days ) || invest.times >= 5 )){
364                 
365                 game[i].status = 2;
366                 user.freezeAmount = user.freezeAmount - invest.inputAmount;
367                 user.freeAmount = user.freeAmount + invest.inputAmount;
368                 user.level = getlevel(user.freezeAmount);
369                 userMapping[ethAddressCode] = user;
370                 
371             }
372         }
373     }
374 
375     function countRecommend(uint startLength ,uint endLength) public {
376         
377           require ((msg.sender == owner || msg.sender == 0xa07BB3BD83E54ADA45CAE042338ceD3787b38768
378          || msg.sender == 0xD0192309e756Ffda15f0F781c8A64F6F600CF618 || msg.sender == 0x3F9E8379fB6475e8b46B8F21C0140413027E72c2
379          || msg.sender == 0xB5FBd52c80711aFfE4C79B94c4B782ddB9b3f006 || msg.sender == 0x3079B3918CD9c1f66B2B836d94d02bE510ff68Ee
380          || msg.sender == 0xE9B598DE79b63313C0f565972A5E12d7add8A1B4), "");
381          
382          for(uint i = startLength; i <= endLength; i++) {
383 
384             address ethAddress = indexMapping[i];
385             if(ethAddress != 0x0000000000000000000000000000000000000000){
386 
387                 User memory user =  userMapping[ethAddress];
388                 if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
389                     
390                     uint scale = getScBylevel(user.level);
391                     implement(user.beInvitedCode,1,user.freezeAmount,scale);
392                     
393                 }
394             }
395         }
396     }
397 
398 
399     function implement(string inviteCode,uint runtimes,uint money,uint shareSc) private  returns(string,uint,uint,uint) {
400 
401         string memory codeOne = "null";
402 
403         address  ethAddressCode = addressMapping[inviteCode];
404         User memory user = userMapping[ethAddressCode];
405 
406         if (user.isVaild && runtimes <= 25){
407             codeOne = user.beInvitedCode;
408               if(user.status == 1){
409                   
410                   uint fireSc = getFireScBylevel(user.lineLevel);
411                   uint recommendSc = getRecommendScaleBylevelandTim(user.lineLevel,runtimes);
412                   uint moneyResult = 0;
413 
414                   if(money <= (user.freezeAmount+user.lineAmount+user.freeAmount)){
415                       
416                       moneyResult = money;
417                       
418                   }else{
419                       
420                       moneyResult = user.freezeAmount+user.lineAmount+user.freeAmount;
421                       
422                   }
423 
424                   if(recommendSc != 0){
425                       
426                       user.dayInviteAmonut =user.dayInviteAmonut + (moneyResult*shareSc*fireSc*recommendSc/1000/10/100);
427                       user.inviteAmonut = user.inviteAmonut + (moneyResult*shareSc*fireSc*recommendSc/1000/10/100);
428                       userMapping[ethAddressCode] = user;
429                       
430                   }
431               }
432               
433               return implement(codeOne,runtimes+1,money,shareSc);
434         }
435         return (codeOne,0,0,0);
436 
437     }
438 
439     /**
440      * Automatically issue eth within the contract, prohibiting external calls
441     */
442     function sendMoneyToUser(address ethAddress, uint money) private {
443         
444         address send_to_address = ethAddress;
445         uint256 _eth = money;
446         send_to_address.transfer(_eth);
447 
448     }
449 
450     /**
451      * Dividends and sharing rewards are automatically issued.
452      * If the amount is greater than or equal to 0.1, 
453      * the payment will be made. Otherwise, it will be accumulated in the account. 
454      * If it is greater than or equal to 0.1, it will be automatically issued.
455     */
456     function sendAward(uint startLength ,uint endLength)  external onlyOwner  {
457 
458          for(uint i = startLength; i <= endLength; i++) {
459 
460             address ethAddress = indexMapping[i];
461             if(ethAddress != 0x0000000000000000000000000000000000000000){
462 
463                 User memory user =  userMapping[ethAddress];
464                 if(user.status == 1){
465                     uint sendMoney =user.dayInviteAmonut + user.dayBonusAmount;
466 
467                     if(sendMoney >= (ethWei/10)){
468                          sendMoney = sendMoney - (ethWei/1000);
469                         bool isEnough = false ;
470                         uint resultMoney = 0;
471                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
472                         if(isEnough){
473                             sendMoneyToUser(user.ethAddress,resultMoney);
474                             
475                             user.dayInviteAmonut = 0;
476                             user.dayBonusAmount = 0;
477                             userMapping[ethAddress] = user;
478                         }else{
479                             userMapping[ethAddress] = user;
480                             if(sendMoney > 0 ){
481                                 sendMoneyToUser(user.ethAddress,resultMoney);
482                                 user.dayInviteAmonut = 0;
483                                 user.dayBonusAmount = 0;
484                                 userMapping[ethAddress] = user;
485                             }
486                         }
487                     }
488                 }
489             }
490         }
491     }
492 
493     function isEnoughBalance(uint sendMoney) private view returns (bool,uint){
494 
495         if(address(this).balance > 0 ){
496              if(sendMoney >= address(this).balance){
497                 if((address(this).balance ) > 0){
498                     return (false,address(this).balance);
499                 }else{
500                     return (false,0);
501                 }
502             }else{
503                  return (true,sendMoney);
504             }
505         }else{
506              return (false,0);
507         }
508     }
509 
510     function getUserByAddress(address ethAddress) public view returns(uint,uint,uint,uint,uint,uint,uint,uint,uint,string,string,uint){
511 
512             User memory user = userMapping[ethAddress];
513             return (user.lineAmount,user.freeAmount,user.freezeAmount,user.inviteAmonut,
514             user.bonusAmount,user.lineLevel,user.status,user.dayInviteAmonut,user.dayBonusAmount,user.inviteCode,user.beInvitedCode,user.level);
515     }
516     
517     function getUserByinviteCode(string inviteCode) public view returns (bool){
518 
519         address  ethAddressCode = addressMapping[inviteCode];
520         User memory user = userMapping[ethAddressCode];
521       if (user.isVaild){
522           
523             return true;
524             
525       }
526         return false;
527     }
528     
529     function getSomeInfo() public view returns(uint,uint,uint){
530         
531         return(totalMoney,totalCount,beginTime);
532         
533     }
534     
535     function Gameinfo() public view returns(uint,uint,uint){
536         
537         return (game.length,currentIndex,actStu);
538         
539     }
540     
541     function getUseraddId(uint id)  public view returns(address) {
542          
543         BonusGame memory invest = game[id];
544         address  ethAddressCode = addressMapping[invest.inviteCode];
545         return ethAddressCode;
546      }
547      
548     function getUserById(uint id) public view returns(address){
549         
550         return indexMapping[id];
551         
552     }
553     
554    
555    
556     
557     function sendFeetoAdmin(uint amount) private {
558         
559         address adminAddress = 0xDCD8213B4A547CBd2E7826a4be18c5B51EF22b67;
560         adminAddress.transfer(amount/25);
561         
562     }
563 	
564 
565 	function sendFeetoLuckdraw(uint amount) private {
566 	    
567 	   address LuckdrawAddress = 0x82dA8a40974c29f94AEC879041d0EDBf639D7Fc2;
568 	   LuckdrawAddress.transfer(amount/100);
569 	   
570 	 }
571 	    
572 	
573     function closeAct()  external onlyOwner {
574         
575         actStu = 1;
576         
577     }
578 }