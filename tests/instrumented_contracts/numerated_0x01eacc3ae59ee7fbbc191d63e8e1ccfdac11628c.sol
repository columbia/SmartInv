1 pragma solidity ^0.4.24;
2 
3 contract UtilFairWin  {
4    
5     /* fairwin.me */
6     
7     function getRecommendScaleBylevelandTim(uint level,uint times) public view returns(uint);
8     function compareStr (string _str,string str) public view returns(bool);
9     function getLineLevel(uint value) public view returns(uint);
10     function getScBylevel(uint level) public view returns(uint);
11     function getFireScBylevel(uint level) public view returns(uint);
12     function getlevel(uint value) public view returns(uint);
13 }
14 contract FairWin {
15     
16      /* fairwin.me */
17      
18     uint ethWei = 1 ether;
19     uint allCount = 0;
20     uint oneDayCount = 0;
21     uint totalMoney = 0;
22     uint totalCount = 0;
23 	uint private beginTime = 1;
24     uint lineCountTimes = 1;
25 	uint private currentIndex = 0;
26 	address private owner;
27 	uint private actStu = 0;
28 	
29 	constructor () public {
30         owner = msg.sender;
31     }
32 	struct User{
33 
34         address userAddress;
35         uint freeAmount;
36         uint freezeAmount;
37         uint rechargeAmount;
38         uint withdrawlsAmount;
39         uint inviteAmonut;
40         uint bonusAmount;
41         uint dayInviteAmonut;
42         uint dayBonusAmount;
43         uint level;
44         uint resTime;
45         uint lineAmount;
46         uint lineLevel;
47         string inviteCode;
48         string beInvitedCode;
49 		uint isline;
50 		uint status; 
51 		bool isVaild;
52     }
53     
54     struct Invest{
55 
56         address userAddress;
57         uint inputAmount;
58         uint resTime;
59         string inviteCode;
60         string beInvitedCode;
61 		uint isline;
62 		uint status; 
63 		uint times;
64     }
65     
66     mapping (address => User) userMapping;
67     mapping (string => address) addressMapping;
68     mapping (uint => address) indexMapping;
69     
70     Invest[] invests;
71     UtilFairWin  util = UtilFairWin(0x5Ec8515d15C758472f3E1A7B9eCa3e996E8Ba902);
72     
73     modifier onlyOwner {
74         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
75         _;
76     }
77     
78     function () public payable {
79     }
80     
81      function invest(address userAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode) public payable{
82         
83         userAddress = msg.sender;
84   		inputAmount = msg.value;
85         uint lineAmount = inputAmount;
86         
87         if(!getUserByinviteCode(beInvitedCode)){
88             userAddress.transfer(msg.value);
89             require(getUserByinviteCode(beInvitedCode),"Code must exit");
90         }
91         if(inputAmount < 1* ethWei || inputAmount > 15* ethWei || util.compareStr(inviteCode,"")){
92              userAddress.transfer(msg.value);
93                 require(inputAmount >= 1* ethWei && inputAmount <= 15* ethWei && !util.compareStr(inviteCode,""), "between 1 and 15");
94         }
95         User storage userTest = userMapping[userAddress];
96         if(userTest.isVaild && userTest.status != 2){
97             if((userTest.lineAmount + userTest.freezeAmount + lineAmount)> (15 * ethWei)){
98                 userAddress.transfer(msg.value);
99                 require((userTest.lineAmount + userTest.freezeAmount + lineAmount) <= 15 * ethWei,"can not beyond 15 eth");
100                 return;
101             }
102         }
103        totalMoney = totalMoney + inputAmount;
104         totalCount = totalCount + 1;
105         bool isLine = false;
106         
107         uint level =util.getlevel(inputAmount);
108         uint lineLevel = util.getLineLevel(lineAmount);
109         if(beginTime==1){
110             lineAmount = 0;
111             oneDayCount = oneDayCount + inputAmount;
112             Invest memory invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,1,1,0);
113             invests.push(invest);
114             sendFeetoAdmin(inputAmount);
115         }else{
116             allCount = allCount + inputAmount;
117             isLine = true;
118             invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,0,1,0);
119             inputAmount = 0;
120             invests.push(invest);
121         }
122           User memory user = userMapping[userAddress];
123             if(user.isVaild && user.status == 1){
124                 user.freezeAmount = user.freezeAmount + inputAmount;
125                 user.rechargeAmount = user.rechargeAmount + inputAmount;
126                 user.lineAmount = user.lineAmount + lineAmount;
127                 level =util.getlevel(user.freezeAmount);
128                 lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount +user.lineAmount);
129                 user.level = level;
130                 user.lineLevel = lineLevel;
131                 userMapping[userAddress] = user;
132                 
133             }else{
134                 if(isLine){
135                     level = 0;
136                 }
137                 if(user.isVaild){
138                    inviteCode = user.inviteCode;
139                    beInvitedCode = user.beInvitedCode;
140                 }
141                 user = User(userAddress,0,inputAmount,inputAmount,0,0,0,0,0,level,now,lineAmount,lineLevel,inviteCode, beInvitedCode ,1,1,true);
142                 userMapping[userAddress] = user;
143                 
144                 indexMapping[currentIndex] = userAddress;
145                 currentIndex = currentIndex + 1;
146             }
147             address  userAddressCode = addressMapping[inviteCode];
148             if(userAddressCode == 0x0000000000000000000000000000000000000000){
149                 addressMapping[inviteCode] = userAddress;
150             }
151         
152     }
153      
154       function remedy(address userAddress ,uint freezeAmount,string  inviteCode,string  beInvitedCode ,uint freeAmount,uint times) public {
155         require(actStu == 0,"this action was closed");
156         freezeAmount = freezeAmount * ethWei;
157         freeAmount = freeAmount * ethWei;
158         uint level =util.getlevel(freezeAmount);
159         uint lineLevel = util.getLineLevel(freezeAmount + freeAmount);
160         if(beginTime==1 && freezeAmount > 0){
161             Invest memory invest = Invest(userAddress,freezeAmount,now, inviteCode, beInvitedCode ,1,1,times);
162             invests.push(invest);
163         }
164           User memory user = userMapping[userAddress];
165             if(user.isVaild){
166                 user.freeAmount = user.freeAmount + freeAmount;
167                 user.freezeAmount = user.freezeAmount +  freezeAmount;
168                 user.rechargeAmount = user.rechargeAmount + freezeAmount +freezeAmount;
169                 user.level =util.getlevel(user.freezeAmount);
170                 user.lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount +user.lineAmount);
171                 userMapping[userAddress] = user;
172             }else{
173                 user = User(userAddress,freeAmount,freezeAmount,freeAmount+freezeAmount,0,0,0,0,0,level,now,0,lineLevel,inviteCode, beInvitedCode ,1,1,true);
174                 userMapping[userAddress] = user;
175                 
176                 indexMapping[currentIndex] = userAddress;
177                 currentIndex = currentIndex + 1;
178             }
179             address  userAddressCode = addressMapping[inviteCode];
180             if(userAddressCode == 0x0000000000000000000000000000000000000000){
181                 addressMapping[inviteCode] = userAddress;
182             }
183         
184     }
185      
186     function userWithDraw(address userAddress) public{
187         bool success = false;
188         require (msg.sender == userAddress, "account diffrent");
189         
190          User memory user = userMapping[userAddress];
191          uint sendMoney  = user.freeAmount;
192          
193         bool isEnough = false ;
194         uint resultMoney = 0;
195         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
196         
197             user.withdrawlsAmount =user.withdrawlsAmount + resultMoney;
198             user.freeAmount = user.freeAmount - resultMoney;
199             user.level = util.getlevel(user.freezeAmount);
200             user.lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount);
201             userMapping[userAddress] = user;
202             if(resultMoney > 0 ){
203                 userAddress.transfer(resultMoney);
204             }
205     }
206 
207     //
208     function countShareAndRecommendedAward(uint startLength ,uint endLength,uint times) external onlyOwner {
209 
210         for(uint i = startLength; i < endLength; i++) {
211             Invest memory invest = invests[i];
212              address  userAddressCode = addressMapping[invest.inviteCode];
213             User memory user = userMapping[userAddressCode];
214             if(invest.isline==1 && invest.status == 1 && now < (invest.resTime + 5 days) && invest.times <5){
215              invests[i].times = invest.times + 1;
216                uint scale = util.getScBylevel(user.level);
217                 user.dayBonusAmount =user.dayBonusAmount + scale*invest.inputAmount/1000;
218                 user.bonusAmount = user.bonusAmount + scale*invest.inputAmount/1000;
219                 userMapping[userAddressCode] = user;
220                
221             }else if(invest.isline==1 && invest.status == 1 && ( now >= (invest.resTime + 5 days) || invest.times >= 5 )){
222                 invests[i].status = 2;
223                 user.freezeAmount = user.freezeAmount - invest.inputAmount;
224                 user.freeAmount = user.freeAmount + invest.inputAmount;
225                 user.level = util.getlevel(user.freezeAmount);
226                 userMapping[userAddressCode] = user;
227             }
228         }
229     }
230     
231     function countRecommend(uint startLength ,uint endLength,uint times) public {
232         require ((msg.sender == owner || msg.sender == 0xa0fEE185742f6C257bf590f1Bb29aC2B18257069 || msg.sender == 0x9C09Edc8c34192183c6222EFb4BC3BA2cC1FA5Fd
233                 || msg.sender == 0x56E8cA06E849FA7db60f8Ffb0DD655FDD3deb17a || msg.sender == 0x4B8C5cec33A3A54f365a165b9AdAA01A9F377A7E || msg.sender == 0x25c5981E71CF1063C6Fc8b6F03293C03A153180e
234                 || msg.sender == 0x31E58402B99a9e7C41039A2725D6cE9c61b6e319), "");
235          for(uint i = startLength; i <= endLength; i++) {
236              
237             address userAddress = indexMapping[i];
238             if(userAddress != 0x0000000000000000000000000000000000000000){
239                 
240                 User memory user =  userMapping[userAddress];
241                 if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
242                     uint scale = util.getScBylevel(user.level);
243                     execute(user.beInvitedCode,1,user.freezeAmount,scale);
244                 }
245             }
246         }
247     }
248     
249     
250     function execute(string inviteCode,uint runtimes,uint money,uint shareSc) private  returns(string,uint,uint,uint) {
251  
252         string memory codeOne = "null";
253         
254         address  userAddressCode = addressMapping[inviteCode];
255         User memory user = userMapping[userAddressCode];
256         
257         if (user.isVaild && runtimes <= 25){
258             codeOne = user.beInvitedCode;
259               if(user.status == 1){
260                   
261                   uint fireSc = util.getFireScBylevel(user.lineLevel);
262                   uint recommendSc = util.getRecommendScaleBylevelandTim(user.lineLevel,runtimes);
263                   uint moneyResult = 0;
264                   
265                   if(money <= (user.freezeAmount+user.lineAmount+user.freeAmount)){
266                       moneyResult = money;
267                   }else{
268                       moneyResult = user.freezeAmount+user.lineAmount+user.freeAmount;
269                   }
270                   
271                   if(recommendSc != 0){
272                       user.dayInviteAmonut =user.dayInviteAmonut + (moneyResult*shareSc*fireSc*recommendSc/1000/10/100);
273                       user.inviteAmonut = user.inviteAmonut + (moneyResult*shareSc*fireSc*recommendSc/1000/10/100);
274                       userMapping[userAddressCode] = user;
275                   }
276               }
277               return execute(codeOne,runtimes+1,money,shareSc);
278         }
279         return (codeOne,0,0,0);
280 
281     }
282     
283     function sendMoneyToUser(address userAddress, uint money) private {
284         address send_to_address = userAddress;
285         uint256 _eth = money;
286         send_to_address.transfer(_eth);
287         
288     }
289 
290     function sendAward(uint startLength ,uint endLength,uint times)  external onlyOwner  {
291         
292          for(uint i = startLength; i <= endLength; i++) {
293              
294             address userAddress = indexMapping[i];
295             if(userAddress != 0x0000000000000000000000000000000000000000){
296                 
297                 User memory user =  userMapping[userAddress];
298                 if(user.status == 1){
299                     uint sendMoney =user.dayInviteAmonut + user.dayBonusAmount;
300                     
301                     if(sendMoney >= (ethWei/10)){
302                          sendMoney = sendMoney - (ethWei/1000);  
303                         bool isEnough = false ;
304                         uint resultMoney = 0;
305                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
306                         if(isEnough){
307                             sendMoneyToUser(user.userAddress,resultMoney);
308                             //
309                             user.dayInviteAmonut = 0;
310                             user.dayBonusAmount = 0;
311                             userMapping[userAddress] = user;
312                         }else{
313                             userMapping[userAddress] = user;
314                             if(sendMoney > 0 ){
315                                 sendMoneyToUser(user.userAddress,resultMoney);
316                                 user.dayInviteAmonut = 0;
317                                 user.dayBonusAmount = 0;
318                                 userMapping[userAddress] = user;
319                             }
320                         }
321                     }
322                 }
323             }
324         }
325     }
326 
327     function isEnoughBalance(uint sendMoney) private view returns (bool,uint){
328         
329         if(this.balance > 0 ){
330              if(sendMoney >= this.balance){
331                 if((this.balance ) > 0){
332                     return (false,this.balance); 
333                 }else{
334                     return (false,0);
335                 }
336             }else{
337                  return (true,sendMoney);
338             }
339         }else{
340              return (false,0);
341         }
342     }
343     
344     function getUserByAddress(address userAddress) public view returns(uint,uint,uint,uint,uint,uint,uint,uint,uint,string,string,uint){
345 
346             User memory user = userMapping[userAddress];
347             return (user.lineAmount,user.freeAmount,user.freezeAmount,user.inviteAmonut,
348             user.bonusAmount,user.lineLevel,user.status,user.dayInviteAmonut,user.dayBonusAmount,user.inviteCode,user.beInvitedCode,user.level);
349     } 
350     function getUserByinviteCode(string inviteCode) public view returns (bool){
351         
352         address  userAddressCode = addressMapping[inviteCode];
353         User memory user = userMapping[userAddressCode];
354       if (user.isVaild){
355             return true;
356       }
357         return false;
358     }
359     function getSomeInfo() public view returns(uint,uint,uint){
360         return(totalMoney,totalCount,beginTime);
361     }
362     function test() public view returns(uint,uint,uint){
363         return (invests.length,currentIndex,actStu);
364     }
365      function sendFeetoAdmin(uint amount) private {
366         address adminAddress = 0x854D359A586244c9E02B57a3770a4dC21Ffcaa8d;
367         adminAddress.transfer(amount/25);
368     }
369     function closeAct()  external onlyOwner {
370         actStu = 1;
371     }
372 }