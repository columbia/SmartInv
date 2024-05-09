1 pragma solidity ^0.4.24;
2 
3 contract UtilFairWin  {
4    
5     /* fairwin.me */
6     
7     function getRecommendBiliBylevelandDai(uint level,uint dai) public view returns(uint);
8     function compareStr (string _str,string str) public view returns(bool);
9     function getLineLevel(uint value) public view returns(uint);
10     function getBiliBylevel(uint level) public view returns(uint);
11     function getFireBiliBylevel(uint level) public view returns(uint);
12     function getlevel(uint value) public view returns(uint);
13 }
14 contract FairWin {
15     
16      /* fairwin.me */
17      
18     uint ethWei = 1 ether;
19     uint allCount = 0;
20     uint oneDayCount = 0;
21     uint leijiMoney = 0;
22     uint leijiCount = 0;
23 	uint  beginTime = 1;
24     uint lineCountTimes = 1;
25     uint daySendMoney = 0;
26 	uint currentIndex = 0;
27 	bool isCountOver = false;
28 	bool isRecommend = false;
29 	address private owner;
30 	
31 	uint countCurrentIndex = 0;
32 	bool countCurrentOverStatus = true;
33 	
34 	uint sendCurrentIndex = 0;
35 	bool sendCurrentOverStatus = true;
36 	
37 	uint recommendCurrentIndex = 0;
38 	bool recommendCurrentOverStatus = true;
39 	
40 	constructor () public {
41         owner = msg.sender;
42     }
43 	struct User{
44 
45         address userAddress;
46         uint freeAmount;
47         uint freezeAmount;
48         uint rechargeAmount;
49         uint withdrawlsAmount;
50         uint inviteAmonut;
51         uint bonusAmount;
52         uint dayInviteAmonut;
53         uint dayBonusAmount;
54         uint level;
55         uint resTime;
56         uint lineAmount;
57         uint lineLevel;
58         string inviteCode;
59         string beInvitedCode;
60 		
61 		uint isline;
62 		uint status; 
63 		bool isVaild;
64     }
65     
66     struct Invest{
67 
68         address userAddress;
69         uint inputAmount;
70         uint resTime;
71         string inviteCode;
72         string beInvitedCode;
73 		
74 		uint isline;
75 		
76 		uint status; 
77     }
78     
79     mapping (address => User) userMapping;
80     mapping (string => address) addressMapping;
81     mapping (uint => address) indexMapping;
82     
83     Invest[] invests;
84     UtilFairWin  util = UtilFairWin(0x90468D04ba71A1a2F5187d7B2Ef0cb5c3a355660);
85     
86     modifier onlyOwner {
87         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
88         _;
89     }
90     
91      function invest(address userAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode) public payable{
92         
93         userAddress = msg.sender;
94   		inputAmount = msg.value;
95         uint lineAmount = inputAmount;
96         if(inputAmount < 1* ethWei || inputAmount > 15* ethWei || util.compareStr(inviteCode,"") ||  util.compareStr(beInvitedCode,"")){
97              userAddress.transfer(msg.value);
98                 require(inputAmount >= 1* ethWei && inputAmount <= 15* ethWei && !util.compareStr(inviteCode,"") && !util.compareStr(beInvitedCode,""), "inputAmount must between 1 and 15");
99         }
100         User storage userTest = userMapping[userAddress];
101         if(userTest.isVaild && userTest.status != 2){
102             if((userTest.lineAmount + userTest.freezeAmount + lineAmount)> (15 * ethWei)){
103                 userAddress.transfer(msg.value);
104                 require((userTest.lineAmount + userTest.freezeAmount + lineAmount) <= 15 * ethWei,"freeze and line can not beyond 15 eth");
105                 return;
106             }
107         }
108        leijiMoney = leijiMoney + inputAmount;
109         leijiCount = leijiCount + 1;
110         bool isLine = false;
111         
112         uint level =util.getlevel(inputAmount);
113         uint lineLevel = util.getLineLevel(lineAmount);
114         if(beginTime==1){
115             lineAmount = 0;
116             oneDayCount = oneDayCount + inputAmount;
117             Invest memory invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,1,1);
118             invests.push(invest);
119             sendFeetoAdmin(inputAmount);
120         }else{
121             allCount = allCount + inputAmount;
122             isLine = true;
123             invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,0,1);
124             inputAmount = 0;
125             invests.push(invest);
126         }
127           User memory user = userMapping[userAddress];
128             if(user.isVaild && user.status == 1){
129                 user.freezeAmount = user.freezeAmount + inputAmount;
130                 user.rechargeAmount = user.rechargeAmount + inputAmount;
131                 user.lineAmount = user.lineAmount + lineAmount;
132                 level =util.getlevel(user.freezeAmount);
133                 lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount +user.lineAmount);
134                 user.level = level;
135                 user.lineLevel = lineLevel;
136                 userMapping[userAddress] = user;
137                 
138             }else{
139                 if(isLine){
140                     level = 0;
141                 }
142                 if(user.isVaild){
143                    inviteCode = user.inviteCode;
144                    beInvitedCode = user.beInvitedCode;
145                 }
146                 user = User(userAddress,0,inputAmount,inputAmount,0,0,0,0,0,level,now,lineAmount,lineLevel,inviteCode, beInvitedCode ,1,1,true);
147                 userMapping[userAddress] = user;
148                 
149                 indexMapping[currentIndex] = userAddress;
150                 currentIndex = currentIndex + 1;
151             }
152             address  userAddressCode = addressMapping[inviteCode];
153             if(userAddressCode == 0x0000000000000000000000000000000000000000){
154                 addressMapping[inviteCode] = userAddress;
155             }
156         
157     }
158      
159     function userWithDraw(address userAddress) public{
160         bool success = false;
161         require (msg.sender == userAddress, "acoount diffrent");
162         
163         uint lineMoney = 0;
164         uint sendMoney = 0; 
165          User memory user = userMapping[userAddress];
166          sendMoney = lineMoney + user.freeAmount;
167          
168         bool isEnough = false ;
169         uint resultMoney = 0;
170         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
171         
172             user.withdrawlsAmount =user.withdrawlsAmount + resultMoney;
173             user.freeAmount = lineMoney + user.freeAmount - resultMoney;
174            //user.freeAmount = sendMoney;
175             user.level = util.getlevel(user.freezeAmount);
176             user.lineAmount = 0;
177             user.lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount);
178             userMapping[userAddress] = user;
179             if(resultMoney > 0 ){
180                 userAddress.transfer(resultMoney);
181             }
182     }
183 
184     //
185     function countShareAndRecommendedAward() external onlyOwner {
186          require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
187          bool lastCountAction = false;
188 
189          uint countIndex = 0;
190          if((countCurrentIndex + 101) >= invests.length ){
191              countIndex = invests.length;
192              lastCountAction = true;
193          }else{
194              countIndex = countCurrentIndex +101;
195          }
196         for(uint i = countCurrentIndex; i < countIndex; i++) {
197             Invest memory invest = invests[i];
198              address  userAddressCode = addressMapping[invest.inviteCode];
199             User memory user = userMapping[userAddressCode];
200             if(invest.isline==1 && invest.status == 1 && now < (invest.resTime + 5 days)){
201 
202                uint bili = util.getBiliBylevel(user.level);
203                 user.dayBonusAmount =user.dayBonusAmount + bili*invest.inputAmount/1000;
204                 user.bonusAmount = user.bonusAmount + bili*invest.inputAmount/1000;
205                 userMapping[userAddressCode] = user;
206                
207             }
208             if(invest.isline==1 && invest.status == 1 && now >= (invest.resTime + 5 days)){
209                 invests[i].status = 2;
210                 user.freezeAmount = user.freezeAmount - invest.inputAmount;
211                 user.freeAmount = user.freeAmount + invest.inputAmount;
212                 user.level = util.getlevel(user.freezeAmount);
213                 userMapping[userAddressCode] = user;
214             }
215         }
216         countCurrentOverStatus = !countCurrentOverStatus;
217         if(lastCountAction){ 
218             isCountOver = true;
219             countCurrentIndex = 0;
220             countCurrentOverStatus = true;
221         }
222     }
223     
224     function countRecommend()  external onlyOwner {
225         
226          require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
227          bool lastSendAction = false;
228          uint sendIndex = 0;
229          if((recommendCurrentIndex + 100) >= currentIndex ){
230              sendIndex = invests.length;
231              lastSendAction = true;
232          }else{
233              sendIndex = recommendCurrentIndex +100;
234          }
235          
236          for(uint i = recommendCurrentIndex; i <= sendIndex; i++) {
237              
238             address userAddress = indexMapping[i];
239             if(userAddress != 0x0000000000000000000000000000000000000000){
240                 
241                 User memory user =  userMapping[userAddress];
242                 if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
243                     uint bili = util.getBiliBylevel(user.level);
244                     execute(user.beInvitedCode,1,user.freezeAmount,bili);
245                 }
246             }
247         }
248         recommendCurrentOverStatus = !recommendCurrentOverStatus;
249         if(lastSendAction){ 
250             recommendCurrentIndex = 0;
251             recommendCurrentOverStatus =true;
252             isRecommend = true;
253         }
254     }
255     
256     
257     function execute(string inviteCode,uint runtimes,uint money,uint shareBi) public  returns(string,uint,uint,uint) {
258         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
259         string memory codeOne = "null";
260         
261         address  userAddressCode = addressMapping[inviteCode];
262         User memory user = userMapping[userAddressCode];
263         if (user.isVaild){
264             codeOne = user.beInvitedCode;
265               if(user.status == 1){
266                   
267                   uint fireBi = util.getFireBiliBylevel(user.lineLevel);
268                   uint recommendBi = util.getRecommendBiliBylevelandDai(user.lineLevel,runtimes);
269                   uint moneyResult = 0;
270                   
271                   if(money <= (user.freezeAmount+user.lineAmount+user.freeAmount)){
272                       moneyResult = money;
273                   }else{
274                       moneyResult = user.freezeAmount+user.lineAmount+user.freeAmount;
275                   }
276                   
277                   if(recommendBi != 0){
278                       user.dayInviteAmonut =user.dayInviteAmonut + (moneyResult*shareBi*fireBi*recommendBi/1000/10/100);
279                       user.inviteAmonut = user.inviteAmonut + (moneyResult*shareBi*fireBi*recommendBi/1000/10/100);
280                       userMapping[userAddressCode] = user;
281                   }
282               }
283               return execute(codeOne,runtimes+1,money,shareBi);
284         }
285         return (codeOne,0,0,0);
286 
287     }
288     
289     function sendMoneyToUser(address userAddress, uint money) private {
290         address send_to_address = userAddress;
291         uint256 _eth = money;
292         send_to_address.transfer(_eth);
293         
294     }
295 
296     function sendAward() public {
297         
298          daySendMoney = 0;
299          require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
300          bool lastSendAction = false;
301          uint sendIndex = 0;
302          if((sendCurrentIndex + 100) >= currentIndex ){
303              sendIndex = invests.length;
304              lastSendAction = true;
305          }else{
306              sendIndex = sendCurrentIndex +100;
307          }
308          
309          for(uint i = sendCurrentIndex; i <= sendIndex; i++) {
310              
311             address userAddress = indexMapping[i];
312             if(userAddress != 0x0000000000000000000000000000000000000000){
313                 
314                 User memory user =  userMapping[userAddress];
315                 if(user.status == 1){
316                     uint sendMoney =user.dayInviteAmonut + user.dayBonusAmount;
317                     
318                     if(sendMoney >= (ethWei/10)){
319                          sendMoney = sendMoney - (ethWei/1000);  
320                         bool isEnough = false ;
321                         uint resultMoney = 0;
322                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
323                         if(isEnough){
324                              daySendMoney =daySendMoney + resultMoney;
325                             sendMoneyToUser(user.userAddress,resultMoney);
326                             //
327                             user.dayInviteAmonut = 0;
328                             user.dayBonusAmount = 0;
329                             userMapping[userAddress] = user;
330                         }else{
331                             userMapping[userAddress] = user;
332                             if(sendMoney > 0 ){
333                                 daySendMoney =daySendMoney + resultMoney;
334                                 sendMoneyToUser(user.userAddress,resultMoney);
335                                 user.dayInviteAmonut = 0;
336                                 user.dayBonusAmount = 0;
337                                 userMapping[userAddress] = user;
338                             }
339                         }
340                     }
341                 }
342             }
343         }
344         sendCurrentOverStatus = !sendCurrentOverStatus;
345         if(lastSendAction){ 
346             isRecommend = false;
347             isCountOver = false;
348             sendCurrentIndex = 0;
349             sendCurrentOverStatus =true;
350         }
351     }
352 
353     function isEnoughBalance(uint sendMoney) public view returns (bool,uint){
354         
355         if(this.balance > 0 ){
356              if(sendMoney >= this.balance){
357                 if((this.balance ) > 0){
358                     return (false,this.balance); 
359                 }else{
360                     return (false,0);
361                 }
362             }else{
363                  return (true,sendMoney);
364             }
365         }else{
366              return (false,0);
367         }
368         
369     }
370     
371     function getUserByAddress(address userAddress) public view returns(uint,uint,uint,uint,uint,uint,uint,uint,uint,string,string,uint){
372 
373             User memory user = userMapping[userAddress];
374             return (user.lineAmount,user.freeAmount,user.freezeAmount,user.inviteAmonut,
375             user.bonusAmount,user.lineLevel,user.status,user.dayInviteAmonut,user.dayBonusAmount,user.inviteCode,user.beInvitedCode,user.level);
376     } 
377     function getUserByinviteCode(string inviteCode) public view returns (bool){
378         
379         address  userAddressCode = addressMapping[inviteCode];
380         User memory user = userMapping[userAddressCode];
381       if (user.isVaild){
382             return true;
383       }
384         return false;
385     }
386     function getPingtaiInfo() public view returns(uint,uint,uint){
387         return(leijiMoney,leijiCount,beginTime);
388     }
389 
390     function getCountStatus() public view returns(bool){
391         return isCountOver;
392     }
393    
394     function test() public view returns(bool,bool,uint,bool,bool,bool){
395         return (countCurrentOverStatus,isCountOver,countCurrentIndex,sendCurrentOverStatus,isRecommend,recommendCurrentOverStatus);
396     }
397      function sendFeetoAdmin(uint amount){
398         address adminAddress = 0x854D359A586244c9E02B57a3770a4dC21Ffcaa8d;
399         adminAddress.transfer(amount/25);
400     }
401 }