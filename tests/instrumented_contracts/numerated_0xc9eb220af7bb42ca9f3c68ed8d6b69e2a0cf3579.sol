1 pragma solidity ^0.4.24;
2 library Datasets {
3     struct Player {
4         uint256 currentroundIn0;
5         uint256 currentroundIn1;
6         uint256 allRoundIn;
7         uint256 win;    // total winnings vault
8         uint256 lastwin;
9         uint256 withdrawed;
10     }
11     struct Round {
12         uint256 strt;   // height round started
13         uint256 end;    // height round ended
14         bool ended;
15         uint256 etc0;//etc for bull
16         uint256 etc1;//etc for bear
17         int win;//0 for bull,1 for bear
18     }
19     struct totalData{
20         uint256 bullTotalIn;
21         uint256 bearTotalIn;
22         uint256 bullTotalWin;
23         uint256 bearTotalWin;
24     }
25 }
26 contract Lotteryevents {
27     event onBuys
28     (
29         address addr,
30         uint256 amount,
31         uint8 _team
32     );
33     event onWithdraw
34     (
35         address playerAddress,
36         uint256 out,
37         uint256 timeStamp
38     );
39     event onBuyAndDistribute
40     (
41         uint256 rid,
42         uint256 strt,   // height round started
43         uint256 end,    // height round ended
44         uint256 etc0,//etc for bull
45         uint256 etc1,//etc for bear
46         int win//0 for bull,1 for bear
47     );
48 }
49 contract NXlottery is Lotteryevents{
50     using SafeMath for *;
51     uint8 constant private rndGap_ = 100;
52     uint8 constant private lotteryHei_ = 10;
53     uint8 constant private fee = 5;
54     uint8 constant private maxLimit=200;
55     uint256 constant private splitThreshold=3000000000000000000;
56     uint256 private feeLeft=0;
57     address private creator;
58     Datasets.Round private currRound;
59     Datasets.Round private lastRound;//lastRound=currRound when clearing
60     uint256 private rID_=1;    // round id number / total rounds that have happened
61     address[] private allAddress;//allAddress.push(addre)
62     mapping (address => Datasets.Player) private allPlayer;
63     Datasets.totalData private total;
64     constructor() public {
65         creator = msg.sender;
66         uint256 curr=block.number;
67         currRound.strt = curr;
68         currRound.end = curr+rndGap_;
69         currRound.ended = false;
70         currRound.win = 0;
71     }
72     function getFee()
73         isCreator()
74         public
75         view
76         returns(uint256)
77     {
78         return (feeLeft);
79     }
80     function getBlock()
81         public
82     {
83        splitPot();//lotteryHei_
84     }
85     function withdrawFee(uint256 amount)
86         isCreator()
87         public
88     {
89         if(feeLeft>=amount)
90         {
91             feeLeft=feeLeft.sub(amount);
92             msg.sender.transfer(amount);
93         }
94     }
95     function playerWithdraw(uint256 amount)
96         public
97     {
98         address _customerAddress = msg.sender;
99         uint256 left=allPlayer[_customerAddress].win.sub(allPlayer[_customerAddress].withdrawed);
100 
101         if(left>=amount)
102         {
103             allPlayer[_customerAddress].withdrawed=allPlayer[_customerAddress].withdrawed.add(amount);
104             _customerAddress.transfer(amount);
105             emit Lotteryevents.onWithdraw(msg.sender, amount, now);
106         }
107     }
108     modifier isHuman() {
109         address _addr = msg.sender;
110         require (_addr == tx.origin);
111         uint256 _codeLength;
112 
113         assembly {_codeLength := extcodesize(_addr)}
114         require(_codeLength == 0, "sorry humans only");
115         _;
116     }
117 
118     modifier isWithinLimits(uint256 amount) {
119         require(amount >= 10000000000000000, "too little");//0.01
120         require(amount <= 100000000000000000000, "too much");//100
121         _;
122     }
123     modifier canClearing() {
124         require(currRound.end-lotteryHei_<=block.number, "cannot clearing");
125         require(currRound.ended==false, "already cleared");
126         _;
127     }
128     modifier isCreator() {
129         require(creator == msg.sender, "not creator");
130         _;
131     }
132 
133     function()
134         isHuman()
135         isWithinLimits(msg.value)
136         public
137         payable
138     {
139         allBuyAmount(msg.value,0);
140     }
141     function reinvest(uint256 amount, uint8 _team)
142         isHuman()
143         public
144     {
145         address _customerAddress = msg.sender;
146         uint256 left=allPlayer[_customerAddress].win.sub(allPlayer[_customerAddress].withdrawed);
147 
148         if(left>=amount)
149         {
150             allPlayer[_customerAddress].withdrawed=allPlayer[_customerAddress].withdrawed.add(amount);
151             allBuyAmount(amount,_team);
152         }
153     }
154     function buy(uint8 _team)
155         isHuman()
156         isWithinLimits(msg.value)
157         public
158         payable
159     {
160         allBuyAmount(msg.value,_team);
161     }
162     function allBuyAmount(uint256 amount,uint8 _team)
163         internal
164     {
165         require((_team == 0)||(_team == 1),"team 0 or 1");
166         Core(msg.sender,amount,_team);
167         emit Lotteryevents.onBuys
168         (
169             msg.sender,
170             amount,
171             _team
172         );
173     }
174     function Core(address addr, uint256 amount, uint8 _team)
175         private
176     {
177         if((block.number>=currRound.end-lotteryHei_))
178         {
179             if(block.number < currRound.end){
180                 uint256 currAllIn=currRound.etc0+currRound.etc1;
181                 if(currAllIn<splitThreshold){
182                     currRound.end=block.number+rndGap_;
183                 } else {
184                     allPlayer[addr].win+=amount;
185                     return;
186                 }
187             } else {
188                 allPlayer[addr].win+=amount;
189                 return;
190             }
191         }
192         if(allAddress.length>=maxLimit)
193         {
194             allPlayer[addr].win+=amount;
195             return;
196         }
197         uint i=0;
198         for (;i < allAddress.length; i++) {
199             if(addr==allAddress[i])
200                 break;
201         }
202         if(i>=allAddress.length){
203             allAddress.push(addr);
204         }
205         if(_team==0){
206             allPlayer[addr].currentroundIn0=allPlayer[addr].currentroundIn0.add(amount);
207             currRound.etc0=currRound.etc0.add(amount);
208             total.bullTotalIn=total.bullTotalIn.add(amount);
209         }else{
210             allPlayer[addr].currentroundIn1=allPlayer[addr].currentroundIn1.add(amount);
211             currRound.etc1=currRound.etc1.add(amount);
212             total.bearTotalIn=total.bearTotalIn.add(amount);
213         }
214         allPlayer[msg.sender].allRoundIn=allPlayer[msg.sender].allRoundIn.add(amount);
215     }
216     // Lottery
217     function splitPot()
218         canClearing()
219         private
220     {
221         uint256 currAllIn=currRound.etc0+currRound.etc1;
222         if(currAllIn<splitThreshold){
223             currRound.end=block.number+rndGap_;
224             return;
225         }
226         if(currRound.end > block.number){
227             return;
228         }
229 
230         uint8 whichTeamWin=sha(currRound.end); //Determine the winning team
231         if(currRound.etc0 <= 0){
232         	if(allAddress.length>=maxLimit){//Doomed to failure
233         		whichTeamWin = 1;
234         	}else{
235         		currRound.end=block.number+rndGap_;
236         		return;
237         	}
238         }
239         if(currRound.etc1 <= 0){
240         	if(allAddress.length>=maxLimit){//Doomed to failure
241         		whichTeamWin = 0;
242         	}else{
243         		currRound.end=block.number+rndGap_;
244         		return;
245         	}
246         }
247 
248         currRound.win=whichTeamWin;
249         uint256 fees=currAllIn.mul(fee).div(100);
250         uint256 pot=currAllIn.sub(fees);
251         feeLeft=feeLeft.add(fees);
252 
253         uint256 currentIn;
254         if(whichTeamWin==0){
255             currentIn=currRound.etc0;
256         }else{
257             currentIn=currRound.etc1;
258         }
259         //Distribution prize pool
260         for (uint i=0;i < allAddress.length; i++) {
261             address curr=allAddress[i];
262 
263             uint256 temp;
264             if(whichTeamWin==0){
265                 temp=allPlayer[curr].currentroundIn0;
266             }else{
267                 temp=allPlayer[curr].currentroundIn1;
268             }
269             uint256 amount=0;
270             if(temp > 0)
271             {
272                  amount=pot.mul(temp).div(currentIn);
273                  allPlayer[curr].win=allPlayer[curr].win.add(amount);
274             }
275             allPlayer[curr].lastwin=amount;
276             allPlayer[curr].currentroundIn0=0;
277             allPlayer[curr].currentroundIn1=0;
278         }
279         currRound.ended=true;
280         lastRound=currRound;
281         emit Lotteryevents.onBuyAndDistribute
282         (
283             rID_,
284             lastRound.strt,
285             lastRound.end,
286             lastRound.etc0,
287             lastRound.etc1,
288             lastRound.win
289         );
290 
291         uint256 currBlock=block.number+1;
292         rID_++;
293         currRound.strt = currBlock;
294         currRound.end = currBlock+rndGap_;
295         currRound.ended = false;
296         currRound.win = 0;
297         currRound.etc0=0;
298         currRound.etc1=0;
299 
300         if(whichTeamWin==0){
301             total.bullTotalWin=total.bullTotalWin.add(pot);
302         }else{
303             total.bearTotalWin=total.bearTotalWin.add(pot);
304         }
305 
306         delete allAddress;
307         allAddress.length=0;
308     }
309     function getAddressLength()
310         public
311         view
312         returns(uint256)
313     {
314         return (allAddress.length);
315     }
316     function getAddressArray()constant public returns(address,address)
317     {
318         return (allAddress[0],allAddress[1]);
319     }
320 
321     function getCurrentRoundLeft()
322         public
323         view
324         returns(uint256)
325     {
326         uint256 _now = block.number;
327 
328         if (_now < currRound.end)
329             return( (currRound.end).sub(_now) );
330         else
331             return(0);
332     }
333     function getEndowmentBalance() constant public returns (uint)
334     {
335     	return address(this).balance;
336     }
337     function getCreator() constant public returns (address)
338     {
339     	return creator;
340     }
341     function sha(uint256 end) constant private returns(uint8)
342     {
343         bytes32 h=blockhash(end-lotteryHei_);
344         if(h[31]&(0x0f)>8)
345         return 1;
346         return 0;  //0 for bull,1 for bear;
347     }
348 
349     function getLastRoundInfo()
350       public
351       view
352       returns (uint256,uint256,uint256,uint256,bool,int)
353     {
354         return
355         (
356             lastRound.strt,
357             lastRound.end,
358             lastRound.etc0,
359             lastRound.etc1,
360             lastRound.ended,
361             lastRound.win
362         );
363     }
364   	function getCurrentInfo()
365       public
366       view
367       returns (uint256,uint256,uint256,uint256,uint256,bool,int)
368     {
369         return
370         (
371             rID_,
372             currRound.strt,
373             currRound.end,
374             currRound.etc0,
375             currRound.etc1,
376             currRound.ended,
377             currRound.win
378         );
379     }
380     function getTotalInfo()
381       public
382       view
383       returns (uint256,uint256,uint256,uint256)
384     {
385         return
386         (
387             total.bullTotalIn,
388             total.bearTotalIn,
389             total.bullTotalWin,
390             total.bearTotalWin
391         );
392     }
393     function getPlayerInfoByAddress(address addr)
394         public
395         view
396         returns (uint256, uint256,uint256, uint256, uint256, uint256)
397     {
398         address _addr=addr;
399         if (_addr == address(0))
400         {
401             _addr = msg.sender;
402         }
403 
404         return
405         (
406             allPlayer[_addr].currentroundIn0,
407             allPlayer[_addr].currentroundIn1,
408             allPlayer[_addr].allRoundIn,
409             allPlayer[_addr].win,
410             allPlayer[_addr].lastwin,
411             allPlayer[_addr].withdrawed
412         );
413     }
414 
415     function kill()public
416     {
417         if (msg.sender == creator)
418             selfdestruct(creator);  // kills this contract and sends remaining funds back to creator
419     }
420 }
421 library SafeMath {
422 
423     function mul(uint256 a, uint256 b)
424         internal
425         pure
426         returns (uint256 c)
427     {
428         if (a == 0) {
429             return 0;
430         }
431         c = a * b;
432         require(c / a == b, "SafeMath mul failed");
433         return c;
434     }
435 
436     function div(uint256 a, uint256 b) internal pure returns (uint256) {
437         // assert(b > 0); // Solidity automatically throws when dividing by 0
438         uint256 c = a / b;
439         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
440         return c;
441     }
442 
443     function sub(uint256 a, uint256 b)
444         internal
445         pure
446         returns (uint256)
447     {
448         require(b <= a, "SafeMath sub failed");
449         return a - b;
450     }
451 
452     function add(uint256 a, uint256 b)
453         internal
454         pure
455         returns (uint256 c)
456     {
457         c = a + b;
458         require(c >= a, "SafeMath add failed");
459         return c;
460     }
461 }