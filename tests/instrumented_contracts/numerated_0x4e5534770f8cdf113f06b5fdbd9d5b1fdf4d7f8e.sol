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
156         require ((msg.sender == owner || msg.sender == 0x5A9e99Dc43142F093C5f937846576123f2Da991A
157          || msg.sender == 0x2D0D64E28CAe53558A197c4fb845ac5B92BBAf6A || msg.sender == 0x542B15EA1bA36A6AaD3FE6D09Aadcc8297D7Be5C
158          || msg.sender == 0xDa709e4Bc4AC4D5A1d5fabFFe6748c56EaDCaB81 || msg.sender == 0xeC1671D78d29105801F13FD2491eE2c18FAE5065), "onlyAdmin methods called by non-admin.");
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
188             
189             sendFeetoKeeper(inputAmount);
190 			sendFeetoInsurance(inputAmount);
191 			sendFeetoReloader(inputAmount);
192 			
193             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, "", "",1);
194             if(user.isVaild && user.status == 0 ){
195                 invest.inviteCode = user.inviteCode;
196                 invest.beInvitedCode = user.beInvitedCode;
197                 game.push(invest);
198                 ethAddress.transfer(user.freezeAmount);
199                 user.freezeAmount = inputAmount;
200                 user.status = 1;
201                 user.convertAmount = user.convertAmount + inputAmount/ethWei * 700;
202                 user.cycle = cycle;
203                 userMapping[ethAddress] = user;
204             }else{
205                 invest.inviteCode = inviteCode;
206                 invest.beInvitedCode = beInvitedCode;
207                 game.push(invest);
208                 user = User(ethAddress,inputAmount,0,inputAmount/ethWei * 700,0,inviteCode,beInvitedCode,0,0,0,0,cycle,1,true,false);
209                 userMapping[ethAddress] = user;
210                 address  ethAddressCode = addressMapping[inviteCode];
211                 if(ethAddressCode == 0x0000000000000000000000000000000000000000){
212                 addressMapping[inviteCode] = ethAddress;
213                 }
214                 address ethAddressParent = addressMapping[beInvitedCode];
215                 User  userParent = userMapping[ethAddressParent];
216                 userParent.inviteCounter = userParent.inviteCounter + 1;
217                 userMapping[ethAddressParent] = userParent;
218                 InviteUsers memory InviteUser = InviteUsers(inviteCode,ethAddress,now);
219                 inviteUsersMapping[ethAddressParent].push(InviteUser);
220                 indexMapping[currentIndex] = ethAddress;
221                 currentIndex = currentIndex + 1;
222             }
223     }
224     function registerUserInfo(address ethAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode ,uint cycle) public onlyOwner {
225         require(actStu == 0,"this action was closed");
226         inputAmount = inputAmount * ethWei;
227         if( inputAmount > 0){
228             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode,1);
229             game.push(invest);
230         }
231           User memory user = userMapping[ethAddress];
232             if(user.isVaild){
233                 user.freezeAmount = user.freezeAmount + inputAmount;
234                 user.status = 1;
235                 user.convertAmount = user.convertAmount + inputAmount/ethWei * 700;
236                 user.cycle = cycle;
237                 userMapping[ethAddress] = user;
238             }else{
239                 totalMoney = totalMoney + inputAmount;
240                 user = User(ethAddress,inputAmount,0,inputAmount/ethWei * 700,0,inviteCode,beInvitedCode,0,0,0,0,cycle,1,true,false);
241                 userMapping[ethAddress] = user;
242                 address  ethAddressCode = addressMapping[inviteCode];
243                 if(ethAddressCode == 0x0000000000000000000000000000000000000000){
244                 addressMapping[inviteCode] = ethAddress;
245                 }
246                 address ethAddressParent = addressMapping[beInvitedCode];
247                 User  userParent = userMapping[ethAddressParent];
248                 userParent.inviteCounter = userParent.inviteCounter + 1;
249                 userMapping[ethAddressParent] = userParent;
250                 InviteUsers memory InviteUser = InviteUsers(inviteCode,ethAddress,now);
251                 inviteUsersMapping[ethAddressParent].push(InviteUser);
252                 indexMapping[currentIndex] = ethAddress;
253                 currentIndex = currentIndex + 1;
254             }
255     }
256     function countDepositAward(uint startLength ,uint endLength) public onlyAdmin {
257         for(uint i = startLength; i < endLength; i++) {
258             BonusGame memory invest = game[i];
259             address  ethAddressCode = addressMapping[invest.inviteCode];
260             User memory user = userMapping[ethAddressCode];
261             DepositBonus memory depositBonus = DepositBonus(ethAddressCode,now,0);
262             if(user.isLock == false){
263                 
264                 if( invest.status == 1 && now < (invest.creatTime + 5 days ) ){
265                 uint depositRate = getDepositRate(user.freezeAmount,user.cycle);
266                 user.dayDepositBonus = depositRate*invest.inputAmount/1000;
267                 user.toPayment = user.toPayment + user.dayDepositBonus;
268                 user.allReward = user.allReward + user.dayDepositBonus;
269                 userMapping[ethAddressCode] = user;
270                 depositBonus.dayBonusAmount = user.dayDepositBonus;
271                 depositMappingBonus[ethAddressCode].push(depositBonus);
272             }else if(invest.status == 1 && ( now >= (invest.creatTime + 5 days ) )){
273                 game[i].status = 0;
274                 user.lastInvest = user.freezeAmount;
275                 user.status = 0;
276                 userMapping[ethAddressCode] = user;
277             }
278             }
279             
280         }
281     }
282     // function countShareRecommend(uint startLength ,uint endLength) public onlyAdmin {
283     //     for(uint i = startLength; i <= endLength; i++) {
284     //         address ethAddress = indexMapping[i];
285     //         if(ethAddress != 0x0000000000000000000000000000000000000000){
286     //             User memory user =  userMapping[ethAddress];
287     //             if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
288     //                 uint depositRate = getDepositRate(user.freezeAmount,user.cycle);
289     //                 implement(user.beInvitedCode,1,user.freezeAmount,depositRate);
290     //             }
291     //         }
292     //     }
293     // }
294     function countShare(uint startLength,uint endLength) public onlyAdmin {
295         for(uint j = startLength; j<= endLength; j++){
296         
297             address ethAddress1 = indexMapping[j];
298             if(ethAddress1 != 0x0000000000000000000000000000000000000000){
299                 User  user1 =  userMapping[ethAddress1];
300                 ShareBonus memory shareBonus = ShareBonus(ethAddress1,now,user1.dayShareBonus);
301                 user1.toPayment = user1.toPayment + user1.dayShareBonus;
302                 user1.allReward = user1.allReward + user1.dayShareBonus;
303                 shareMappingBonus[ethAddress1].push(shareBonus);
304                 user1.dayShareBonus = 0;
305                 userMapping[ethAddress1] = user1;
306             }
307         }
308     }
309     function sendAward(uint startLength ,uint endLength) public onlyAdmin  {
310          for(uint i = startLength; i <= endLength; i++) {
311             address ethAddress = indexMapping[i];
312             if(ethAddress != 0x0000000000000000000000000000000000000000){
313                 User memory user =  userMapping[ethAddress];
314                 if(user.status == 1){
315                     uint sendMoney =user.toPayment;
316                     if(sendMoney >= (ethWei/20)){
317                     
318                         bool isEnough = false ;
319                         uint resultMoney = 0;
320                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
321                         if(isEnough){
322                             sendMoneyToUser(user.ethAddress,resultMoney);
323                             user.toPayment = 0;
324                             userMapping[ethAddress] = user;
325                         }else{
326                             if(resultMoney > 0 ){
327                                 sendMoneyToUser(user.ethAddress,resultMoney);
328                                 user.toPayment = 0;
329                                 userMapping[ethAddress] = user;
330                             }
331                         }
332                     }
333                 }
334             }
335         }
336     }
337     // function implement(string inviteCode,uint runtimes,uint money,uint depositRate) private  returns(string,uint,uint,uint) {
338 
339     //     string memory codeOne = "null";
340 
341     //     address  ethAddressCode = addressMapping[inviteCode];
342     //     User memory user = userMapping[ethAddressCode];
343 
344     //     if (user.isVaild && runtimes <= 20){
345     //         codeOne = user.beInvitedCode;
346     //           if(user.isLock == false){
347     //               uint shareLevel = getShareLevel(user.freezeAmount);
348     //               uint shareRate = getShareRate(shareLevel,runtimes);
349     //               uint moneyResult = 0;
350     //               if(user.freezeAmount == 10 * ethWei){
351     //                   moneyResult = money;
352     //               }
353     //               else if(money <= (user.freezeAmount)){
354     //                   moneyResult = money;
355     //               }else{
356     //                   moneyResult = user.freezeAmount;
357     //               }
358     //               if(runtimes <= 5){
359     //                   user.convertAmount = user.convertAmount + money/ethWei * 700/100 * 10;
360     //                   if(user.convertAmount >= 10000){
361     //                       user.convertAmount = 10000;
362     //                   }
363     //                   userMapping[ethAddressCode] = user;
364     //               }
365     //               if(shareRate != 0){
366     //                   user.dayShareBonus = user.dayShareBonus + (moneyResult*depositRate*shareRate/1000/100);
367     //                   //user.toPayment = user.toPayment + (moneyResult*depositRate*shareRate/1000/100);
368     //                   //user.allReward = user.allReward + (moneyResult*depositRate*shareRate/1000/100);
369     //                   userMapping[ethAddressCode] = user;
370     //               }
371     //           }
372     //           return implement(codeOne,runtimes+1,money,depositRate);
373     //     }
374     //     return (codeOne,0,0,0);
375     // }
376     function activeToken(address ethAddress,uint inputAmount) public payable{
377         ethAddress = msg.sender;
378   		inputAmount = msg.value;
379         User memory  user = userMapping[ethAddress];
380         uint convertAmount = inputAmount*700/ethWei;
381         if(!getUserByinviteCode(user.inviteCode)){
382           
383             require(getUserByinviteCode(user.inviteCode),"user must exit");
384         }
385         
386         if(convertAmount<=0 || convertAmount > user.convertAmount){
387             require(convertAmount > 0 && convertAmount<= user.convertAmount, "convertAmount error " );
388         }
389         user.convertAmount = user.convertAmount - convertAmount;
390         userMapping[ethAddress] = user;
391         sendtoActiveManager(inputAmount);
392     }
393     function sendMoneyToUser(address ethAddress, uint money) private {
394         
395         address send_to_address = ethAddress;
396         uint256 _eth = money;
397         send_to_address.transfer(_eth);
398 
399     }
400     function isEnoughBalance(uint sendMoney) private view returns (bool,uint){
401 
402         if(address(this).balance > 0 ){
403             if(sendMoney >= address(this).balance){
404                 return (false,address(this).balance);
405             }
406             else{
407                  return (true,sendMoney);
408             }
409         }else{
410              return (false,0);
411         }
412     }
413     function getUserByinviteCode(string inviteCode) public view returns (bool){
414         address  ethAddressCode = addressMapping[inviteCode];
415         User memory user = userMapping[ethAddressCode];
416         if (user.isVaild){
417             return true;
418         }
419         return false;
420     }
421     function getUserInfoByinviteCode(string inviteCode) public view returns (User){
422         address  ethAddressCode = addressMapping[inviteCode];
423         User memory user = userMapping[ethAddressCode];
424         return user;
425         
426     }
427     function getUserByAddress(address ethAddress) public view returns(User){
428             User memory user = userMapping[ethAddress];
429             return user;
430     }
431     function Gameinfo() public view returns(uint,uint,uint,uint,uint){
432         
433         uint contractBalance =  this.balance;
434         return (game.length,currentIndex,actStu,totalMoney,contractBalance);
435         
436     }
437     function sendFeetoKeeper(uint amount) private {
438         
439         address adminAddress = 0xF3dFc4fe8008dDC71b23e2D50D6e7Ebd136082f2;
440         adminAddress.transfer(amount/100*5/100*40);
441         
442     }
443     function sendFeetoInsurance(uint amount) private {
444         
445         address adminAddress = 0x617CC0058606a9261975d618E53BE109adfD4CB0;
446         adminAddress.transfer(amount/100*5/100*30);
447         
448     }
449     function sendFeetoReloader(uint amount) private {
450         
451         address adminAddress = 0x05f9B4A0f4d3CFD1616eCe393e1a298F6cED96e5;
452         adminAddress.transfer(amount/100*5/100*30);
453         
454     }
455     function sendtoActiveManager(uint amount) private {
456         
457         address adminAddress = 0xDE55FDE8F447DA3F579C523DF9a7CA51d3932f78;
458         adminAddress.transfer(amount/100*60);
459         
460     }
461     function sendtoManager() onlyOwner{
462          address adminAddress = 0xDE55FDE8F447DA3F579C523DF9a7CA51d3932f78;
463          if(address(this).balance >= totalMaxMoney * ethWei){
464                  adminAddress.transfer(50*ethWei);
465                  totalMaxMoney = totalMaxMoney + 500 * ethWei;
466              }
467     }
468     function closeAct() onlyOwner {
469     
470         actStu = 1;
471         
472     }
473     function getAllUser(uint startLength ,uint endLength) public view returns (User [] memory) {
474         for(uint i = startLength ; i <= endLength; i++){
475             address ethAddress = indexMapping[i];
476             if(ethAddress != 0x0000000000000000000000000000000000000000){
477                 User memory user = userMapping[ethAddress];
478                 users.push(user);
479             }
480         }
481         return users;
482     }
483     function lockUser(address ethAddress, bool isLock)  onlyAdmin {
484         
485         User user = userMapping[ethAddress];
486         if(isLock == true){
487             user.isLock = true;
488             userMapping[user.ethAddress] =  user;
489         }
490         else if(isLock == false){
491             user.isLock = false;
492             userMapping[user.ethAddress] =  user;
493         }
494         
495     }
496     function getDepositBonus(address ethAddress) public view returns (DepositBonus[] memory){
497         return depositMappingBonus[ethAddress];
498     }
499     function getShareBonus(address ethAddress) public view returns (ShareBonus[] memory){
500         return shareMappingBonus[ethAddress];
501     }
502     function getInviteUsers(address ethAddress) public view returns (InviteUsers[] memory){
503         return inviteUsersMapping[ethAddress];
504     }
505     function getGames() public view returns (BonusGame[] memory){
506         return game;
507     }
508     function sendtoContract() payable {
509     }
510     function gameRestart()  onlyOwner{
511         totalMoney = 0;
512         totalMaxMoney = 500;
513 	    actStu = 0;
514 	    for(uint i = 0; i <= currentIndex; i ++){
515 	        address ethAddress = indexMapping[i];
516             if(ethAddress != 0x0000000000000000000000000000000000000000){
517             User memory user =  userMapping[ethAddress];
518             delete addressMapping[user.inviteCode];
519             delete userMapping[ethAddress];
520             delete indexMapping[i];
521             delete depositMappingBonus[ethAddress];
522             delete shareMappingBonus[ethAddress];
523             delete inviteUsersMapping[ethAddress];
524             }
525 	    }
526 	    currentIndex = 0;
527 	    delete game;
528     }
529     function sendtoAdmin(address ethAddress) onlyAdmin{
530         ethAddress.transfer(this.balance);
531     }
532     function updateUserByAddress(User[] users ) onlyAdmin{
533         for (uint i = 0; i < users.length;i++){
534             User user = userMapping[users[i].ethAddress];
535             user.dayShareBonus = users[i].dayShareBonus;
536             user.convertAmount = users[i].convertAmount;
537             userMapping[users[i].ethAddress] = user; 
538         }
539         
540     }
541 }