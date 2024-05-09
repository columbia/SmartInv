1 pragma solidity 0.5.0;
2 contract LuckUtils{
3     struct User{
4         address raddr;
5         uint8 valid;
6         uint recode;
7     }
8     struct Wallet{
9         uint last_invest;
10         uint profit_d;
11         uint index;
12         uint8 status;
13         uint profit_s;
14         uint profit;
15         uint amount;
16         uint rn;
17     }
18     struct Invset{
19         uint amount;
20         uint8 lv;
21         uint8 day;
22         uint8 share;
23         address addr;
24         uint8 notDone;
25         uint time;
26     }
27     struct Journal{
28         uint amount;
29         uint8 tag;
30         uint time;
31     }
32     address private owner = 0x008C35450C696a9312Aef0f45d0813056Cc57759;
33     uint private uinwei = 1 ether;
34     uint private minAmount = 1;
35     uint private maxAmount1 = 5;
36     uint private maxAmount2 = 10;
37     uint private maxAmount3 = 50;
38     constructor()public {
39         owner = msg.sender;
40     }
41 
42     modifier IsOwner{
43         require(msg.sender==owner,"not owner");
44         _;
45     }
46 
47     function pstatic(uint256 amount,uint8 lv) public pure returns(uint256){
48         if(lv==1){
49             return amount*5/1000;
50         }else if(lv==2){
51             return amount/100;
52         }else if(lv==3){
53             return amount*12/1000;
54         }
55         return 0;
56     }
57 
58     function pdynamic(uint256 uinam,uint8 uLv,uint256 rei,uint8 riL2,uint remRn,uint256 layer) public pure returns(uint256){
59         uint256 samount = 0;
60         if(uinam<=0){
61             return 0;
62         }else if(rei<=0){
63             return 0;
64         }else if(riL2==3||rei>uinam){
65             samount = pstatic(uinam,uLv);
66         }else{
67             samount = pstatic(rei,uLv);
68         }
69 
70         if(riL2 == 1){
71             if(layer==1){
72                 return samount/2;
73             }else if(layer==2){
74                 return samount/5;
75             }else if(layer==3){
76                 return samount/10;
77             }else{
78                 return 0;
79             }
80         }else if(riL2 == 2||riL2 == 3){
81             if(layer==1){
82                 return samount;
83             }else if(layer==2){
84                 return samount*70/100;
85             }else if(layer==3){
86                 return samount/2;
87             }else if(layer>=4&&layer<=10){
88                 return samount/10;
89             }else if(layer>=11&&layer<=20){
90                 return samount*5/100;
91             }else if(layer>=21&&remRn>=2){
92                 return samount/100;
93             }else{
94                 return 0;
95             }
96         }else{
97             return 0;
98         }
99     }
100 
101     function check(uint amount,uint open3)public view returns (bool,uint8){
102 
103         if(amount%uinwei != 0){
104             return (false,0);
105         }
106 
107         uint amountEth = amount/uinwei;
108 
109         if(amountEth>=minAmount&&amountEth<=maxAmount1){
110             return (true,1);
111         }else if(amountEth>maxAmount1&&amountEth<=maxAmount2){
112             return (true,2);
113         }else if(open3==1&&amountEth>maxAmount2&&amountEth<=maxAmount3){
114             return (true,3);
115         }else{
116             return (false,0);
117         }
118     }
119 
120     function isSufficient(uint amount,uint betPool,uint riskPool,uint thisBln) public pure returns(bool,uint256){
121         if(amount>0&&betPool>amount){
122             if(thisBln>riskPool){
123                 uint256 balance = thisBln-riskPool;
124                 if(balance>=amount){
125                     return (true,amount);
126                 }
127                 return (false,balance);
128             }
129         }
130         return (false,0);
131     }
132 
133     function currTimeInSeconds() public view returns (uint256){
134         return block.timestamp;
135     }
136 }
137 contract Luck100 {
138     LuckUtils utils = LuckUtils(0x89DB21870d8b0520cc793dE78923B6beaaa321Df);
139     mapping(address => mapping (uint => LuckUtils.Wallet)) private wallet;
140     mapping(uint => LuckUtils.Invset) private invsets;
141     mapping(address => LuckUtils.User) private accounts;
142     mapping(address =>uint) private manage;
143     mapping(uint =>address) private CodeMapAddr;
144     mapping(address =>address[]) private RemAddrs;
145     mapping(address =>LuckUtils.Journal[]) private IncomeRecord;
146 
147     address private owner = 0x008C35450C696a9312Aef0f45d0813056Cc57759;
148     uint256 private InvsetIndex = 10000;
149     uint256 private UserCount = 0;
150     uint256 private betPool = 0;
151     uint256 private riskPool = 0;
152     uint256 private invest_total = 0;
153     uint256 private revert_last_invest = 0;
154     uint256 private revert_each_amount = 0;
155 
156     uint private uinwei = 1 ether;
157     uint private open3 = 0;
158     uint8 private online = 0;
159     uint private reVer = 1;
160     uint private isRestart = 0;
161     uint private start_time;
162 
163     constructor()public {
164         owner = msg.sender;
165         start_time = utils.currTimeInSeconds();
166     }
167 
168     modifier IsOwner{
169         require(msg.sender==owner,"not owner");
170         _;
171     }
172 
173     modifier IsManage{
174         require(msg.sender==owner||manage[msg.sender]==1,"not manage");
175         _;
176     }
177 
178     event Entry(address addr,address raddr, uint amount,uint ver, uint index,uint time,uint8 status);
179     event Extract(address addr,uint amount,uint8 etype);
180     event ResetLog(uint reVer,uint time,uint nowIndex);
181 
182     function () external payable{
183     }
184     function entry(address reAddr) public payable{
185         require(reAddr!=owner,"Can't be the contract address");
186         require(isRestart==0,"Currently restarting");
187         uint256  payamount = msg.value;
188         (bool isverify,uint8 lv) = utils.check(payamount,open3);
189         require(isverify,"amount error");
190         require(wallet[msg.sender][reVer].status==0||wallet[msg.sender][reVer].status==1,"Assets already in investment");
191 
192         if(accounts[msg.sender].valid == 0){
193             require(accounts[reAddr].valid==1,"Recommended address is invalid");
194             require(msg.sender!=reAddr,"Invitation address is invalid");
195             handel(msg.sender,payamount,reAddr,lv,0);
196         }else{
197             handel(msg.sender,payamount,accounts[msg.sender].raddr,lv,1);
198         }
199         sendRisk(payamount);
200     }
201     function reInvest() public {
202         require(isRestart==0,"Currently restarting");
203         require(wallet[msg.sender][reVer].status==1,"No Reinvestment");
204 
205         uint payamount = wallet[msg.sender][reVer].amount;
206         (bool isverify,uint8 lv) = utils.check(payamount,open3);
207         require(isverify,"amount error");
208         wallet[msg.sender][reVer].amount = 0;
209 
210         handel(msg.sender,payamount,accounts[msg.sender].raddr,lv,1);
211         sendRisk(payamount);
212     }
213     function handel(address addr,uint amount,address reAddr,uint8 lv,uint8 status) private{
214         uint last_inv_profit = wallet[addr][reVer].profit_d;
215         if(last_inv_profit>0){
216             require(amount>=wallet[addr][reVer].last_invest,"Assets already in investment");
217         }
218         InvsetIndex = InvsetIndex+1;
219         uint256 nowIndex = InvsetIndex;
220         if(accounts[addr].valid == 0){
221             uint remCode = 4692475*nowIndex;
222             accounts[addr].recode = remCode;
223             accounts[addr].valid = 1;
224             accounts[addr].raddr = reAddr;
225             CodeMapAddr[remCode] = addr;
226             RemAddrs[reAddr].push(addr);
227         }
228 
229         wallet[addr][reVer].index = nowIndex;
230         wallet[addr][reVer].status = 2;
231         wallet[addr][reVer].profit_s = 0;
232         wallet[addr][reVer].profit_d = 0;
233         wallet[addr][reVer].last_invest = amount;
234 
235         if(lv>=2){
236             wallet[reAddr][reVer].rn = wallet[reAddr][reVer].rn+1;
237         }
238         uint time = utils.currTimeInSeconds();
239         invsets[nowIndex] = LuckUtils.Invset(amount,lv,0,0,addr,1,time);
240         emit Entry(addr,reAddr,amount,reVer,nowIndex,time,status);
241 
242         if(last_inv_profit>0){
243             (bool isCan,uint avail_profit) = utils.isSufficient(last_inv_profit,betPool,riskPool,address(this).balance);
244             if((!isCan)&&avail_profit>0){
245                 EventRestart();
246             }
247             if(avail_profit>0){
248                 if(last_inv_profit>avail_profit){
249                     wallet[addr][reVer].profit_d = last_inv_profit-avail_profit;
250                 }else{
251                     wallet[addr][reVer].profit_d = 0;
252                 }
253                 IncomeRecord[addr].push(LuckUtils.Journal(avail_profit,2,time));
254                 address payable DynamicAddr = address(uint160(addr));
255                 DynamicAddr.transfer(avail_profit);
256             }
257         }
258     }
259     function profit(uint256 start,uint time)public IsManage returns(uint){
260         require(isRestart==0,"Currently restarting");
261         uint nowtime = time;
262         if(nowtime<=0){
263             nowtime = utils.currTimeInSeconds();
264         }
265         if(open3==0&&time-start_time >= 2592000){
266             open3 = 1;
267         }
268         if(!itemProfit(start,nowtime)){
269             return 0;
270         }
271         address addr = invsets[start].addr;
272         if(wallet[addr][reVer].profit>=0.1 ether){
273             (bool isCan,uint myProfit) = utils.isSufficient(wallet[addr][reVer].profit,betPool,riskPool,address(this).balance);
274             if(isCan){
275                 wallet[addr][reVer].profit = 0;
276                 address payable StaticAddr = address(uint160(addr));
277                 StaticAddr.transfer(myProfit);
278             }
279         }
280         return 1;
281     }
282     function itemProfit(uint256 arrayIndex,uint time) private returns(bool){
283         LuckUtils.Invset memory inv = invsets[arrayIndex];
284         if(time-inv.time < 86400){
285             return false;
286         }
287         if(inv.day<5&&wallet[inv.addr][reVer].status==2){
288             uint8 day = invsets[arrayIndex].day + 1;
289             uint256 profit_s = utils.pstatic(inv.amount,inv.lv);
290             wallet[inv.addr][reVer].profit_s = wallet[inv.addr][reVer].profit_s + profit_s;
291             wallet[inv.addr][reVer].profit = wallet[inv.addr][reVer].profit + profit_s;
292             invsets[arrayIndex].day = day;
293             invsets[arrayIndex].time = time;
294 
295             if(day>=5){
296                 invsets[arrayIndex].notDone = 0;
297                 wallet[inv.addr][reVer].status = 1;
298                 wallet[inv.addr][reVer].amount = wallet[inv.addr][reVer].amount + inv.amount;
299 
300                 if(inv.lv>=2){
301                     if(wallet[accounts[inv.addr].raddr][reVer].rn>0){
302                         wallet[accounts[inv.addr].raddr][reVer].rn = wallet[accounts[inv.addr].raddr][reVer].rn-1;
303                     }
304                 }
305             }
306             IncomeRecord[inv.addr].push(LuckUtils.Journal(profit_s,1,utils.currTimeInSeconds()));
307             return true;
308         }else{
309             invsets[arrayIndex].notDone = 0;
310         }
311         return false;
312     }
313     function shareProfit(uint index) public IsManage{
314         require(invsets[index].share>=0&&invsets[index].share<5,"Settlement completed");
315         require(invsets[index].share<invsets[index].day,"Unable to release dynamic revenue");
316         LuckUtils.Invset memory inv = invsets[index];
317         invsets[index].share = invsets[index].share+1;
318         remProfit(accounts[inv.addr].raddr,inv.amount,inv.lv);
319     }
320     function remProfit(address raddr,uint256 amount,uint8 inv_lv) private{
321         address nowRaddr = raddr;
322         LuckUtils.Wallet memory remWallet = wallet[nowRaddr][reVer];
323         uint256 layer = 1;
324         while(accounts[nowRaddr].valid>0&&layer<=100){
325             if(remWallet.status==2){
326                 uint256 profit_d = utils.pdynamic(amount,inv_lv,invsets[remWallet.index].amount,invsets[remWallet.index].lv,remWallet.rn,layer);
327                 if(profit_d>0){
328                     wallet[nowRaddr][reVer].profit_d = wallet[nowRaddr][reVer].profit_d + profit_d;
329                 }
330             }
331             nowRaddr = accounts[nowRaddr].raddr;
332             remWallet = wallet[nowRaddr][reVer];
333             layer = layer+1;
334         }
335     }
336     function reset_sett()public{
337         require(isRestart==1,"Can't restart");
338         isRestart = 2;
339         uint amountTotal = riskPool - 16000000000000000000;
340         if(amountTotal<address(this).balance){
341             amountTotal = address(this).balance;
342         }
343         uint256 startIndex = InvsetIndex-99;
344         revert_last_invest = 0;
345         for(uint256 nowIndex = 0;nowIndex<100&&startIndex+nowIndex<=InvsetIndex;nowIndex = nowIndex+1){
346             revert_last_invest = revert_last_invest + invsets[nowIndex+startIndex].amount;
347         }
348         revert_last_invest = revert_last_invest/uinwei;
349         revert_each_amount = amountTotal/revert_last_invest;
350         resetSend(startIndex,InvsetIndex-80);
351     }
352     function reset()public{
353         require(isRestart==2,"Can't restart");
354         isRestart = 0;
355         uint256 startIndex = InvsetIndex-79;
356         uint256 endIndex = InvsetIndex;
357         InvsetIndex = InvsetIndex + 100;
358         reVer = reVer+1;
359         betPool = 0;
360         riskPool = 0;
361         open3 = 0;
362         UserCount = 0;
363         invest_total = 0;
364         start_time = utils.currTimeInSeconds();
365         resetSend(startIndex,endIndex);
366     }
367     function resetSend(uint startIndex,uint endIndex)private{
368         uint256 userAmount = 0;
369         LuckUtils.Invset memory inv;
370         for(uint256 sendUserIndex = startIndex;sendUserIndex<=endIndex;sendUserIndex = sendUserIndex+1){
371             inv = invsets[sendUserIndex];
372             userAmount = inv.amount/uinwei*revert_each_amount;
373             emit Extract(inv.addr,userAmount,10);
374             if(userAmount>0){
375                 if(userAmount>address(this).balance){
376                     userAmount = address(this).balance;
377                 }
378                 address payable InvAddr = address(uint160(inv.addr));
379                 InvAddr.transfer(userAmount);
380             }
381         }
382         uint RewardAmount = 8000000000000000000;
383         if(address(this).balance<RewardAmount){
384             RewardAmount = address(this).balance;
385         }
386         msg.sender.transfer(RewardAmount);
387     }
388     function iline()public IsOwner{
389         online = 1;
390         open3 = 0;
391     }
392     function EventRestart() private {
393         if(UserCount>=100){
394            isRestart = 1;
395            emit ResetLog(reVer,utils.currTimeInSeconds(),InvsetIndex);
396         }
397     }
398     function test(address addr,address reAddr,uint amount) public IsOwner{
399         require(online==0,"exit");
400         (bool isverify,uint8 lv) = utils.check(amount,open3);
401         require(isverify,"amount error");
402         require(wallet[addr][reVer].status==0||wallet[addr][reVer].status==1,"Assets already in investment");
403         if(accounts[addr].valid == 0){
404             handel(addr,amount,reAddr,lv,0);
405         }else{
406             handel(addr,amount,accounts[addr].raddr,lv,1);
407         }
408     }
409     function withdraw(uint8 withtype) public{
410         require(accounts[msg.sender].valid>0&&isRestart==0&&withtype>=2&&withtype<=3, "Invalid operation");
411         uint balance = 0;
412         if(withtype==2){
413             balance = wallet[msg.sender][reVer].amount;
414         }else if(withtype==3){
415             balance = wallet[msg.sender][reVer].profit;
416         }
417         (bool isCan,uint amount) = utils.isSufficient(balance,betPool,riskPool,address(this).balance);
418         require(amount>0&&balance>=amount, "Insufficient withdrawable amount");
419         if(withtype==2){
420             wallet[msg.sender][reVer].amount = wallet[msg.sender][reVer].amount-amount;
421         }else if(withtype==3){
422             wallet[msg.sender][reVer].profit = wallet[msg.sender][reVer].profit-amount;
423         }
424         if(!isCan){
425             EventRestart();
426         }
427         emit Extract(msg.sender,amount,withtype);
428         msg.sender.transfer(amount);
429     }
430     function sendRisk(uint payamount) private{
431         invest_total = invest_total+payamount;
432         UserCount = UserCount+1;
433         uint riskAmount = payamount*6/100;
434         uint adminMoeny = payamount/25;
435         riskPool = riskPool+riskAmount;
436         betPool = betPool+(payamount-riskPool-adminMoeny);
437         if(address(this).balance>=adminMoeny){
438             address payable SendCommunity = 0x493601dAFE2D6c6937df3f0AD13Fa6bAF12dFa00;
439             SendCommunity.transfer(adminMoeny);
440         }
441     }
442     function getInfo() public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
443         uint256 blance = address(this).balance;
444         return (InvsetIndex,betPool,riskPool,invest_total,UserCount,online,reVer,open3,isRestart,start_time,blance,revert_last_invest);
445     }
446     function getInv(uint arrayIndex) public view IsManage returns(uint,uint8,uint8,address,uint8,uint,address,uint,uint8,uint){
447         LuckUtils.Invset memory inv = invsets[arrayIndex];
448         return (inv.amount,inv.lv,inv.day,inv.addr,inv.notDone,inv.time,accounts[inv.addr].raddr,isRestart,inv.share,reVer);
449     }
450     function lastInvest() public view returns(address[] memory){
451         if(UserCount<=100){
452             address[] memory notLastAssr = new address[](0);
453             return notLastAssr;
454         }
455         uint lastIndex = InvsetIndex;
456         address[] memory lastAddr = new address[](100);
457         for(uint i = 0;i<100;i = i+1){
458             if(invsets[lastIndex-i].amount<=0){
459                 return (lastAddr);
460             }
461             lastAddr[i] = invsets[lastIndex-i].addr;
462         }
463         return (lastAddr);
464     }
465     function remAddr(address addr,uint page) public view returns(address[] memory,uint[] memory,uint[] memory){
466         require(page>0,"Invalid page number");
467         if(RemAddrs[addr].length<=0){
468             return (new address[](0),new uint[](0),new uint[](0));
469         }
470         address[] memory rAddr = new address[](10);
471         uint[] memory rInvAm = new uint[](10);
472         uint[] memory rNum = new uint[](10);
473         uint startIdx = (page-1)*10;
474         for(uint i = 0;i<=10&&i+startIdx<RemAddrs[addr].length;i = i+1){
475             address  itemAddr = RemAddrs[addr][startIdx+i];
476             rAddr[i] = itemAddr;
477             if(wallet[itemAddr][reVer].status==2){
478                 rInvAm[i] = wallet[itemAddr][reVer].last_invest;
479             }
480             rNum[i] = RemAddrs[itemAddr].length;
481         }
482         return (rAddr,rInvAm,rNum);
483     }
484     function journal()public view returns(uint[] memory,uint[] memory){
485         uint[] memory amount = new uint[](20);
486         uint[] memory time = new uint[](20);
487         uint data_index = 0;
488         for(uint i = IncomeRecord[msg.sender].length+10;i>10&&data_index<20;i = i-1){
489             LuckUtils.Journal memory jrnal = IncomeRecord[msg.sender][i-11];
490             amount[data_index] = jrnal.amount;
491             time[data_index] = jrnal.time;
492             data_index = data_index+1;
493         }
494         return (amount,time);
495     }
496     function GetCode(uint code)public view returns(address){
497         return CodeMapAddr[code];
498     }
499     function userInfo(address addr) public view returns(uint256[] memory){
500         require(msg.sender==addr||manage[msg.sender]==1||msg.sender==owner,"not found");
501         LuckUtils.Wallet memory myWalt = wallet[addr][reVer];
502         uint256[] memory lastAddr = new uint256[](14);
503         lastAddr[0] = myWalt.amount;
504         lastAddr[1] = myWalt.profit_s;
505         lastAddr[2] = myWalt.last_invest;
506         lastAddr[3] = myWalt.profit_d;
507         lastAddr[4] = myWalt.profit;
508         lastAddr[5] = invsets[myWalt.index].amount;
509         lastAddr[6] = myWalt.status;
510         lastAddr[7] = invsets[myWalt.index].day;
511         lastAddr[8] = invsets[myWalt.index].lv;
512         lastAddr[9] = invsets[myWalt.index].time;
513         lastAddr[10] = myWalt.rn;
514         lastAddr[11] = myWalt.index;
515         lastAddr[12] = accounts[addr].valid;
516         lastAddr[13] = accounts[addr].recode;
517 
518         return lastAddr;
519     }
520     function setManage(address addr,uint status) public IsOwner{
521         if(status==1){
522             manage[addr] = 1;
523         }else{
524             manage[addr] = 0;
525         }
526     }
527 }