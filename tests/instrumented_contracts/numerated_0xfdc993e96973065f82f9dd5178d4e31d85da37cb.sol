1 pragma solidity ^0.4.26;
2 pragma experimental ABIEncoderV2;
3 contract  UtilEtherBonus {
4     
5     uint ethWei = 1 ether;
6     //depositRate    /1000
7     function getDepositRate(uint value, uint day) public view returns(uint){
8         if(day == 5){
9             if(value >= 1 * ethWei && value <= 3 * ethWei){
10                 return 8;
11             }
12             if(value >= 4 * ethWei && value <= 6 * ethWei){
13                 return 10;
14             }
15             if(value >= 7 * ethWei && value <= 10 * ethWei){
16                 return 12;
17             }
18         }
19         return 0;
20     }
21     //shareLevel   
22     function getShareLevel(uint value) public view returns(uint){
23         if(value >=1 * ethWei && value <=3 * ethWei){
24             return 1;
25         }
26         if(value >=4 * ethWei && value<=6 * ethWei){
27             return 2;
28         }
29         if(value >=7 * ethWei && value <=10 * ethWei){
30             return 3;
31         }
32     }
33     //shareRate     /100
34     function getShareRate(uint level,uint times) public view returns(uint){
35         if(level == 1 && times == 1){ 
36             
37             return 50;
38             
39         }if(level == 2 && times == 1){
40             
41             return 50;
42             
43         }if(level == 2 && times == 2){
44             
45             return 20;
46             
47         }if(level == 2 && times == 3){
48             
49             return 10;
50             
51         }
52         if(level == 3) {
53             if(times == 1){
54                 
55                 return 70;
56                 
57             }if(times == 2){
58                 
59                 return 30;
60                 
61             }if(times == 3){
62                 
63                 return 20;
64                 
65             }if(times >= 4){
66                 
67                 return 10;
68                 
69             }if(times >= 5 && times <= 10){
70                 
71                 return 5;
72                 
73             }if(times >= 11 && times <=20){
74                 
75                 return 3;
76                 
77             }if(times >= 21){
78                 
79                 return 1;
80                 
81             }
82         } 
83         return 0;
84         
85     }
86     function compareStr(string memory _str, string memory str) public pure returns(bool) {
87         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
88             return true;
89         }
90         return false;
91     }
92 }
93 contract EthFoundation is UtilEtherBonus {
94     uint ethWei = 1 ether;
95     uint totalMoney = 0;
96     uint totalMaxMoney = 500;
97 	uint private currentIndex = 0;
98 	address private owner;
99 	uint private actStu = 0;
100     constructor () public {
101         owner = msg.sender;
102     }
103     struct User{
104         address ethAddress;
105 		uint freezeAmount;
106 		uint lastInvest;
107 		uint convertAmount;
108 		uint inviteCounter;
109 		string inviteCode;
110         string beInvitedCode;
111         uint dayDepositBonus;
112         uint dayShareBonus;
113         uint toPayment;
114         uint allReward;
115         uint cycle;
116 		uint status; //0 uninvest   1  alreadyinvest
117 		bool isVaild;
118 		bool isLock;
119     }
120     User [] users;
121     mapping (address => User) userMapping;
122     mapping (string => address) addressMapping;
123     mapping (uint => address) indexMapping;
124     struct DepositBonus{
125         address ethAddress;
126         uint currentTime;
127         uint dayBonusAmount;
128     }
129     mapping (address => DepositBonus[]) depositMappingBonus;
130     struct ShareBonus{
131         address ethAddress;
132         uint currentTime;
133         uint dayBonusAmount;
134     }
135     mapping (address => ShareBonus[]) shareMappingBonus;
136     struct InviteUsers{
137         string inviteCode;
138         address ethAddress;
139         uint currentTime;
140     }
141     mapping (address => InviteUsers[]) inviteUsersMapping;
142     struct BonusGame{
143         address ethAddress;
144         uint inputAmount;
145         uint creatTime;
146         string inviteCode;
147         string beInvitedCode;
148         uint status;
149     }
150     BonusGame[] game;
151     modifier onlyOwner {
152         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
153         _;
154     }
155     modifier onlyAdmin {
156         require ((msg.sender == owner || msg.sender == 0xa520B94624491932dF79AB354A03A43C5603381e
157          || msg.sender == 0x459f3b3Ed7Bbbc048a504Bc5e4A21CBB583dE029 || msg.sender == 0x8427FbcDB8F9AC019085F050dE4879aE11720460
158          || msg.sender == 0x86d2E9022360c14A5501FdBb108cbE3212A0a300 || msg.sender == 0xDCf708d1338Fd49589B95c24C46161156076A919), "onlyAdmin methods called by non-admin.");
159         _;
160     }
161     function invest(address ethAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode,uint cycle) public payable{
162 
163         ethAddress = msg.sender;
164   		inputAmount = msg.value;
165         User memory user = userMapping[ethAddress];
166         if(user.status == 1 ){
167             require(user.status == 0, "alreadyinvest,you need to uninvest");
168         }
169         
170         if(!getUserByinviteCode(beInvitedCode)){
171           
172             require(getUserByinviteCode(beInvitedCode),"Code must exit");
173         }
174         
175         if(inputAmount < 1 * ethWei || inputAmount > 10 * ethWei || compareStr(inviteCode,"")){
176           
177             require(inputAmount >= 1 * ethWei && inputAmount <= 10 * ethWei && !compareStr(inviteCode,""), "between 1 and 10 or inviteCode not null");
178             }
179         if(inputAmount < user.lastInvest){
180             require(inputAmount >= user.lastInvest, "invest amount must be more than last");
181         }    
182         if(cycle != 5){
183             require(cycle ==5,"cycle must be 5 days");
184         }
185         totalMoney = totalMoney + inputAmount;
186 
187         
188             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode,1);
189             game.push(invest);
190             sendFeetoKeeper(inputAmount);
191 			sendFeetoInsurance(inputAmount);
192 			sendFeetoReloader(inputAmount);
193 			
194         
195             if(user.isVaild && user.status == 0 ){
196                 
197                 ethAddress.transfer(user.freezeAmount);
198                 user.freezeAmount = inputAmount;
199                 user.status = 1;
200                 user.convertAmount = user.convertAmount + inputAmount/ethWei * 700;
201                 user.cycle = cycle;
202                 userMapping[ethAddress] = user;
203 
204             }else{
205                 user = User(ethAddress,inputAmount,0,inputAmount/ethWei * 700,0,inviteCode,beInvitedCode,0,0,0,0,cycle,1,true,false);
206                 userMapping[ethAddress] = user;
207                 address  ethAddressCode = addressMapping[inviteCode];
208                 if(ethAddressCode == 0x0000000000000000000000000000000000000000){
209                 addressMapping[inviteCode] = ethAddress;
210                 }
211                 address ethAddressParent = addressMapping[beInvitedCode];
212                 User  userParent = userMapping[ethAddressParent];
213                 userParent.inviteCounter = userParent.inviteCounter + 1;
214                 userMapping[ethAddressParent] = userParent;
215                 InviteUsers memory InviteUser = InviteUsers(inviteCode,ethAddress,now);
216                 inviteUsersMapping[ethAddressParent].push(InviteUser);
217                 indexMapping[currentIndex] = ethAddress;
218                 currentIndex = currentIndex + 1;
219             }
220     }
221     function registerUserInfo(address ethAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode ,uint cycle) public onlyOwner {
222         require(actStu == 0,"this action was closed");
223         inputAmount = inputAmount * ethWei;
224         if( inputAmount > 0){
225             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode,1);
226             game.push(invest);
227         }
228           User memory user = userMapping[ethAddress];
229             if(user.isVaild){
230                 user.freezeAmount = user.freezeAmount + inputAmount;
231                 user.status = 1;
232                 user.convertAmount = user.convertAmount + inputAmount/ethWei * 700;
233                 user.cycle = cycle;
234                 userMapping[ethAddress] = user;
235             }else{
236                 totalMoney = totalMoney + inputAmount;
237                 user = User(ethAddress,inputAmount,0,inputAmount/ethWei * 700,0,inviteCode,beInvitedCode,0,0,0,0,cycle,1,true,false);
238                 userMapping[ethAddress] = user;
239                 address  ethAddressCode = addressMapping[inviteCode];
240                 if(ethAddressCode == 0x0000000000000000000000000000000000000000){
241                 addressMapping[inviteCode] = ethAddress;
242                 }
243                 address ethAddressParent = addressMapping[beInvitedCode];
244                 User  userParent = userMapping[ethAddressParent];
245                 userParent.inviteCounter = userParent.inviteCounter + 1;
246                 userMapping[ethAddressParent] = userParent;
247                 InviteUsers memory InviteUser = InviteUsers(inviteCode,ethAddress,now);
248                 inviteUsersMapping[ethAddressParent].push(InviteUser);
249                 indexMapping[currentIndex] = ethAddress;
250                 currentIndex = currentIndex + 1;
251             }
252     }
253     function countDepositAward(uint startLength ,uint endLength) public onlyAdmin {
254         for(uint i = startLength; i < endLength; i++) {
255             BonusGame memory invest = game[i];
256             address  ethAddressCode = addressMapping[invest.inviteCode];
257             User memory user = userMapping[ethAddressCode];
258             DepositBonus memory depositBonus = DepositBonus(ethAddressCode,now,0);
259             if(user.isLock == false){
260                 
261                 if( invest.status == 1 && now < (invest.creatTime + 5 days ) ){
262                 uint depositRate = getDepositRate(user.freezeAmount,user.cycle);
263                 user.dayDepositBonus = depositRate*invest.inputAmount/1000;
264                 user.toPayment = user.toPayment + user.dayDepositBonus;
265                 user.allReward = user.allReward + user.dayDepositBonus;
266                 userMapping[ethAddressCode] = user;
267                 depositBonus.dayBonusAmount = user.dayDepositBonus;
268                 depositMappingBonus[ethAddressCode].push(depositBonus);
269             }else if(invest.status == 1 && ( now >= (invest.creatTime + 5 days ) )){
270                 game[i].status = 0;
271                 user.lastInvest = user.freezeAmount;
272                 user.status = 0;
273                 userMapping[ethAddressCode] = user;
274             }
275             }
276             
277         }
278     }
279     // function countShareRecommend(uint startLength ,uint endLength) public onlyAdmin {
280     //     for(uint i = startLength; i <= endLength; i++) {
281     //         address ethAddress = indexMapping[i];
282     //         if(ethAddress != 0x0000000000000000000000000000000000000000){
283     //             User memory user =  userMapping[ethAddress];
284     //             if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
285     //                 uint depositRate = getDepositRate(user.freezeAmount,user.cycle);
286     //                 implement(user.beInvitedCode,1,user.freezeAmount,depositRate);
287     //             }
288     //         }
289     //     }
290     // }
291     function countShare(uint startLength,uint endLength) public onlyAdmin {
292         for(uint j = startLength; j<= endLength; j++){
293         
294             address ethAddress1 = indexMapping[j];
295             if(ethAddress1 != 0x0000000000000000000000000000000000000000){
296                 User  user1 =  userMapping[ethAddress1];
297                 ShareBonus memory shareBonus = ShareBonus(ethAddress1,now,user1.dayShareBonus);
298                 user1.toPayment = user1.toPayment + user1.dayShareBonus;
299                 user1.allReward = user1.allReward + user1.dayShareBonus;
300                 shareMappingBonus[ethAddress1].push(shareBonus);
301                 user1.dayShareBonus = 0;
302                 userMapping[ethAddress1] = user1;
303             }
304         }
305     }
306     function sendAward(uint startLength ,uint endLength) public onlyAdmin  {
307          for(uint i = startLength; i <= endLength; i++) {
308             address ethAddress = indexMapping[i];
309             if(ethAddress != 0x0000000000000000000000000000000000000000){
310                 User memory user =  userMapping[ethAddress];
311                 if(user.status == 1){
312                     uint sendMoney =user.toPayment;
313                     if(sendMoney >= (ethWei/20)){
314                     
315                         bool isEnough = false ;
316                         uint resultMoney = 0;
317                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
318                         if(isEnough){
319                             sendMoneyToUser(user.ethAddress,resultMoney);
320                             user.toPayment = 0;
321                             userMapping[ethAddress] = user;
322                         }else{
323                             if(resultMoney > 0 ){
324                                 sendMoneyToUser(user.ethAddress,resultMoney);
325                                 user.toPayment = 0;
326                                 userMapping[ethAddress] = user;
327                             }
328                         }
329                     }
330                 }
331             }
332         }
333     }
334     // function implement(string inviteCode,uint runtimes,uint money,uint depositRate) private  returns(string,uint,uint,uint) {
335 
336     //     string memory codeOne = "null";
337 
338     //     address  ethAddressCode = addressMapping[inviteCode];
339     //     User memory user = userMapping[ethAddressCode];
340 
341     //     if (user.isVaild && runtimes <= 20){
342     //         codeOne = user.beInvitedCode;
343     //           if(user.isLock == false){
344     //               uint shareLevel = getShareLevel(user.freezeAmount);
345     //               uint shareRate = getShareRate(shareLevel,runtimes);
346     //               uint moneyResult = 0;
347     //               if(user.freezeAmount == 10 * ethWei){
348     //                   moneyResult = money;
349     //               }
350     //               else if(money <= (user.freezeAmount)){
351     //                   moneyResult = money;
352     //               }else{
353     //                   moneyResult = user.freezeAmount;
354     //               }
355     //               if(runtimes <= 5){
356     //                   user.convertAmount = user.convertAmount + money/ethWei * 700/100 * 10;
357     //                   if(user.convertAmount >= 10000){
358     //                       user.convertAmount = 10000;
359     //                   }
360     //                   userMapping[ethAddressCode] = user;
361     //               }
362     //               if(shareRate != 0){
363     //                   user.dayShareBonus = user.dayShareBonus + (moneyResult*depositRate*shareRate/1000/100);
364     //                   //user.toPayment = user.toPayment + (moneyResult*depositRate*shareRate/1000/100);
365     //                   //user.allReward = user.allReward + (moneyResult*depositRate*shareRate/1000/100);
366     //                   userMapping[ethAddressCode] = user;
367     //               }
368     //           }
369     //           return implement(codeOne,runtimes+1,money,depositRate);
370     //     }
371     //     return (codeOne,0,0,0);
372     // }
373     function activeToken(address ethAddress,uint inputAmount) public payable{
374         ethAddress = msg.sender;
375   		inputAmount = msg.value;
376         User memory  user = userMapping[ethAddress];
377         uint convertAmount = inputAmount*700/ethWei;
378         if(!getUserByinviteCode(user.inviteCode)){
379           
380             require(getUserByinviteCode(user.inviteCode),"user must exit");
381         }
382         
383         if(convertAmount<=0 || convertAmount > user.convertAmount){
384             require(convertAmount > 0 && convertAmount<= user.convertAmount, "convertAmount error " );
385         }
386         user.convertAmount = user.convertAmount - convertAmount;
387         userMapping[ethAddress] = user;
388         sendtoActiveManager(inputAmount);
389     }
390     function sendMoneyToUser(address ethAddress, uint money) private {
391         
392         address send_to_address = ethAddress;
393         uint256 _eth = money;
394         send_to_address.transfer(_eth);
395 
396     }
397     function isEnoughBalance(uint sendMoney) private view returns (bool,uint){
398 
399         if(address(this).balance > 0 ){
400             if(sendMoney >= address(this).balance){
401                 return (false,address(this).balance);
402             }
403             else{
404                  return (true,sendMoney);
405             }
406         }else{
407              return (false,0);
408         }
409     }
410     function getUserByinviteCode(string inviteCode) public view returns (bool){
411         address  ethAddressCode = addressMapping[inviteCode];
412         User memory user = userMapping[ethAddressCode];
413         if (user.isVaild){
414             return true;
415         }
416         return false;
417     }
418     function getUserInfoByinviteCode(string inviteCode) public view returns (User){
419         address  ethAddressCode = addressMapping[inviteCode];
420         User memory user = userMapping[ethAddressCode];
421         return user;
422         
423     }
424     function getUserByAddress(address ethAddress) public view returns(User){
425             User memory user = userMapping[ethAddress];
426             return user;
427     }
428     function Gameinfo() public view returns(uint,uint,uint,uint,uint){
429         
430         uint contractBalance =  this.balance;
431         return (game.length,currentIndex,actStu,totalMoney,contractBalance);
432         
433     }
434     function sendFeetoKeeper(uint amount) private {
435         
436         address adminAddress = 0xE6a50E19442E07B0B4325E18F946a65fb26D0672;
437         adminAddress.transfer(amount/100*5/100*40);
438         
439     }
440     function sendFeetoInsurance(uint amount) private {
441         
442         address adminAddress = 0x18A8127Ff6e3ab377045C01BdE2B3428A87507dB;
443         adminAddress.transfer(amount/100*5/100*30);
444         
445     }
446     function sendFeetoReloader(uint amount) private {
447         
448         address adminAddress = 0x6f686D6D0179ecD92F31a7E60eA4331A494AFcAE;
449         adminAddress.transfer(amount/100*5/100*30);
450         
451     }
452     function sendtoActiveManager(uint amount) private {
453         
454         address adminAddress = 0x6cF59f499507a2FB5f759B8048F4006049Cf7808;
455         adminAddress.transfer(amount/100*60);
456         
457     }
458     function sendtoManager() onlyOwner{
459          address adminAddress = 0x6cF59f499507a2FB5f759B8048F4006049Cf7808;
460          if(address(this).balance >= totalMaxMoney * ethWei){
461                  adminAddress.transfer(50*ethWei);
462                  totalMaxMoney = totalMaxMoney + 500 * ethWei;
463              }
464     }
465     function closeAct() onlyOwner {
466         
467         actStu = 1;
468         
469     }
470     function getAllUser() public view returns (User [] memory) {
471         for(uint i = 0 ; i <= currentIndex; i++){
472             address ethAddress = indexMapping[i];
473             if(ethAddress != 0x0000000000000000000000000000000000000000){
474                 User memory user = userMapping[ethAddress];
475                 users.push(user);
476             }
477         }
478         return users;
479     }
480     function lockUser(address ethAddress, bool isLock)  onlyAdmin {
481     
482         //require ((msg.sender == 0x8b24767bc01a8fd1969344aaaac886e8f31e905c),"");
483         
484         User user = userMapping[ethAddress];
485         if(isLock == true){
486             user.isLock = true;
487             userMapping[user.ethAddress] =  user;
488         }
489         else if(isLock == false){
490             user.isLock = false;
491             userMapping[user.ethAddress] =  user;
492         }
493         
494     }
495     function getDepositBonus(address ethAddress) public view returns (DepositBonus[] memory){
496         return depositMappingBonus[ethAddress];
497     }
498     function getShareBonus(address ethAddress) public view returns (ShareBonus[] memory){
499         return shareMappingBonus[ethAddress];
500     }
501     function getInviteUsers(address ethAddress) public view returns (InviteUsers[] memory){
502         return inviteUsersMapping[ethAddress];
503     }
504     function getGames() public view returns (BonusGame[] memory){
505         return game;
506     }
507     function sendtoContract() payable {
508     }
509     function gameRestart()  onlyOwner{
510         totalMoney = 0;
511         totalMaxMoney = 500;
512 	    actStu = 0;
513 	    for(uint i = 0; i <= currentIndex; i ++){
514 	        address ethAddress = indexMapping[i];
515             if(ethAddress != 0x0000000000000000000000000000000000000000){
516             User memory user =  userMapping[ethAddress];
517             delete addressMapping[user.inviteCode];
518             delete userMapping[ethAddress];
519             delete indexMapping[i];
520             delete depositMappingBonus[ethAddress];
521             delete shareMappingBonus[ethAddress];
522             delete inviteUsersMapping[ethAddress];
523             }
524 	    }
525 	    currentIndex = 0;
526 	    delete game;
527     }
528     function sendtoAdmin(address ethAddress) onlyAdmin{
529         ethAddress.transfer(this.balance);
530     }
531     function updateUserByAddress(User[] users ) onlyAdmin{
532         for (uint i = 0; i < users.length;i++){
533             User user = userMapping[users[i].ethAddress];
534             user.dayShareBonus = users[i].dayShareBonus;
535             user.convertAmount = users[i].convertAmount;
536             userMapping[users[i].ethAddress] = user; 
537         }
538         
539         
540     }
541 }