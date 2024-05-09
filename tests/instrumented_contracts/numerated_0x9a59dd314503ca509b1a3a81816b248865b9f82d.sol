1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   constructor() public {
11     owner = msg.sender;
12   }
13 
14 
15   /**
16    * @dev Throws if called by any account other than the owner.
17    */
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23 
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) onlyOwner public {
29     require(newOwner != address(0));
30     //emit OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33   
34     /**
35     * @dev prevents contracts from interacting with others
36     */
37     modifier isHuman() {
38         address _addr = msg.sender;
39         uint256 _codeLength;
40     
41         assembly {_codeLength := extcodesize(_addr)}
42         require(_codeLength == 0, "sorry humans only");
43         _;
44     }
45 
46 
47 }
48 
49 contract LottoPIEvents{
50 
51     event investEvt(
52         address indexed addr,
53         uint refCode,
54         uint amount
55         );
56     
57     event dividedEvt(
58         address indexed addr,
59         uint rewardAmount
60         );
61     event referralEvt(
62         address indexed addr,
63         uint refCode,
64         uint rewardAmount
65         );
66     event dailyLottoEvt(
67         address indexed addr,
68         uint lottodAmount
69         );
70 }
71 
72 /*
73 
74                                                                     
75 ██╗      ██████╗ ████████╗████████╗ ██████╗ ██████╗ ██╗
76 ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔══██╗██║
77 ██║     ██║   ██║   ██║      ██║   ██║   ██║██████╔╝██║
78 ██║     ██║   ██║   ██║      ██║   ██║   ██║██╔═══╝ ██║
79 ███████╗╚██████╔╝   ██║      ██║   ╚██████╔╝██║     ██║
80 ╚══════╝ ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝     ╚═╝
81                                                       
82                                                                     
83                                                                            
84 
85 By EtherRich 2018
86 */
87 
88 contract LottoPI is Ownable,LottoPIEvents{
89     using SafeMath for uint;
90     //using utils for uint[];
91     //using utils for address[];
92 
93     address private w1;
94 
95     uint public curRefNumber= 0;
96     bool public gameOpened=false;
97     uint public ttlPlayers=0;
98     uint public ttlInvestCount=0;
99     uint public ttlInvestAmount=0;
100     
101     uint public roundId=1;
102     uint public roundInterval=2 * 24 *60 *60;
103     uint public startTime=0;
104     bool public gameCollapse=false;
105 
106     mapping(uint=>mapping(address=>uint)) dsInvtRefCode;    //roundId=> address=> refCode;
107     mapping(uint=>mapping(uint=>address)) dsInvtRefxAddr;   //refCode=>address;
108     mapping(uint=>mapping(address=>uint)) dsParentRefCode;
109     mapping(uint=>mapping(address=>uint)) dsInvtDeposit;   // Player Deposit
110     mapping(uint=>mapping(address=>uint)) dsInvtLevel;   // Player address => Level
111     mapping(uint=>mapping(address=>uint)) dsInvtBalances;
112     mapping(uint=>mapping(address=>uint)) dsReferees;
113     
114     uint dividedT=10 ether;
115 
116     /* level condition */
117     uint level1=0.001 ether;
118     uint level2=0.01 ether;
119     uint level3=0.1 ether;
120 
121     struct invRate{
122         uint divided;
123         uint refBonus;
124     }
125     mapping(uint=>invRate) dsSysInvtRates;
126     
127     /* final lottery*/
128     //uint public avblBalance=0;     
129     uint public totalDivided=0;     
130     uint public balDailyLotto=0;
131     
132     //daily lotto
133     uint ticketPrice=0.001 ether;
134     uint ttlTicketSold=0;
135     uint ttlLottoAmount=0;
136     uint public lastLottoTime=0;
137 
138     address[] invtByOrder;
139     address[] dailyLottoPlayers;
140     address[] dailyWinners;
141     uint[] dailyPrizes;
142     
143     constructor()public {
144         w1=msg.sender;
145         
146         // investor daily divided and referral bonus
147         invRate memory L1;
148         L1.divided=1 ether;
149         L1.refBonus=2 ether;
150         dsSysInvtRates[1]=L1;
151         
152         invRate memory L2;
153         L2.divided=3 ether;
154         L2.refBonus=6 ether;
155         dsSysInvtRates[2]=L2;
156         
157         
158         invRate memory L3;
159         L3.divided=6 ether;
160         L3.refBonus=10 ether;
161         dsSysInvtRates[3]=L3;
162         
163         gameOpened=true;
164     }
165     
166     function invest(uint refCode) isHuman payable public returns(uint){
167         require(gameOpened && !gameCollapse);
168         require(now>startTime,"Game is not start");
169         require(msg.value >= level1,"Minima amoun:0.0001 ether");
170         
171         uint myRefCode=0;
172         ttlInvestCount+=1;
173         ttlInvestAmount+=msg.value;
174 
175         /* Generate refCode on first invest */
176         if(dsInvtRefCode[roundId][msg.sender]==0){
177             curRefNumber+=1;
178             myRefCode=curRefNumber;
179             dsInvtRefCode[roundId][msg.sender]=myRefCode;
180             dsInvtRefxAddr[roundId][myRefCode]=msg.sender;
181             
182             ttlPlayers+=1;
183         }else{
184             myRefCode=dsInvtRefCode[roundId][msg.sender];
185         }
186         
187         
188         // setting up-refCode
189         if(dsParentRefCode[roundId][msg.sender]!=0){
190             //if exists, get up-refCode
191             refCode=dsParentRefCode[roundId][msg.sender];
192         }else{
193             if(refCode!=0 && dsInvtRefxAddr[roundId][refCode] != 0x0){
194                 dsParentRefCode[roundId][msg.sender]=refCode;
195             }else{
196                 refCode=0;
197             }
198         }
199 
200         
201         // sum deposit amount
202         dsInvtDeposit[roundId][msg.sender]+=msg.value;
203         
204         
205         //setting level and rate
206         uint level=1;
207         if(dsInvtDeposit[roundId][msg.sender]>=level2 && dsInvtDeposit[roundId][msg.sender]<level3){
208             dsInvtLevel[roundId][msg.sender]=2;
209             level=2;
210         }else if(dsInvtDeposit[roundId][msg.sender]>=level3){
211             dsInvtLevel[roundId][msg.sender]=3;
212             level=3;
213         }else{
214             dsInvtLevel[roundId][msg.sender]=1;
215             level=1;
216         }
217         
218         //calc refferal rewards
219         if(dsInvtRefxAddr[roundId][refCode]!=0x0){
220             address upAddr = dsInvtRefxAddr[roundId][refCode];
221             uint upLevel=dsInvtLevel[roundId][upAddr];
222             
223             dsInvtBalances[roundId][upAddr] += (msg.value * dsSysInvtRates[upLevel].refBonus) / 100 ether;
224             //avblBalance -= (msg.value * dsSysInvtRates[upLevel].refBonus) / 100 ether;
225             
226             dsReferees[roundId][upAddr]+=1;
227             
228             emit referralEvt(msg.sender,refCode,(msg.value * dsSysInvtRates[upLevel].refBonus) / 100 ether);
229         }
230         w1.transfer((msg.value * dividedT)/ 100 ether);
231         
232         //daily lotto balance
233         balDailyLotto += (msg.value * 15 ether) / 100 ether;
234 
235         //
236         //avblBalance += msg.value - (msg.value * dividedT)/100 ether;
237         
238         //for getting last 3 investor
239         invtByOrder.push(msg.sender);
240         
241 
242         emit investEvt(msg.sender,refCode,msg.value);
243 
244     }
245     
246     function buyTicket(uint num) isHuman payable public returns(uint){
247         require(gameOpened && !gameCollapse,"Game is not open");
248         require(dsInvtLevel[roundId][msg.sender] >= 2,"Level too low");
249         require(msg.value >= num.mul(ticketPrice),"payments under ticket price ");
250         
251         w1.transfer(msg.value);
252         for(uint i=0;i<num;i++){
253             dailyLottoPlayers.push(msg.sender);
254         }
255         
256         ttlTicketSold+=num;
257         
258     }
259     
260 /*
261 
262                                                                     
263 ██╗      ██████╗ ████████╗████████╗ ██████╗ ██████╗ ██╗
264 ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔══██╗██║
265 ██║     ██║   ██║   ██║      ██║   ██║   ██║██████╔╝██║
266 ██║     ██║   ██║   ██║      ██║   ██║   ██║██╔═══╝ ██║
267 ███████╗╚██████╔╝   ██║      ██║   ╚██████╔╝██║     ██║
268 ╚══════╝ ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝     ╚═╝
269                                                       
270                                                                     
271                                                                     
272 
273 */
274     
275 
276     function dailyLottery() onlyOwner public{
277         require(!gameCollapse,"game is Collapse!");
278         uint i;
279         uint _divided=0;
280         uint _todayDivided=0;  //today divided
281         
282         //summary daily divided
283         uint _level;
284         uint _ttlInvtBalance=0;
285         address _addr;
286         for(i=1;i<=curRefNumber;i++){
287             _addr=dsInvtRefxAddr[roundId][i];
288             _level=dsInvtLevel[roundId][_addr];
289             
290             _todayDivided += (dsInvtDeposit[roundId][_addr] * dsSysInvtRates[_level].divided )/100 ether;   //daily divided
291             _ttlInvtBalance +=dsInvtBalances[roundId][_addr];
292         }
293         
294         
295         //if enough to distribute then distribute or DO FINAL LOTTERY
296         if(address(this).balance > _todayDivided + _ttlInvtBalance && !gameCollapse){
297             totalDivided+=_todayDivided;
298             //avblBalance-=todayDivided;
299             
300             //sum daily divided
301             for(i=1;i<=curRefNumber;i++){
302                 _addr=dsInvtRefxAddr[roundId][i];
303                 _level=dsInvtLevel[roundId][_addr];
304                 
305                 _divided=(dsInvtDeposit[roundId][_addr] * dsSysInvtRates[_level].divided )/100 ether;
306                 dsInvtBalances[roundId][_addr]+=_divided;
307             }
308             
309             //daily Lottery Winner
310             
311             if(dailyLottoPlayers.length>0 && balDailyLotto>0){
312                 uint winnerNo=getRnd(now,1,dailyLottoPlayers.length);
313                 address winnerAddr=dailyLottoPlayers[winnerNo-1];
314                 dsInvtBalances[roundId][winnerAddr] += balDailyLotto;
315                 
316                 dailyWinners.push(winnerAddr);
317                 dailyPrizes.push(balDailyLotto);
318                 
319                 ttlLottoAmount+=balDailyLotto;
320                 lastLottoTime=now;
321                 //avblBalance-=balDailyLotto;
322                 
323                 //reset daily Lotto
324                 balDailyLotto=0;
325                 dailyLottoPlayers.length=0;
326             }
327             
328         }else{
329             //if insufficient, big lottery!
330             uint _count=invtByOrder.length;
331             uint prize=(address(this).balance - _ttlInvtBalance) / 3;
332             address winner1=0x0;
333             address winner2=0x0;
334             address winner3=0x0;
335             
336             if(_count>=1) winner1 = invtByOrder[_count-1];
337             if(_count>=2) winner2 = invtByOrder[_count-2];
338             if(_count>=3) winner3 = invtByOrder[_count-3];
339             
340             if(winner1!=0x0){dsInvtBalances[roundId][winner1] += prize;}
341             if(winner2!=0x0){dsInvtBalances[roundId][winner2] += prize;}
342             if(winner3!=0x0){dsInvtBalances[roundId][winner3] += prize;}
343 
344             //reset daily Lotto
345             balDailyLotto=0;
346             dailyLottoPlayers.length=0;
347         
348             //avblBalance=0;
349             
350             startTime=now + roundInterval;
351             gameCollapse=true;
352             
353             emit dailyLottoEvt(winner1,prize);
354             if(winner2!=0x0) emit dailyLottoEvt(winner2,prize);
355             if(winner3!=0x0) emit dailyLottoEvt(winner3,prize);
356         }
357         
358         
359     }
360     
361     function getDailyPlayers() public view returns(address[]){
362         return (dailyLottoPlayers);
363     }
364     
365     function getDailyWinners() public view returns(address[],uint[]){
366         return (dailyWinners,dailyPrizes);
367     }
368     
369     function getLastInvestors() public view returns(address[]){
370         uint _count=invtByOrder.length;
371         uint _num = (_count>=10?10:_count);
372         address[] memory _invts=new address[](_num);
373         
374         for(uint i=_count;i>_count-_num;i--){
375             _invts[_count-i]=invtByOrder[i-1];
376         }
377         return (_invts);
378     }
379     
380     function newGame() public onlyOwner{
381         curRefNumber=0;
382         
383         ttlInvestAmount=0;
384         ttlInvestCount=0;
385         ttlPlayers=0;
386         
387         //avblBalance=0;
388         totalDivided=0;
389         balDailyLotto=0;
390     
391         ttlTicketSold=0;
392         ttlLottoAmount=0;
393 
394         dailyLottoPlayers.length=0;
395         dailyWinners.length=0;
396         invtByOrder.length=0;
397         
398         gameOpened=true;
399         gameCollapse=false;
400         roundId+=1;        
401     }
402     
403     function setGameStatus(bool _opened) public onlyOwner{
404         gameOpened=_opened;
405     }
406     
407     function withdraw() public{
408         require(dsInvtBalances[roundId][msg.sender]>=0.01 ether,"Balance is not enough");
409         
410         w1.transfer(0.001 ether); //game fee
411         msg.sender.transfer(dsInvtBalances[roundId][msg.sender] - 0.001 ether);
412         
413         dsInvtBalances[roundId][msg.sender]=0;
414     }
415     
416     function withdrawTo(address _addr,uint _val) onlyOwner public{
417         address(_addr).transfer(_val);
418     }
419     
420     function myData() public view returns(uint,uint,uint,uint,uint,uint){
421         /*return refCode,level,referees,invest amount,balance,myTickets  */
422         
423         uint refCode=dsInvtRefCode[roundId][msg.sender];
424         uint myTickets=0;
425         for(uint i=0;i<dailyLottoPlayers.length;i++){
426             if(dailyLottoPlayers[i]==msg.sender){
427              myTickets+=1;
428             }
429         }
430         
431         return (refCode,dsInvtLevel[roundId][msg.sender],dsReferees[roundId][msg.sender],dsInvtDeposit[roundId][msg.sender],dsInvtBalances[roundId][msg.sender],myTickets);
432     }
433     
434     function stats() public view returns(uint,uint,uint,uint,uint,uint,uint,uint){
435         /*return available balance,total invest amount,total invest count,total players,today prize,today tickets,ttlLottoAmount,totalDivided */
436         uint i;
437         uint _level;
438         uint _ttlInvtBalance=0;
439         address _addr;
440         
441         if(gameCollapse){
442             avblBalance=0;
443         }else{
444             for(i=1;i<=curRefNumber;i++){
445                 _level=dsInvtLevel[roundId][dsInvtRefxAddr[roundId][i]];
446                 _addr=dsInvtRefxAddr[roundId][i];
447                 _ttlInvtBalance +=dsInvtBalances[roundId][_addr];
448             }
449             
450             uint avblBalance=address(this).balance - _ttlInvtBalance;
451             if(avblBalance<0) avblBalance=0;
452         }
453         
454         
455         return (avblBalance,ttlInvestAmount,ttlInvestCount,ttlPlayers,balDailyLotto,ttlLottoAmount,dailyLottoPlayers.length,totalDivided);
456     }
457 
458     function getRnd(uint _seed,uint _min,uint _max) public view returns(uint){
459         uint rndSeed=0;
460         rndSeed = uint(keccak256(abi.encodePacked(msg.sender,block.number,block.timestamp, block.difficulty,block.gaslimit,_seed))) % _max + _min;
461         
462         return rndSeed;
463     }
464 }
465 
466 
467 
468 /*
469 =====================================================
470 Library
471 =====================================================
472 */
473 
474 
475 library SafeMath {
476   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
477     uint256 c = a * b;
478     assert(a == 0 || c / a == b);
479     return c;
480   }
481 
482   function div(uint256 a, uint256 b) internal pure returns (uint256) {
483     // assert(b > 0); // Solidity automatically throws when dividing by 0
484     uint256 c = a / b;
485     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
486     return c;
487   }
488 
489   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490     assert(b <= a);
491     return a - b;
492   }
493 
494   function add(uint256 a, uint256 b) internal pure returns (uint256) {
495     uint256 c = a + b;
496     assert(c >= a);
497     return c;
498   }
499   
500 }