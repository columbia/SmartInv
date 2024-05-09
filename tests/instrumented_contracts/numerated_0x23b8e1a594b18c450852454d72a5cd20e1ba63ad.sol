1 pragma solidity ^0.4.25;
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
49 contract pokerEvents{
50     event Bettings(
51         uint indexed guid,
52         uint gameType,
53         address indexed playerAddr,
54         uint[] bet,
55         bool indexed result,
56         uint winNo,
57         uint amount,
58         uint winAmount,
59         uint jackpot
60         );
61         
62     event JackpotPayment(
63         uint indexed juid,
64         address indexed playerAddr,
65         uint amount,
66         uint winAmount
67         );
68     
69     event FreeLottery(
70         uint indexed luid,
71         address indexed playerAddr,
72         uint indexed winAmount
73         );
74     
75 }
76 
77 contract Poker is Ownable,pokerEvents{
78     using inArrayExt for address[];
79     using intArrayExt for uint[];
80     
81     address private opAddress;
82     address private wallet1;
83     address private wallet2;
84     
85     bool public gamePaused=false;
86     uint public guid=1;
87     uint public luid=1;
88     mapping(string=>uint) odds;
89 
90     /* setting*/
91     uint minPrize=0.01 ether;
92     uint lotteryPercent = 3 ether;
93     uint public minBetVal=0.01 ether;
94     uint public maxBetVal=1 ether;
95     
96     /* free lottery */
97     struct FreeLotto{
98         bool active;
99         uint prob;
100         uint prize;
101         uint freezeTimer;
102         uint count;
103         mapping(address => uint) lastTime;
104     }
105     mapping(uint=>FreeLotto) lotto;
106     mapping(address=>uint) playerCount;
107     bool freeLottoActive=true;
108     
109     /* jackpot */
110     uint public jpBalance=0;
111     uint jpMinBetAmount=0.05 ether;
112     uint jpMinPrize=0.01 ether;
113     uint jpChance=1000;
114     uint jpPercent=0.3 ether;
115     
116         /*misc */
117     uint private rndSeed;
118     uint private minute=60;
119     uint private hour=60*60;
120     
121     /*
122     ===========================================
123     CONSTRUCTOR
124     ===========================================
125     */
126     constructor(uint _rndSeed) public{
127         opAddress=msg.sender;
128         wallet1=msg.sender;
129         wallet2=msg.sender;
130         
131         odds['bs']=1.97 ether;
132         odds['suit']=3.82 ether;
133         odds['num']=11.98 ether;
134         odds['nsuit']=49.98 ether;
135     
136         /* free lottery initial*/
137         lotto[1]=FreeLotto(true,1000,0.1 ether,hour / 100 ,0);
138         lotto[2]=FreeLotto(true,100000,1 ether,3*hour/100 ,0);
139 
140         
141         /* initial random seed*/
142         rndSeed=uint(keccak256(abi.encodePacked(blockhash(block.number-1), msg.sender,now,_rndSeed)));
143     }
144 
145      function play(uint _gType,uint[] _bet) payable isHuman() public returns(uint){
146         require(!gamePaused,'Game Pause');
147         require(msg.value >=  minBetVal*_bet.length && msg.value <=  maxBetVal*_bet.length );
148 
149         bool _ret=false;
150         uint _betAmount= msg.value /_bet.length;
151         uint _prize=0;
152         uint _winNo= uint(keccak256(abi.encodePacked(rndSeed,msg.sender,block.coinbase,block.timestamp, block.difficulty,block.gaslimit))) % 52 + 1;
153         
154         if(_gType==1){
155             if(_betAmount * odds['bs']  / 1 ether >= address(this).balance/2){
156                 revert("over max bet amount");
157             }
158             
159             if((_winNo > 31 && _bet.contain(2)) || (_winNo < 28 && _bet.contain(1))){
160                 _ret=true;
161                 _prize=(_betAmount * odds['bs']) / 1 ether;
162             }else if(_winNo>=28 && _winNo <=31 && _bet.contain(0)){
163                 _ret=true;
164                 _prize=(_betAmount * 12 ether) / 1 ether; 
165             }
166         }
167         
168         /*
169         ret%4=0 spades;
170         ret%4=1 hearts
171         ret%4=2 clubs;
172         ret%4=3 diamonds;
173         */
174         if(_gType==2 && _bet.contain(_winNo%4+1)){
175             if(_betAmount * odds['suit'] / 1 ether >= address(this).balance/2){
176                 revert("over max bet amount");
177             }
178             
179             _ret=true;
180             _prize=(_betAmount * odds['suit']) / 1 ether; 
181         }
182         
183         if(_gType==3 && _bet.contain((_winNo-1)/4+1)){
184             if(_betAmount * odds['num'] / 1 ether >= address(this).balance/2){
185                 revert("over max bet amount");
186             }
187             
188             _ret=true;
189             _prize=(_betAmount * odds['num']) / 1 ether; 
190         }
191         
192         if(_gType==4 && _bet.contain(_winNo)){
193             if(_betAmount * odds['nsuit'] / 1 ether >= address(this).balance/2){
194                 revert("over max bet amount");
195             }
196             
197             _ret=true;
198             _prize=(_betAmount * odds['nsuit']) / 1 ether; 
199             
200         }
201 
202         if(_ret){
203             msg.sender.transfer(_prize);
204         }else{
205             jpBalance += (msg.value * jpPercent) / 100 ether;
206         }
207         
208         rndSeed = uint(uint(keccak256(abi.encodePacked(msg.sender,block.timestamp, block.difficulty,block.gaslimit,_winNo))));
209         
210 
211         /* JackPot*/
212         uint tmpJackpot=0;
213         if(_betAmount >= jpMinBetAmount){
214             uint _jpNo= uint(keccak256(abi.encodePacked(rndSeed,msg.sender,block.coinbase,block.timestamp, block.difficulty,block.gaslimit))) % jpChance;
215             if(_jpNo==77 && jpBalance>jpMinPrize){
216                 msg.sender.transfer(jpBalance);
217                 emit JackpotPayment(guid,msg.sender,_betAmount,jpBalance);
218                 tmpJackpot=jpBalance;
219                 jpBalance=0;
220             }else{
221                 tmpJackpot=0;
222             }
223             
224             rndSeed = uint(uint(keccak256(abi.encodePacked(msg.sender,block.timestamp, block.difficulty,block.gaslimit,_jpNo))));
225         }
226         
227         emit Bettings(guid,_gType,msg.sender,_bet,_ret,_winNo,msg.value,_prize,tmpJackpot);
228         
229         guid+=1;
230         return _winNo;
231     }
232     
233 
234     function freeLottery(uint _gid) public{
235         require(!gamePaused,'Game Pause');
236         require(freeLottoActive && lotto[_gid].active,'Free Lotto is closed');
237         require(now - lotto[_gid].lastTime[msg.sender] >= lotto[_gid].freezeTimer,'in the freeze time');
238         
239         uint chancex=1;
240         uint winNo = 0;
241         if(playerCount[msg.sender]>=3){
242             chancex=2;
243         }
244         if(playerCount[msg.sender]>=6){
245             chancex=3;
246         }
247         
248         winNo=uint(keccak256(abi.encodePacked(msg.sender,block.number,block.timestamp, block.difficulty,block.gaslimit))) % (playerCount[msg.sender]>=3?lotto[_gid].prob/chancex:lotto[_gid].prob)+1;
249 
250         bool result;
251         if(winNo==7){
252             result=true;
253             msg.sender.transfer(lotto[_gid].prize);
254         }else{
255             result=false;
256             if(playerCount[msg.sender]==0 || lotto[_gid].lastTime[msg.sender] <= now -lotto[_gid].freezeTimer - 15*minute){
257                 playerCount[msg.sender]+=1;
258             }else{
259                 playerCount[msg.sender]=0;
260             }
261         }
262         
263         emit FreeLottery(luid,msg.sender,result?lotto[_gid].prize:0);
264         
265         luid=luid+1;
266         lotto[_gid].lastTime[msg.sender]=now;
267     }
268     
269     function freeLottoInfo() public view returns(uint,uint,uint){
270         uint chance=1;
271         if(playerCount[msg.sender]>=3){
272             chance=2;
273         }
274         if(playerCount[msg.sender]>=6){
275             chance=3;
276         }
277         return (lotto[1].lastTime[msg.sender],lotto[2].lastTime[msg.sender],chance);
278     }
279     
280     function updateRndSeed() public {
281         require(msg.sender==owner || msg.sender==opAddress,"DENIED");
282         
283         rndSeed = uint(uint(keccak256(abi.encodePacked(msg.sender,block.number,block.timestamp,block.coinbase, block.difficulty,block.gaslimit))));
284     }
285     
286     function updateOdds(string _game,uint _val) public{
287         require(msg.sender==owner || msg.sender==opAddress);
288         
289         odds[_game]=_val;
290     }
291     
292     function updateStatus(uint _p,bool _status) public{
293         require(msg.sender==owner || msg.sender==opAddress);
294         
295         if(_p==1){gamePaused=_status;}
296         if(_p==2){freeLottoActive=_status;}
297         if(_p==3){lotto[1].active =_status;}
298         if(_p==4){lotto[2].active =_status;}
299         
300     }
301     
302     function getOdds() public view returns(uint[]) {
303         uint[] memory ret=new uint[](4);
304         ret[0]=odds['bs'];
305         ret[1]=odds['suit'];
306         ret[2]=odds['num'];
307         ret[3]=odds['nsuit'];
308         
309         return ret;
310     }
311     
312     function updateLottoParams(uint _gid,uint _key,uint _val) public{
313         require(msg.sender==owner || msg.sender==opAddress);
314         /* 
315         _ke y=> 1:active,2:prob,3:prize,4:freeTimer
316         */
317         
318         if(_key==1){lotto[_gid].active=(_val==1);}
319         if(_key==2){lotto[_gid].prob=_val;}
320         if(_key==3){lotto[_gid].prize=_val;}
321         if(_key==4){lotto[_gid].freezeTimer=_val;}
322         
323     }
324     
325     function getLottoData(uint8 _gid) public view returns(bool,uint,uint,uint,uint){
326         return (lotto[_gid].active,lotto[_gid].prob,lotto[_gid].prize,lotto[_gid].freezeTimer,lotto[_gid].count);
327         
328     }
329     
330     function setAddr(uint _acc,address _addr) public onlyOwner{
331         if(_acc==1){wallet1=_addr;}
332         if(_acc==2){wallet2=_addr;}
333         if(_acc==3){opAddress=_addr;}
334     }
335     
336     function getAddr(uint _acc) public view onlyOwner returns(address){
337         if(_acc==1){return wallet1;}
338         if(_acc==2){return wallet2;}
339         if(_acc==3){return opAddress;}
340     }
341     
342 
343     function withdraw(address _to,uint amount) public onlyOwner returns(bool){
344         require(address(this).balance - amount > 0);
345         _to.transfer(amount);
346     }
347     
348     function distribute(uint _p) public onlyOwner{
349         uint prft1=_p* 85 / 100;
350         uint prft2=_p* 10 / 100;
351         uint prft3=_p* 5 / 100;
352 
353         owner.transfer(prft1);
354         wallet1.transfer(prft2);
355         wallet2.transfer(prft3);
356 
357     }
358     
359     
360     function() payable isHuman() public {
361         
362     }
363     
364 }
365 
366 
367 library inArrayExt{
368     function contain(address[] _arr,address _val) internal pure returns(bool){
369         for(uint _i=0;_i< _arr.length;_i++){
370             if(_arr[_i]==_val){
371                 return true;
372                 break;
373             }
374         }
375         return false;
376     }
377 }
378 
379 library intArrayExt{
380     function contain(uint[] _arr,uint _val) internal pure returns(bool){
381         for(uint _i=0;_i< _arr.length;_i++){
382             if(_arr[_i]==_val){
383                 return true;
384                 break;
385             }
386         }
387         return false;
388     }
389 }