1 pragma solidity ^0.4.24;
2 
3 contract Lottery3{
4     using SafeMathLib for *;
5     // mapping(uint256 => uint256) public uintToUint;
6     // mapping(uint256 => mapping(uint256 => uint256)) public uintToUintToUint;
7     // mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) public uintToUintToUintToUint;
8     mapping(uint64 => address) public id_addr;
9 
10     mapping(address => mapping(uint16 => JackpotLib.Ticket3)) public ticketRecs;
11     // mapping(address => mapping(uint16 => uint256)) public ticketRecs;
12     mapping(address => JackpotLib.Player) public players;
13     mapping(uint16 => JackpotLib.Round3) public rounds;
14 
15     uint64 constant private noticePeriod = 10 minutes;//min time between announce and confirm;
16     uint64 constant private claimPeriod = 30 days;//time you have to claim your prize
17     uint16 constant private ticketPrice = 20; //price of single ticket (in the unit)    
18     uint16 constant private prize0 = 18600;//in the unit;
19     uint16 constant private prize1 = 3100;//in the unit;
20     uint16 constant private prize2 = 6200;//in the unit;
21     uint256 constant private unitSize=1e14;//about 0.02 USD
22 
23     uint32 constant private mask0 = 0xC0000000;//[2个1,30个0];这两位应该是空的
24     uint32 constant private mask1 = 0x3FF00000;//[10个1,20个0];
25     uint32 constant private mask2 = 0xFFC00;//[10个1,10个0];
26     uint32 constant private mask3 = 0x3FF;//[10个1];
27     
28     uint64 constant private roundInterval = 1 days;
29 
30     JackpotLib.Status public gameState;
31 
32     
33     
34     //address adminAddr=0xd78CbFB57Ca14Fb4F2c5a5acb78057D637462F9c;
35 
36     address adminAddr=0xdf68C2236bB7e5ac40f4b809CD41C5ab73958643;
37     
38 
39 
40 
41     modifier adminOnly(){
42         require(msg.sender == adminAddr,'Who are you?');
43         _;        
44     }
45     modifier humanOnly() { 
46     require(msg.sender == tx.origin, "Humans only");
47         _;
48     } 
49     constructor() public{          
50         // gameState.baseRound=1;
51         // gameState.baseRoundEndTime=(uint64(now)+roundInterval-1)/roundInterval*roundInterval;  
52         gameState.baseRound=324;
53         gameState.baseRoundEndTime=1543348800;  
54         gameState.numPlayers=0;
55         gameState.currRound=gameState.baseRound;
56         rounds[gameState.baseRound].endTime=gameState.baseRoundEndTime;
57 
58     }
59     function setBaseRound(uint16 baseRound,uint64 baseRoundEndTime)
60         adminOnly()
61         public
62     {
63         gameState.baseRound=baseRound;
64         gameState.baseRoundEndTime=baseRoundEndTime;   
65     }
66 
67     function getBal()
68         public
69         view
70         returns(uint256 balance)
71     {
72         return address(this).balance;
73     }
74 
75 
76     function startRound()//自助新开一轮
77         public//private
78     {
79         require(gameState.baseRound>0,'cannot start round now');
80         uint64 endTime;
81         endTime=(uint64(now)+roundInterval-1)/roundInterval*roundInterval;
82         uint16 round;
83         round=uint16((endTime-gameState.baseRoundEndTime)/roundInterval+gameState.baseRound);
84         rounds[round].endTime=endTime;
85         gameState.currRound=round;
86     }
87     // function startRound(uint16 round, uint64 endTime)
88     //     adminOnly()
89     //     public
90     // {   
91     //     require(rounds[round].endTime==0,'round already started');
92     //     require(endTime>uint64(now),'should end in the future, not in the past');
93     //     if(endTime==0){
94     //         require(rounds[round-1].endTime>0,'you have to provide an endTime');
95     //         rounds[round].endTime=rounds[round-1].endTime+roundInterval; //default value;
96     //     }else
97     //         rounds[round].endTime=endTime;                
98     // }
99     function announceWinningNum(uint16 round,uint16 winningNum0,uint16 winningNum1,uint16 winningNum2)//this can be run multiple times, before starts;
100         adminOnly()//if no winning Num for combo2, the winningNum2 will be 1000(so no one can match it);
101         public
102     {
103         require( uint64(now) > rounds[round].endTime,'round not ended yet, where did you get the numbers?');
104         require( rounds[round].claimStartTime==0 || uint64(now) < rounds[round].claimStartTime, 'claim started, cannot change number');                
105         rounds[round].winningNum0   =winningNum0;
106         rounds[round].winningNum1   =winningNum1;
107         rounds[round].winningNum2   =winningNum2;
108         rounds[round].claimStartTime    =uint64(now)+noticePeriod;
109         rounds[round].claimDeadline     =uint64(now)+noticePeriod+claimPeriod;
110         gameState.lastRound=round;
111     }    
112     function sweep()    
113         adminOnly()
114         public
115     {
116         require(gameState.baseRound==0,'game not ended');
117         require(rounds[gameState.currRound].claimDeadline>0 && rounds[gameState.currRound].claimDeadline < uint64(now),'claim not ended');
118         adminAddr.transfer(address(this).balance);
119     }
120     function checkTicket(address playerAddr,uint16 id)
121         public
122         view
123         returns(
124             uint16 status,//0:未开始兑奖;1.未中奖;2.已兑奖;3.已过期;4.中奖
125             uint16 winningNum0,
126             uint256 prize            
127         )
128     {
129         uint16 winningNum;
130         winningNum0=rounds[ticketRecs[playerAddr][id].round].winningNum0;
131         if(rounds[ticketRecs[playerAddr][id].round].claimStartTime==0 || uint64(now) < rounds[ticketRecs[playerAddr][id].round].claimStartTime){
132             status=0;
133             winningNum=1000;
134             prize=0;            
135         }else{
136             if(ticketRecs[playerAddr][id].ticketType==0){
137                 winningNum=rounds[ticketRecs[playerAddr][id].round].winningNum0;
138                 prize=prize0;
139             }else if(ticketRecs[playerAddr][id].ticketType==1){
140                 winningNum=rounds[ticketRecs[playerAddr][id].round].winningNum1;
141                 prize=prize1;
142             }else if(ticketRecs[playerAddr][id].ticketType==2){
143                 winningNum=rounds[ticketRecs[playerAddr][id].round].winningNum2;
144                 prize=prize2;
145             }else{//combo买法；
146                 winningNum=rounds[ticketRecs[playerAddr][id].round].winningNum0;
147                 prize=prize0;
148             }
149             if(ticketRecs[playerAddr][id].claimed){//已兑奖
150                 status=2;
151             }else if( ticketRecs[playerAddr][id].ticketType==3 ? //根据票的类型用不同的判断条件
152             !checkCombo(ticketRecs[playerAddr][id].numbers,winningNum) :
153              ticketRecs[playerAddr][id].numbers != winningNum){//未中奖
154                 status=1;
155             }else if(rounds[ticketRecs[playerAddr][id].round].claimDeadline<=now){//已过期
156                 status=3;            
157             }else{//中奖
158                 status=4;
159             }
160             if(status==4 || status==2){
161                 prize=unitSize.mul(prize).mul(ticketRecs[playerAddr][id].multiple);
162             }else{
163                 prize=0;
164             }
165             return (status,winningNum0,prize);
166         }        
167     }
168 
169     function claimPrize(uint16 id)        
170         public
171     {        
172         uint16 winningNum;
173         uint16 prize;
174 
175         if(ticketRecs[msg.sender][id].ticketType==0){
176             winningNum=rounds[ticketRecs[msg.sender][id].round].winningNum0;
177             prize=prize0;
178         }else if(ticketRecs[msg.sender][id].ticketType==1){
179             winningNum=rounds[ticketRecs[msg.sender][id].round].winningNum1;
180             prize=prize1;
181         }else if(ticketRecs[msg.sender][id].ticketType==2){
182             winningNum=rounds[ticketRecs[msg.sender][id].round].winningNum2;
183             prize=prize2;
184         }else{//combo;
185             winningNum=rounds[ticketRecs[msg.sender][id].round].winningNum0;
186             prize=prize0;
187         }
188 
189         require(rounds[ticketRecs[msg.sender][id].round].claimStartTime>0,'not announced yet');
190         require(rounds[ticketRecs[msg.sender][id].round].claimStartTime<=now,'claim not started'); //开始兑奖
191         require(rounds[ticketRecs[msg.sender][id].round].claimDeadline>now,'claim already ended'); //在兑奖有效期内
192         if(ticketRecs[msg.sender][id].ticketType==3){//combo的比对方式不太一样
193             require(checkCombo(ticketRecs[msg.sender][id].numbers,winningNum),"you combo didn't cover the lucky number");
194         }else{//普通号码的比对
195             require(ticketRecs[msg.sender][id].numbers == winningNum,"you didn't win"); //号码正确
196         }
197         
198         require(!ticketRecs[msg.sender][id].claimed,'ticket already claimed');  //尚未兑奖
199             
200         ticketRecs[msg.sender][id].claimed=true;            
201         msg.sender.transfer(unitSize.mul(prize).mul(ticketRecs[msg.sender][id].multiple));
202         
203     }
204     function checkCombo(uint32 ticketNumber,uint32 winningNum)
205         public//private
206         pure
207         returns(bool win)
208     {
209         // uint8 i;
210         // uint32 wNum;
211         // for(i=0;i<3;i++){
212         //     num3=winningNum % 10;
213         //     winningNum = winningNum /10;
214         //     if()
215         // }
216 
217         uint32 num3=winningNum % 10;//第三位
218         winningNum = winningNum /10;
219         uint32 num2=winningNum % 10;//第二位
220         winningNum = winningNum /10;
221         uint32 num1=winningNum % 10;//第一位
222         //uint32 winningMask= (uint32(1)<<(num1+20)) + (uint32(1)<<(num2+10)) + (uint32(1)<<num3);        
223 
224         return (ticketNumber & (uint32(1)<<(num1+20))!=0) && 
225             (ticketNumber & (uint32(1)<<(num2+10))!=0) && 
226             (ticketNumber & (uint32(1)<<num3)!=0);
227     }
228     function register(address playerAddr)
229         private
230     {   
231         if(players[playerAddr].id==0){
232             players[playerAddr].id=++gameState.numPlayers;
233             players[playerAddr].registerOn=uint64(now);
234             id_addr[gameState.numPlayers]=playerAddr;        
235         }
236     }
237     
238     function buyTicket(address owner,uint8 ticketType,uint32 numbers,uint16 multiple) 
239         humanOnly()
240         public
241         payable
242     {
243         address player;
244         if(owner==address(0))
245             player=msg.sender;
246         else
247             player=owner;
248         register(player);
249         if(ticketType>2)//只有三种玩法
250             ticketType=2;
251         // require(rounds[round].endTime>0 ,'round not started');
252         // require(rounds[round].endTime > uint64(now), 'round already ended');
253         if(rounds[gameState.currRound].endTime<=uint64(now))
254             // player=player;
255             startRound();
256 
257         uint256 amt=unitSize.mul(ticketPrice).mul(multiple);
258         require(msg.value >= amt,'insufficient fund');
259         amt=msg.value-amt;//exchange;
260         uint16 numTickets=(players[player].numTickets)+1;
261         require(numTickets > players[player].numTickets,'you played too much');
262         require(numbers <= 999,'wrong number');
263 
264         ticketRecs[player][numTickets]=JackpotLib.Ticket3(false,ticketType,gameState.currRound,multiple,numbers,uint64(now));
265         // ticketRecs[player][numTickets]=JackpotLib.Ticket3(false,1,1,numbers,multiple,uint64(now));
266         // ticketRecs[msg.sender][1]=JackpotLib.Ticket3(false,1,1,1,1,uint64(now));   
267         players[player].numTickets=numTickets;
268                         
269         if(amt>0){//refund exchange; has to be the last step;
270             (msg.sender).transfer(amt);//always refund to sender;
271         }
272     }   
273     function countChoice(uint32 number)//数最后10位里面有多个1;
274         public//private
275         pure
276         returns(uint16 count)
277     {
278         count=0;
279         uint8 i;
280         for(i=0;i<10;i++){
281             if(number%2 == 1)
282                 count++;
283             number=number/2;
284         }
285         return count;
286     }
287 
288     function buyCombo(address owner,uint32 numbers,uint16 multiple) 
289         humanOnly()
290         public
291         payable
292     {
293         address player;
294         if(owner==address(0))
295             player=msg.sender;
296         else
297             player=owner;
298         register(player);
299         //combo的玩法type=3;
300         
301         if(rounds[gameState.currRound].endTime<=uint64(now))            
302             startRound();
303 
304         //计算票价:
305         require(mask0 & numbers == 0,'wrong num: first 2 bits should be empty');
306         uint16 combos=countChoice(numbers);//最后10位
307         require(combos !=0, 'wrong num: select numbers for slot 3');
308         combos*=countChoice(numbers>>10);//接下来10位
309         require(combos !=0, 'wrong num: select numbers for slot 2');
310         combos*=countChoice(numbers>>20);//最后10位
311         require(combos !=0, 'wrong num: select numbers for slot 1');
312         
313         uint256 amt=unitSize.mul(ticketPrice).mul(multiple).mul(combos);
314         require(msg.value >= amt,'insufficient fund');
315         amt=msg.value-amt;//exchange;
316         uint16 numTickets=(players[player].numTickets)+1;
317         require(numTickets > players[player].numTickets,'you played too much');        
318 
319         ticketRecs[player][numTickets]=JackpotLib.Ticket3(false,3,gameState.currRound,multiple,numbers,uint64(now));        
320         players[player].numTickets=numTickets;
321                         
322         if(amt>0){//refund exchange; has to be the last step;
323             (msg.sender).transfer(amt);//always refund to sender;
324         }
325     }       
326     // function abc(){
327     //     ticketRecs[msg.sender][1]=JackpotLib.Ticket3(false,1,1,1,1,uint64(now));        
328     // }
329 }
330 
331 library JackpotLib{
332 	struct Ticket3{		
333 		bool claimed;//
334 		uint8 ticketType;//0,single;1,combo1;2combo2;
335 		uint16 round;		
336 		uint16 multiple;
337 		uint32 numbers;
338 		uint64 soldOn;//购票时间
339 	}
340 	// struct Ticket5{		
341 	// 	bool claimed;//		
342 	// 	uint16 round;		
343 	// 	uint16 multiple;
344 	// 	uint32 numbers;
345 	// 	uint64 soldOn;//购票时间
346 	// }
347 	struct Player{
348 		uint16 id;
349 		uint16 numTickets;
350 		uint64 registerOn;//注册时间
351 	}
352 	struct Status{
353 		uint16 lastRound;
354 		uint16 currRound;
355 		uint16 numPlayers;
356 		uint16 baseRound;
357 		uint64 baseRoundEndTime;
358 		uint64 reserve;
359 	}
360 
361 	struct Round3{
362 		uint64 endTime;		//ending time
363 		uint64 claimStartTime;//
364 		uint64 claimDeadline;//
365 		uint16 winningNum0;
366 		uint16 winningNum1;
367 		uint16 winningNum2;
368 	}
369 	// struct Round5{
370 	// 	uint64 endTime;		//ending time
371 	// 	uint64 claimStartTime;//
372 	// 	uint64 claimDeadline;//
373 	// 	uint32 winningNum0;		
374 	// }
375 
376 	
377 }
378 
379 library SafeMathLib {
380     
381   /**
382   * @dev Multiplies two numbers, throws on overflow.
383   */
384   function mul(uint256 a, uint256 b) 
385       internal 
386       pure 
387       returns (uint256 c) 
388   {
389     if (a == 0) {
390       return 0;
391     }
392     c = a * b;
393     require(c / a == b, "SafeMath mul failed");
394     return c;
395   }
396 
397   /**
398   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
399   */
400   function sub(uint256 a, uint256 b)
401       internal
402       pure
403       returns (uint256) 
404   {
405     require(b <= a, "SafeMath sub failed");
406     return a - b;
407   }
408 
409   /**
410   * @dev Adds two numbers, throws on overflow.
411   */
412   function add(uint256 a, uint256 b)
413       internal
414       pure
415       returns (uint256 c) 
416   {
417     c = a + b;
418     require(c >= a, "SafeMath add failed");
419     return c;
420   }
421   
422   /**
423     * @dev gives square root of given x.
424     */
425   function sqrt(uint256 x)
426       internal
427       pure
428       returns (uint256 y) 
429   {
430     uint256 z = ((add(x,1)) / 2);
431     y = x;
432     while (z < y) 
433     {
434       y = z;
435       z = ((add((x / z),z)) / 2);
436     }
437   }
438   
439   /**
440     * @dev gives square. multiplies x by x
441     */
442   function sq(uint256 x)
443       internal
444       pure
445       returns (uint256)
446   {
447     return (mul(x,x));
448   }
449   
450   /**
451     * @dev x to the power of y 
452     */
453   function pwr(uint256 x, uint256 y)
454       internal 
455       pure 
456       returns (uint256)
457   {
458     if (x==0)
459         return (0);
460     else if (y==0)
461         return (1);
462     else 
463     {
464       uint256 z = x;
465       for (uint256 i = 1; i < y; i++)
466         z = mul(z,x);
467       return (z);
468     }
469   }
470 }