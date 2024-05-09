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
161     
162     function invest(address ethAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode,uint cycle) public payable{
163 
164         ethAddress = msg.sender;
165   		inputAmount = msg.value;
166         User memory user = userMapping[ethAddress];
167         if(user.status == 1 ){
168             require(user.status == 0, "alreadyinvest,you need to uninvest");
169         }
170         
171         if(!getUserByinviteCode(beInvitedCode)){
172           
173             require(getUserByinviteCode(beInvitedCode),"Code must exit");
174         }
175         
176         if(inputAmount < 1 * ethWei || inputAmount > 10 * ethWei || compareStr(inviteCode,"")){
177           
178             require(inputAmount >= 1 * ethWei && inputAmount <= 10 * ethWei && !compareStr(inviteCode,""), "between 1 and 10 or inviteCode not null");
179             }
180         if(inputAmount < user.lastInvest){
181             require(inputAmount >= user.lastInvest, "invest amount must be more than last");
182         }    
183         if(cycle != 5){
184             require(cycle ==5,"cycle must be 5 days");
185         }
186         totalMoney = totalMoney + inputAmount;
187 
188         
189             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode,1);
190             game.push(invest);
191             sendFeetoKeeper(inputAmount);
192 			sendFeetoInsurance(inputAmount);
193 			sendFeetoReloader(inputAmount);
194 			
195         
196             if(user.isVaild && user.status == 0 ){
197                 
198                 ethAddress.transfer(user.freezeAmount);
199                 user.freezeAmount = inputAmount;
200                 user.status = 1;
201                 user.convertAmount = user.convertAmount + inputAmount/ethWei * 700;
202                 user.cycle = cycle;
203                 userMapping[ethAddress] = user;
204 
205             }else{
206                 user = User(ethAddress,inputAmount,0,inputAmount/ethWei * 700,0,inviteCode,beInvitedCode,0,0,0,0,cycle,1,true,false);
207                 userMapping[ethAddress] = user;
208                 address  ethAddressCode = addressMapping[inviteCode];
209                 if(ethAddressCode == 0x0000000000000000000000000000000000000000){
210                 addressMapping[inviteCode] = ethAddress;
211                 }
212                 address ethAddressParent = addressMapping[beInvitedCode];
213                 User  userParent = userMapping[ethAddressParent];
214                 userParent.inviteCounter = userParent.inviteCounter + 1;
215                 userMapping[ethAddressParent] = userParent;
216                 InviteUsers memory InviteUser = InviteUsers(inviteCode,ethAddress,now);
217                 inviteUsersMapping[ethAddressParent].push(InviteUser);
218                 indexMapping[currentIndex] = ethAddress;
219                 currentIndex = currentIndex + 1;
220             }
221     }
222     function registerUserInfo(address ethAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode ,uint cycle) public onlyOwner {
223         require(actStu == 0,"this action was closed");
224         inputAmount = inputAmount * ethWei;
225         if( inputAmount > 0){
226             BonusGame memory invest = BonusGame(ethAddress,inputAmount,now, inviteCode, beInvitedCode,1);
227             game.push(invest);
228         }
229           User memory user = userMapping[ethAddress];
230             if(user.isVaild){
231                 user.freezeAmount = user.freezeAmount + inputAmount;
232                 user.status = 1;
233                 user.convertAmount = user.convertAmount + inputAmount/ethWei * 700;
234                 user.cycle = cycle;
235                 userMapping[ethAddress] = user;
236             }else{
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
279     function countShareRecommend(uint startLength ,uint endLength) public onlyAdmin {
280         for(uint i = startLength; i <= endLength; i++) {
281             address ethAddress = indexMapping[i];
282             if(ethAddress != 0x0000000000000000000000000000000000000000){
283                 User memory user =  userMapping[ethAddress];
284                 if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
285                     uint depositRate = getDepositRate(user.freezeAmount,user.cycle);
286                     implement(user.beInvitedCode,1,user.freezeAmount,depositRate);
287                 }
288             }
289         }
290     }
291     function countShare(uint startLength,uint endLength) public onlyAdmin {
292         for(uint j = startLength; j<= endLength; j++){
293         
294             address ethAddress1 = indexMapping[j];
295             if(ethAddress1 != 0x0000000000000000000000000000000000000000){
296                 User  user1 =  userMapping[ethAddress1];
297                 ShareBonus memory shareBonus = ShareBonus(ethAddress1,now,user1.dayShareBonus);
298                 shareMappingBonus[ethAddress1].push(shareBonus);
299                 user1.dayShareBonus = 0;
300                 userMapping[ethAddress1] = user1;
301             }
302         }
303     }
304     function sendAward(uint startLength ,uint endLength) public onlyAdmin  {
305          for(uint i = startLength; i <= endLength; i++) {
306             address ethAddress = indexMapping[i];
307             if(ethAddress != 0x0000000000000000000000000000000000000000){
308                 User memory user =  userMapping[ethAddress];
309                 if(user.status == 1){
310                     uint sendMoney =user.toPayment;
311                     if(sendMoney >= (ethWei/20)){
312                         sendMoney = sendMoney - (ethWei/1000);
313                         bool isEnough = false ;
314                         uint resultMoney = 0;
315                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
316                         if(isEnough){
317                             sendMoneyToUser(user.ethAddress,resultMoney);
318                             user.toPayment = 0;
319                             userMapping[ethAddress] = user;
320                         }else{
321                             if(resultMoney > 0 ){
322                                 sendMoneyToUser(user.ethAddress,resultMoney);
323                                 user.toPayment = 0;
324                                 userMapping[ethAddress] = user;
325                             }
326                         }
327                     }
328                 }
329             }
330         }
331     }
332     function implement(string inviteCode,uint runtimes,uint money,uint depositRate) private  returns(string,uint,uint,uint) {
333 
334         string memory codeOne = "null";
335 
336         address  ethAddressCode = addressMapping[inviteCode];
337         User memory user = userMapping[ethAddressCode];
338 
339         if (user.isVaild && runtimes <= 30){
340             codeOne = user.beInvitedCode;
341               if(user.isLock == false){
342                   uint shareLevel = getShareLevel(user.freezeAmount);
343                   uint shareRate = getShareRate(shareLevel,runtimes);
344                   uint moneyResult = 0;
345                   if(user.freezeAmount == 10 * ethWei){
346                       moneyResult = money;
347                   }
348                   else if(money <= (user.freezeAmount)){
349                       moneyResult = money;
350                   }else{
351                       moneyResult = user.freezeAmount;
352                   }
353                   if(runtimes <= 5){
354                       user.convertAmount = user.convertAmount + money/ethWei * 700/100 * 10;
355                       if(user.convertAmount >= 10000){
356                           user.convertAmount = 10000;
357                       }
358                       userMapping[ethAddressCode] = user;
359                   }
360                   if(shareRate != 0){
361                       user.dayShareBonus = user.dayShareBonus + (moneyResult*depositRate*shareRate/1000/100);
362                       user.toPayment = user.toPayment + user.dayShareBonus;
363                       user.allReward = user.allReward + (moneyResult*depositRate*shareRate/1000/100);
364                       userMapping[ethAddressCode] = user;
365                   }
366               }
367               return implement(codeOne,runtimes+1,money,depositRate);
368         }
369         return (codeOne,0,0,0);
370     }
371     function activeToken(address ethAddress,uint inputAmount) public payable{
372         ethAddress = msg.sender;
373   		inputAmount = msg.value;
374         User memory  user = userMapping[ethAddress];
375         uint convertAmount = inputAmount*700/ethWei;
376         if(!getUserByinviteCode(user.inviteCode)){
377           
378             require(getUserByinviteCode(user.inviteCode),"user must exit");
379         }
380         
381         if(convertAmount<=0 || convertAmount > user.convertAmount){
382             require(convertAmount > 0 && convertAmount<= user.convertAmount, "convertAmount error " );
383         }
384         user.convertAmount = user.convertAmount - convertAmount;
385         userMapping[ethAddress] = user;
386         sendtoActiveManager(inputAmount);
387     }
388     function sendMoneyToUser(address ethAddress, uint money) private {
389         
390         address send_to_address = ethAddress;
391         uint256 _eth = money;
392         send_to_address.transfer(_eth);
393 
394     }
395     function isEnoughBalance(uint sendMoney) private view returns (bool,uint){
396 
397         if(address(this).balance > 0 ){
398             if(sendMoney >= address(this).balance){
399                 return (false,address(this).balance);
400             }
401             else{
402                  return (true,sendMoney);
403             }
404         }else{
405              return (false,0);
406         }
407     }
408     function getUserByinviteCode(string inviteCode) public view returns (bool){
409         address  ethAddressCode = addressMapping[inviteCode];
410         User memory user = userMapping[ethAddressCode];
411         if (user.isVaild){
412             return true;
413         }
414         return false;
415     }
416     function getUserInfoByinviteCode(string inviteCode) public view returns (User){
417         address  ethAddressCode = addressMapping[inviteCode];
418         User memory user = userMapping[ethAddressCode];
419         return user;
420         
421     }
422     function getUserByAddress(address ethAddress) public view returns(User){
423             User memory user = userMapping[ethAddress];
424             return user;
425     }
426     function Gameinfo() public view returns(uint,uint,uint,uint,uint){
427         
428         uint contractBalance =  this.balance;
429         return (game.length,currentIndex,actStu,totalMoney,contractBalance);
430         
431     }
432     function sendFeetoKeeper(uint amount) private {
433         
434         address adminAddress = 0xE6a50E19442E07B0B4325E18F946a65fb26D0672;
435         adminAddress.transfer(amount/100*5/100*40);
436         
437     }
438     function sendFeetoInsurance(uint amount) private {
439         
440         address adminAddress = 0x18A8127Ff6e3ab377045C01BdE2B3428A87507dB;
441         adminAddress.transfer(amount/100*5/100*30);
442         
443     }
444     function sendFeetoReloader(uint amount) private {
445         
446         address adminAddress = 0x6f686D6D0179ecD92F31a7E60eA4331A494AFcAE;
447         adminAddress.transfer(amount/100*5/100*30);
448         
449     }
450     function sendtoActiveManager(uint amount) private {
451         
452         address adminAddress = 0x6cF59f499507a2FB5f759B8048F4006049Cf7808;
453         adminAddress.transfer(amount/100*60);
454         
455     }
456     function sendtoManager() onlyOwner{
457          address adminAddress = 0x6cF59f499507a2FB5f759B8048F4006049Cf7808;
458          if(address(this).balance >= totalMaxMoney * ethWei){
459                  adminAddress.transfer(50*ethWei);
460                  totalMaxMoney = totalMaxMoney + 500 * ethWei;
461              }
462     }
463     function closeAct() onlyOwner {
464         
465         actStu = 1;
466         
467     }
468     function getAllUser() public view returns (User [] memory) {
469         
470         for(uint i = 0 ; i <= currentIndex; i++){
471             address ethAddress = indexMapping[i];
472             if(ethAddress != 0x0000000000000000000000000000000000000000){
473                 User memory user = userMapping[ethAddress];
474                 users.push(user);
475             }
476         }
477         return users;
478     }
479     function lockUser(address ethAddress, bool isLock)  onlyAdmin {
480     
481         //require ((msg.sender == 0x8b24767bc01a8fd1969344aaaac886e8f31e905c),"");
482         
483         User user = userMapping[ethAddress];
484         if(isLock == true){
485             user.isLock = true;
486             userMapping[user.ethAddress] =  user;
487         }
488         else if(isLock == false){
489             user.isLock = false;
490             userMapping[user.ethAddress] =  user;
491         }
492         
493     }
494     function getDepositBonus(address ethAddress) public view returns (DepositBonus[] memory){
495         return depositMappingBonus[ethAddress];
496     }
497     function getShareBonus(address ethAddress) public view returns (ShareBonus[] memory){
498         return shareMappingBonus[ethAddress];
499     }
500     function getInviteUsers(address ethAddress) public view returns (InviteUsers[] memory){
501         return inviteUsersMapping[ethAddress];
502     }
503     function getGames() public view returns (BonusGame[] memory){
504         return game;
505     }
506     function sendtoContract() payable {
507     }
508     function gameRestart()  onlyOwner{
509         totalMoney = 0;
510         totalMaxMoney = 500;
511 	    actStu = 0;
512 	    for(uint i = 0; i <= currentIndex; i ++){
513 	        address ethAddress = indexMapping[i];
514             if(ethAddress != 0x0000000000000000000000000000000000000000){
515             User memory user =  userMapping[ethAddress];
516             delete addressMapping[user.inviteCode];
517             delete userMapping[ethAddress];
518             delete indexMapping[i];
519             delete depositMappingBonus[ethAddress];
520             delete shareMappingBonus[ethAddress];
521             delete inviteUsersMapping[ethAddress];
522             }
523 	    }
524 	    currentIndex = 0;
525 	    delete game;
526     }
527 }