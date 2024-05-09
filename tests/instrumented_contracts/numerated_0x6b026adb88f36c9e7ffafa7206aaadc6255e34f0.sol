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
39         require (_addr == tx.origin);
40         
41         uint256 _codeLength;
42         assembly {_codeLength := extcodesize(_addr)}
43         require(_codeLength == 0, "sorry humans only");
44         _;
45     }
46 
47 
48 }
49 
50 contract pokerEvents{
51     event Bettings(
52         uint indexed guid,
53         uint gameType,
54         address indexed playerAddr,
55         uint[] bet,
56         bool indexed result,
57         uint winNo,
58         uint amount,
59         uint winAmount,
60         uint jackpot
61         );
62         
63     event JackpotPayment(
64         uint indexed juid,
65         address indexed playerAddr,
66         uint amount,
67         uint winAmount
68         );
69     
70     event FreeLottery(
71         uint indexed luid,
72         address indexed playerAddr,
73         uint winNo,
74         uint indexed winAmount
75         );
76     
77 }
78 
79 contract Poker is Ownable,pokerEvents{
80     using inArrayExt for address[];
81     using intArrayExt for uint[];
82     
83     address private opAddress;
84     address private wallet1;
85     address private wallet2;
86     
87     bool public gamePaused=false;
88     uint public guid=1;
89     uint public luid=1;
90     mapping(string=>uint) odds;
91 
92     /* setting*/
93     uint minPrize=0.01 ether;
94     uint lotteryPercent = 3 ether;
95     uint public minBetVal=0.01 ether;
96     uint public maxBetVal=1 ether;
97     
98     /* free lottery */
99     struct FreeLotto{
100         bool active;
101         uint prob;
102         uint prize;
103         uint freezeTimer;
104         uint count;
105         mapping(address => uint) lastTime;
106     }
107     mapping(uint=>FreeLotto) lotto;
108     mapping(address=>uint) playerCount;
109     bool freeLottoActive=true;
110     
111     /* jackpot */
112     uint public jpBalance=0;
113     uint jpMinBetAmount=0.05 ether;
114     uint jpMinPrize=0.01 ether;
115     uint jpChance=1000;
116     uint jpPercent=0.3 ether;
117     
118     /*misc */
119     bytes32 private rndSeed;
120     uint private minute=60;
121     uint private hour=60*60;
122     
123     /*
124     ===========================================
125     CONSTRUCTOR
126     ===========================================
127     */
128     constructor(address _rndAddr) public{
129         opAddress=msg.sender;
130         wallet1=msg.sender;
131         wallet2=msg.sender;
132         
133         odds['bs']=1.97 ether;
134         odds['suit']=3.82 ether;
135         odds['num']=11.98 ether;
136         odds['nsuit']=49.98 ether;
137     
138         /* free lottery initial*/
139         lotto[1]=FreeLotto(true,1000,0.1 ether,hour / 100 ,0);
140         lotto[2]=FreeLotto(true,100000,1 ether,3*hour/100 ,0);
141 
142         
143         /* initial random seed*/
144         RandomOnce rnd=RandomOnce(_rndAddr);
145         bytes32 _rndSeed=rnd.getRandom();
146         rnd.destruct();
147         
148         rndSeed=keccak256(abi.encodePacked(blockhash(block.number-1), msg.sender,now,_rndSeed));
149     }
150 
151      function play(uint _gType,uint[] _bet) payable isHuman() public{
152         require(!gamePaused,'Game Pause');
153         require(msg.value >=  minBetVal*_bet.length && msg.value <=  maxBetVal*_bet.length,"value is incorrect" );
154 
155         bool _ret=false;
156         uint _betAmount= msg.value /_bet.length;
157         uint _prize=0;
158         
159         uint _winNo= uint(keccak256(abi.encodePacked(rndSeed,msg.sender,block.coinbase,block.timestamp, block.difficulty,block.gaslimit))) % 52 + 1;
160         rndSeed = keccak256(abi.encodePacked(msg.sender,block.timestamp,rndSeed, block.difficulty));
161         
162         if(_gType==1){
163             if(_betAmount * odds['bs']  / 1 ether >= address(this).balance/2){
164                 revert("over max bet amount");
165             }
166             
167             if((_winNo >= 29 && _bet.contain(2)) || (_winNo <= 24 && _bet.contain(1))){
168                 _ret=true;
169                 _prize=(_betAmount * odds['bs']) / 1 ether;
170             }else if(_winNo>=25 && _winNo <=28 && _bet.contain(0)){
171                 _ret=true;
172                 _prize=(_betAmount * 12 ether) / 1 ether; 
173             }
174         }
175         
176         /*
177         ret%4=0 spades;
178         ret%4=1 hearts
179         ret%4=2 clubs;
180         ret%4=3 diamonds;
181         */
182         if(_gType==2 && _bet.contain(_winNo%4+1)){
183             if(_betAmount * odds['suit'] / 1 ether >= address(this).balance/2){
184                 revert("over max bet amount");
185             }
186             
187             _ret=true;
188             _prize=(_betAmount * odds['suit']) / 1 ether; 
189         }
190         
191         if(_gType==3 && _bet.contain((_winNo-1)/4+1)){
192             if(_betAmount * odds['num'] / 1 ether >= address(this).balance/2){
193                 revert("over max bet amount");
194             }
195             
196             _ret=true;
197             _prize=(_betAmount * odds['num']) / 1 ether; 
198         }
199         
200         if(_gType==4 && _bet.contain(_winNo)){
201             if(_betAmount * odds['nsuit'] / 1 ether >= address(this).balance/2){
202                 revert("over max bet amount");
203             }
204             
205             _ret=true;
206             _prize=(_betAmount * odds['nsuit']) / 1 ether; 
207             
208         }
209 
210         if(_ret){
211             msg.sender.transfer(_prize);
212         }else{
213             jpBalance += (msg.value * jpPercent) / 100 ether;
214         }
215         
216         
217         /* JackPot*/
218         uint tmpJackpot=0;
219         if(_betAmount >= jpMinBetAmount){
220             uint _jpNo= uint(keccak256(abi.encodePacked(rndSeed,msg.sender,block.coinbase,block.timestamp, block.difficulty,block.gaslimit))) % jpChance;
221             if(_jpNo==77 && jpBalance>jpMinPrize){
222                 msg.sender.transfer(jpBalance);
223                 emit JackpotPayment(guid,msg.sender,_betAmount,jpBalance);
224                 tmpJackpot=jpBalance;
225                 jpBalance=0;
226             }else{
227                 tmpJackpot=0;
228             }
229             
230             rndSeed = keccak256(abi.encodePacked(block.coinbase,msg.sender,block.timestamp, block.difficulty,rndSeed));
231         }
232         
233         emit Bettings(guid,_gType,msg.sender,_bet,_ret,_winNo,msg.value,_prize,tmpJackpot);
234         
235         guid+=1;
236     }
237     
238     function freeLottery(uint _gid) public isHuman(){
239         require(!gamePaused,'Game Pause');
240         require(freeLottoActive && lotto[_gid].active,'Free Lotto is closed');
241         require(now - lotto[_gid].lastTime[msg.sender] >= lotto[_gid].freezeTimer,'in the freeze time');
242         
243         uint chancex=1;
244         uint winNo = 0;
245         if(playerCount[msg.sender]>=3){
246             chancex=2;
247         }
248         if(playerCount[msg.sender]>=6){
249             chancex=3;
250         }
251         
252         winNo=uint(keccak256(abi.encodePacked(msg.sender,block.number,block.timestamp, rndSeed,block.difficulty,block.gaslimit))) % (playerCount[msg.sender]>=3?lotto[_gid].prob/chancex:lotto[_gid].prob)+1;
253 
254         bool result;
255         if(winNo==7){
256             result=true;
257             msg.sender.transfer(lotto[_gid].prize);
258         }else{
259             result=false;
260             if(playerCount[msg.sender]==0 || lotto[_gid].lastTime[msg.sender] <= now -lotto[_gid].freezeTimer - 15*minute){
261                 playerCount[msg.sender]+=1;
262             }else{
263                 playerCount[msg.sender]=0;
264             }
265         }
266         
267         emit FreeLottery(luid,msg.sender,winNo,result?lotto[_gid].prize:0);
268         
269         rndSeed = keccak256(abi.encodePacked( block.difficulty,block.coinbase,msg.sender,block.timestamp,rndSeed));
270         luid=luid+1;
271         lotto[_gid].lastTime[msg.sender]=now;
272     }
273     
274     function freeLottoInfo() public view isHuman() returns(uint,uint,uint){
275         uint chance=1;
276         if(playerCount[msg.sender]>=3){
277             chance=2;
278         }
279         if(playerCount[msg.sender]>=6){
280             chance=3;
281         }
282         return (lotto[1].lastTime[msg.sender],lotto[2].lastTime[msg.sender],chance);
283     }
284     
285     function updateRndSeed(address _rndAddr) isHuman() public {
286         require(msg.sender==owner || msg.sender==opAddress,"DENIED");
287         
288         RandomOnce rnd=RandomOnce(_rndAddr);
289         bytes32 _rndSeed=rnd.getRandom();
290         rnd.destruct();
291         
292         rndSeed = keccak256(abi.encodePacked(msg.sender,block.number,_rndSeed,block.timestamp,block.coinbase,rndSeed, block.difficulty,block.gaslimit));
293     }
294     
295     function updateOdds(string _game,uint _val) public isHuman(){
296         require(msg.sender==owner || msg.sender==opAddress);
297         
298         odds[_game]=_val;
299     }
300     
301     function updateStatus(uint _p,bool _status) public isHuman(){
302         require(msg.sender==owner || msg.sender==opAddress);
303         
304         if(_p==1){gamePaused=_status;}
305         if(_p==2){freeLottoActive=_status;}
306         if(_p==3){lotto[1].active =_status;}
307         if(_p==4){lotto[2].active =_status;}
308         
309     }
310     
311     function getOdds() public view returns(uint[]) {
312         uint[] memory ret=new uint[](4);
313         ret[0]=odds['bs'];
314         ret[1]=odds['suit'];
315         ret[2]=odds['num'];
316         ret[3]=odds['nsuit'];
317         
318         return ret;
319     }
320     
321     function updateLottoParams(uint _gid,uint _key,uint _val) public isHuman(){
322         require(msg.sender==owner || msg.sender==opAddress);
323         /* 
324         _ke y=> 1:active,2:prob,3:prize,4:freeTimer
325         */
326         
327         if(_key==1){lotto[_gid].active=(_val==1);}
328         if(_key==2){lotto[_gid].prob=_val;}
329         if(_key==3){lotto[_gid].prize=_val;}
330         if(_key==4){lotto[_gid].freezeTimer=_val;}
331         
332     }
333     
334     function getLottoData(uint8 _gid) public view returns(bool,uint,uint,uint,uint){
335         return (lotto[_gid].active,lotto[_gid].prob,lotto[_gid].prize,lotto[_gid].freezeTimer,lotto[_gid].count);
336         
337     }
338     
339     function setAddr(uint _acc,address _addr) public onlyOwner isHuman(){
340         if(_acc==1){wallet1=_addr;}
341         if(_acc==2){wallet2=_addr;}
342         if(_acc==3){opAddress=_addr;}
343     }
344     
345     function getAddr(uint _acc) public view onlyOwner returns(address){
346         if(_acc==1){return wallet1;}
347         if(_acc==2){return wallet2;}
348         if(_acc==3){return opAddress;}
349     }
350     
351 
352     function withdraw(address _to,uint amount) public onlyOwner isHuman() returns(bool){
353         require(address(this).balance - amount > 0);
354         _to.transfer(amount);
355     }
356     
357     function distribute(uint _p) public onlyOwner isHuman(){
358         uint prft1=_p* 85 / 100;
359         uint prft2=_p* 10 / 100;
360         uint prft3=_p* 5 / 100;
361 
362         owner.transfer(prft1);
363         wallet1.transfer(prft2);
364         wallet2.transfer(prft3);
365 
366     }
367     
368     
369     function() payable isHuman() public {
370         
371     }
372     
373 }
374 
375 
376 
377 
378 contract RandomOnce{
379     constructor() public{}
380     function getRandom() public view returns(bytes32){}
381     function destruct() public{}
382 }
383 
384 
385 
386 library inArrayExt{
387     function contain(address[] _arr,address _val) internal pure returns(bool){
388         for(uint _i=0;_i< _arr.length;_i++){
389             if(_arr[_i]==_val){
390                 return true;
391                 break;
392             }
393         }
394         return false;
395     }
396 }
397 
398 library intArrayExt{
399     function contain(uint[] _arr,uint _val) internal pure returns(bool){
400         for(uint _i=0;_i< _arr.length;_i++){
401             if(_arr[_i]==_val){
402                 return true;
403                 break;
404             }
405         }
406         return false;
407     }
408 }