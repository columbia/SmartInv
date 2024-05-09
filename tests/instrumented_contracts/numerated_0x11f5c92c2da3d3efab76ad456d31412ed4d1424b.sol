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
28 	bool isRecommendOver = false;
29 	uint countTimes = 0;
30 	uint recommendTimes = 0;
31 	uint sendTimes = 0;
32 	address private owner;
33 	
34 	constructor () public {
35         owner = msg.sender;
36     }
37 	struct User{
38 
39         address userAddress;
40         uint freeAmount;
41         uint freezeAmount;
42         uint rechargeAmount;
43         uint withdrawlsAmount;
44         uint inviteAmonut;
45         uint bonusAmount;
46         uint dayInviteAmonut;
47         uint dayBonusAmount;
48         uint level;
49         uint resTime;
50         uint lineAmount;
51         uint lineLevel;
52         string inviteCode;
53         string beInvitedCode;
54 		
55 		uint isline;
56 		uint status; 
57 		bool isVaild;
58     }
59     
60     struct Invest{
61 
62         address userAddress;
63         uint inputAmount;
64         uint resTime;
65         string inviteCode;
66         string beInvitedCode;
67 		
68 		uint isline;
69 		
70 		uint status; 
71     }
72     
73     mapping (address => User) userMapping;
74     mapping (string => address) addressMapping;
75     mapping (uint => address) indexMapping;
76     
77     Invest[] invests;
78     UtilFairWin  util = UtilFairWin(0x90468D04ba71A1a2F5187d7B2Ef0cb5c3a355660);
79     
80     modifier onlyOwner {
81         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
82         _;
83     }
84     
85      function invest(address userAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode) public payable{
86         
87         userAddress = msg.sender;
88   		inputAmount = msg.value;
89         uint lineAmount = inputAmount;
90         if(inputAmount < 1* ethWei || inputAmount > 15* ethWei || util.compareStr(inviteCode,"") ||  util.compareStr(beInvitedCode,"")){
91              userAddress.transfer(msg.value);
92                 require(inputAmount >= 1* ethWei && inputAmount <= 15* ethWei && !util.compareStr(inviteCode,"") && !util.compareStr(beInvitedCode,""), "inputAmount must between 1 and 15");
93         }
94         User storage userTest = userMapping[userAddress];
95         if(userTest.isVaild && userTest.status != 2){
96             if((userTest.lineAmount + userTest.freezeAmount + lineAmount)> (15 * ethWei)){
97                 userAddress.transfer(msg.value);
98                 require((userTest.lineAmount + userTest.freezeAmount + lineAmount) <= 15 * ethWei,"freeze and line can not beyond 15 eth");
99                 return;
100             }
101         }
102        leijiMoney = leijiMoney + inputAmount;
103         leijiCount = leijiCount + 1;
104         bool isLine = false;
105         
106         uint level =util.getlevel(inputAmount);
107         uint lineLevel = util.getLineLevel(lineAmount);
108         if(beginTime==1){
109             lineAmount = 0;
110             oneDayCount = oneDayCount + inputAmount;
111             Invest memory invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,1,1);
112             invests.push(invest);
113             sendFeetoAdmin(inputAmount);
114         }else{
115             allCount = allCount + inputAmount;
116             isLine = true;
117             invest = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,0,1);
118             inputAmount = 0;
119             invests.push(invest);
120         }
121           User memory user = userMapping[userAddress];
122             if(user.isVaild && user.status == 1){
123                 user.freezeAmount = user.freezeAmount + inputAmount;
124                 user.rechargeAmount = user.rechargeAmount + inputAmount;
125                 user.lineAmount = user.lineAmount + lineAmount;
126                 level =util.getlevel(user.freezeAmount);
127                 lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount +user.lineAmount);
128                 user.level = level;
129                 user.lineLevel = lineLevel;
130                 userMapping[userAddress] = user;
131                 
132             }else{
133                 if(isLine){
134                     level = 0;
135                 }
136                 if(user.isVaild){
137                    inviteCode = user.inviteCode;
138                    beInvitedCode = user.beInvitedCode;
139                 }
140                 user = User(userAddress,0,inputAmount,inputAmount,0,0,0,0,0,level,now,lineAmount,lineLevel,inviteCode, beInvitedCode ,1,1,true);
141                 userMapping[userAddress] = user;
142                 
143                 indexMapping[currentIndex] = userAddress;
144                 currentIndex = currentIndex + 1;
145             }
146             address  userAddressCode = addressMapping[inviteCode];
147             if(userAddressCode == 0x0000000000000000000000000000000000000000){
148                 addressMapping[inviteCode] = userAddress;
149             }
150         
151     }
152      
153     function userWithDraw(address userAddress) public{
154         bool success = false;
155         require (msg.sender == userAddress, "acoount diffrent");
156         
157         uint lineMoney = 0;
158         uint sendMoney = 0; 
159          User memory user = userMapping[userAddress];
160          sendMoney = lineMoney + user.freeAmount;
161          
162         bool isEnough = false ;
163         uint resultMoney = 0;
164         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
165         
166             user.withdrawlsAmount =user.withdrawlsAmount + resultMoney;
167             user.freeAmount = lineMoney + user.freeAmount - resultMoney;
168            //user.freeAmount = sendMoney;
169             user.level = util.getlevel(user.freezeAmount);
170             user.lineAmount = 0;
171             user.lineLevel = util.getLineLevel(user.freezeAmount + user.freeAmount);
172             userMapping[userAddress] = user;
173             if(resultMoney > 0 ){
174                 userAddress.transfer(resultMoney);
175             }
176     }
177 
178     //
179     function countShareAndRecommendedAward(uint startLength ,uint endLength,uint times) external onlyOwner {
180          require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
181 
182         for(uint i = startLength; i < endLength; i++) {
183             Invest memory invest = invests[i];
184              address  userAddressCode = addressMapping[invest.inviteCode];
185             User memory user = userMapping[userAddressCode];
186             if(invest.isline==1 && invest.status == 1 && now < (invest.resTime + 5 days)){
187 
188                uint bili = util.getBiliBylevel(user.level);
189                 user.dayBonusAmount =user.dayBonusAmount + bili*invest.inputAmount/1000;
190                 user.bonusAmount = user.bonusAmount + bili*invest.inputAmount/1000;
191                 userMapping[userAddressCode] = user;
192                
193             }
194             if(invest.isline==1 && invest.status == 1 && now >= (invest.resTime + 5 days)){
195                 invests[i].status = 2;
196                 user.freezeAmount = user.freezeAmount - invest.inputAmount;
197                 user.freeAmount = user.freeAmount + invest.inputAmount;
198                 user.level = util.getlevel(user.freezeAmount);
199                 userMapping[userAddressCode] = user;
200             }
201         }
202         countTimes = countTimes +1;
203         if(times <= countTimes){ 
204             isCountOver = true;
205         }
206     }
207     
208     function countRecommend(uint startLength ,uint endLength,uint times)  external onlyOwner {
209         
210          require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
211          for(uint i = startLength; i <= endLength; i++) {
212              
213             address userAddress = indexMapping[i];
214             if(userAddress != 0x0000000000000000000000000000000000000000){
215                 
216                 User memory user =  userMapping[userAddress];
217                 if(user.status == 1 && user.freezeAmount >= 1 * ethWei){
218                     uint bili = util.getBiliBylevel(user.level);
219                     execute(user.beInvitedCode,1,user.freezeAmount,bili);
220                 }
221             }
222         }
223         recommendTimes = recommendTimes +1;
224         if(times <= recommendTimes){ 
225             isRecommendOver = true;
226         }
227     }
228     
229     
230     function execute(string inviteCode,uint runtimes,uint money,uint shareBi) public  returns(string,uint,uint,uint) {
231         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
232         string memory codeOne = "null";
233         
234         address  userAddressCode = addressMapping[inviteCode];
235         User memory user = userMapping[userAddressCode];
236         if (user.isVaild){
237             codeOne = user.beInvitedCode;
238               if(user.status == 1){
239                   
240                   uint fireBi = util.getFireBiliBylevel(user.lineLevel);
241                   uint recommendBi = util.getRecommendBiliBylevelandDai(user.lineLevel,runtimes);
242                   uint moneyResult = 0;
243                   
244                   if(money <= (user.freezeAmount+user.lineAmount+user.freeAmount)){
245                       moneyResult = money;
246                   }else{
247                       moneyResult = user.freezeAmount+user.lineAmount+user.freeAmount;
248                   }
249                   
250                   if(recommendBi != 0){
251                       user.dayInviteAmonut =user.dayInviteAmonut + (moneyResult*shareBi*fireBi*recommendBi/1000/10/100);
252                       user.inviteAmonut = user.inviteAmonut + (moneyResult*shareBi*fireBi*recommendBi/1000/10/100);
253                       userMapping[userAddressCode] = user;
254                   }
255               }
256               return execute(codeOne,runtimes+1,money,shareBi);
257         }
258         return (codeOne,0,0,0);
259 
260     }
261     
262     function sendMoneyToUser(address userAddress, uint money) private {
263         address send_to_address = userAddress;
264         uint256 _eth = money;
265         send_to_address.transfer(_eth);
266         
267     }
268 
269     function sendAward(uint startLength ,uint endLength,uint times) public {
270         
271          daySendMoney = 0;
272          require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
273          
274          for(uint i = startLength; i <= endLength; i++) {
275              
276             address userAddress = indexMapping[i];
277             if(userAddress != 0x0000000000000000000000000000000000000000){
278                 
279                 User memory user =  userMapping[userAddress];
280                 if(user.status == 1){
281                     uint sendMoney =user.dayInviteAmonut + user.dayBonusAmount;
282                     
283                     if(sendMoney >= (ethWei/10)){
284                          sendMoney = sendMoney - (ethWei/1000);  
285                         bool isEnough = false ;
286                         uint resultMoney = 0;
287                         (isEnough,resultMoney) = isEnoughBalance(sendMoney);
288                         if(isEnough){
289                              daySendMoney =daySendMoney + resultMoney;
290                             sendMoneyToUser(user.userAddress,resultMoney);
291                             //
292                             user.dayInviteAmonut = 0;
293                             user.dayBonusAmount = 0;
294                             userMapping[userAddress] = user;
295                         }else{
296                             userMapping[userAddress] = user;
297                             if(sendMoney > 0 ){
298                                 daySendMoney =daySendMoney + resultMoney;
299                                 sendMoneyToUser(user.userAddress,resultMoney);
300                                 user.dayInviteAmonut = 0;
301                                 user.dayBonusAmount = 0;
302                                 userMapping[userAddress] = user;
303                             }
304                         }
305                     }
306                 }
307             }
308         }
309         sendTimes = sendTimes + 1;
310         if(sendTimes >= times){ 
311             isRecommendOver = false;
312             isCountOver = false;
313             countTimes = 0;
314         	recommendTimes = 0;
315         	sendTimes = 0;
316         }
317     }
318 
319     function isEnoughBalance(uint sendMoney) public view returns (bool,uint){
320         
321         if(this.balance > 0 ){
322              if(sendMoney >= this.balance){
323                 if((this.balance ) > 0){
324                     return (false,this.balance); 
325                 }else{
326                     return (false,0);
327                 }
328             }else{
329                  return (true,sendMoney);
330             }
331         }else{
332              return (false,0);
333         }
334     }
335     
336     function getUserByAddress(address userAddress) public view returns(uint,uint,uint,uint,uint,uint,uint,uint,uint,string,string,uint){
337 
338             User memory user = userMapping[userAddress];
339             return (user.lineAmount,user.freeAmount,user.freezeAmount,user.inviteAmonut,
340             user.bonusAmount,user.lineLevel,user.status,user.dayInviteAmonut,user.dayBonusAmount,user.inviteCode,user.beInvitedCode,user.level);
341     } 
342     function getUserByinviteCode(string inviteCode) public view returns (bool){
343         
344         address  userAddressCode = addressMapping[inviteCode];
345         User memory user = userMapping[userAddressCode];
346       if (user.isVaild){
347             return true;
348       }
349         return false;
350     }
351     function getPingtaiInfo() public view returns(uint,uint,uint){
352         return(leijiMoney,leijiCount,beginTime);
353     }
354     function getStatus() public view returns(uint,uint,uint){
355         return(countTimes,recommendTimes,sendTimes);
356     }
357    
358     function test() public view returns(bool,bool,uint,uint){
359         return (isRecommendOver,isCountOver,invests.length,currentIndex);
360     }
361      function sendFeetoAdmin(uint amount){
362         address adminAddress = 0x854D359A586244c9E02B57a3770a4dC21Ffcaa8d;
363         adminAddress.transfer(amount/25);
364     }
365 }