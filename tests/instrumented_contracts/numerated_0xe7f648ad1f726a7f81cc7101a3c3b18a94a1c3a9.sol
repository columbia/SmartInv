1 pragma solidity ^0.4.24;
2 
3 
4 //@Author Kirin
5 contract Infinitestars {
6     
7     using Player for Player.Map;
8     using CommUtils for string;
9     using InfinitestarsData for InfinitestarsData.Data;
10     using Ball for Ball.Data[];
11     uint256 public constant WITHDRAWAL_AUTO_BUY_COUNT = 1;
12     uint256 public constant BALL_PRICE = 0.5 ether;
13     uint256 public constant REGESTER_FEE = 0.02 ether;
14     uint256 public constant REGISTER_FREE_COUNT = 100;
15     InfinitestarsData.Data private data;
16     uint256 private regesterCount =0;
17     bool private gameEnabled = false;
18 
19 
20     function enableGame() public{
21         require(Player.isAdmin(msg.sender),"it`s not admin");
22         gameEnabled = true;
23     }
24     
25     modifier enabling(){
26         require(gameEnabled,"game not start");
27         _;
28     }
29 
30     function buyBall(uint256 count) enabling public payable  {
31         (address picker,uint256 ammount) =data.buyBall(count,msg.sender);
32         broadcastBuy(msg.sender,count,ammount,picker);
33     }
34     
35     function broadcastBuy(address adr,uint256 count,uint256 starsPickValue,address picker) private {
36         bytes32 b = data.players.getName(adr);
37         emit OnBuyed (adr,b,count,starsPickValue,picker);
38     }
39     
40     function buyBallWithReferrer(uint256 count,string referrer) enabling public payable  {
41        (address picker,uint256 ammount) =data.buyBallWithReferrer(count,msg.sender,referrer);
42         broadcastBuy(msg.sender,count,ammount,picker);
43     }    
44 
45     function getInit()  public view returns(
46         bytes32, //0 your name
47         bytes32, //1  refername
48         uint256,  //2 currentIdx
49         uint256,    //3 shourt Prize
50         uint256,     //4 the player gains
51         uint256,     //5 refferSumReward
52         bool ,      //6 played
53         uint256 ,    //7 blance
54         uint256     //8  Your live ball
55     
56     ){
57        // (uint256 count,uint256 firstAt,uint256 lastAt, uint256 payOutCount,uint256 nextPayOutAt) = data.getOutInfoOfSender();
58         return (
59             data.players.getName(),
60             data.players.getReferrerName(msg.sender),
61             data.currentIdx,
62             data.shortPrize,
63             data.players.getAmmount(msg.sender),
64             data.referralbonusMap[msg.sender],
65             data.playedMap[msg.sender],
66             address(this).balance,
67             data.balls.countByOwner(msg.sender)
68         );
69     }
70     
71     
72     function getOutInfo(uint256 startIdx,uint256 pageSize) public view returns(
73             uint256 scanCount,
74             uint256 selfCount,
75             uint256 firstAt,
76             uint256 lastAt,
77             uint256 payOutCount,
78             uint256 nextPayOutAt
79         ){
80         return data.getOutInfo(startIdx,pageSize);
81     }
82     
83 
84     function getPayedInfo(uint256 startIdx,uint256 pageSize) public view returns(
85             uint256 scanCount,
86             uint256 selfCount,
87             uint256 firstAt,
88             uint256 lastAt,
89             uint256 payOutCount,
90             uint256 payedCount
91         ){
92         return data.getPayedInfo(startIdx,pageSize);
93     }    
94     
95     
96     function getOutInfoOfSender()  public view returns(
97             uint256 , //your out ball
98             uint256 , //firstAt
99             uint256 ,  //lastAt      
100             uint256,   //  payOutCount,
101             uint256 ,   //   nextPayOutAt    
102             uint256     // payedCount
103         ){
104         return data.getOutInfoOfSender();
105     }      
106 
107     
108     function outBall() enabling public {
109         data.toPayedBall();
110         data.toOutBall();
111     }
112     
113     function listLiveBall() public view returns(
114         uint256[] , //index;
115         address[] , //owner;
116         uint256[] , //outCount;
117         uint[]  //createAt;
118         ){
119         return listBall(data.balls);
120     }
121     
122     function listBall(Ball.Data[] list) private pure returns(
123         uint256[] indexs, //index;
124         address[] owners, //owner;
125         uint256[] outCounts, //outCount;
126         uint[] createAts //createAt;
127         ){
128         indexs = new uint256[](list.length);    
129         owners = new address[](list.length);    
130         outCounts = new uint256[](list.length);    
131         createAts = new uint[](list.length);    
132         for(uint256 i=0;i<list.length;i++){
133             indexs[i]=list[i].index;
134             owners[i]=list[i].owner;
135             outCounts[i]=list[i].outCount;
136             createAts[i]=list[i].createAt;
137         }
138     }
139   
140     
141     function registerName(string  name) enabling public payable {
142         require(msg.value >= REGESTER_FEE,"fee not enough");
143         require(data.playedMap[msg.sender] ,"it`s not play");
144         regesterCount++;
145         data.registerName(name);
146         if(REGISTER_FREE_COUNT>=regesterCount){
147             data.players.deposit(msg.sender,REGESTER_FEE);
148         }
149     }    
150     
151     function isEmptyName(string _n) public view returns(bool){
152         return data.players.isEmptyName(_n.nameFilter());
153     }    
154     
155     
156     function withdrawalBuy(uint256 ammount) enabling public payable{
157         
158         address self = msg.sender;
159         uint256 fee = CommUtils.mulRate(ammount,1);
160         uint256 gains = data.players.getAmmount(msg.sender);
161         uint256 autoPayA = WITHDRAWAL_AUTO_BUY_COUNT*BALL_PRICE;
162         ammount-= fee;
163         require(ammount<=gains ,"getAmmount is too low ");
164         //require(data.balls.countByOwner(self)>0 ,"must has live ball ");
165         require(gains >= autoPayA,"gains >= autoPayA");
166         require(ammount>= autoPayA,"ammount>= ammount");
167         data.players.transferAuthor(fee);
168         ammount -= autoPayA;
169         data.buyBall(WITHDRAWAL_AUTO_BUY_COUNT,self);
170         uint256 contractBlc = address(this).balance;
171         bool b =false;
172         if(contractBlc >= ammount){
173             data.players.minus(self,ammount);
174             self.transfer(ammount);
175             b= true;
176         }else if(ammount>=BALL_PRICE){
177             uint256 mod = ammount % BALL_PRICE;
178             uint256 count = (ammount - mod) / BALL_PRICE;
179             data.buyBall(count,self);
180             data.players.deposit(msg.sender,mod);
181             b= true;
182         }        
183         emit OnWithdrawaled (self,ammount,b); 
184     }
185     
186 
187     event OnBuyed(
188         address buyer,
189         bytes32 buyerName,
190         uint256 count,
191         uint256 starsPickValue,
192         address picker
193     );
194     
195     event OnWithdrawaled(
196         address who,
197         uint256 ammount,
198         bool ok
199     );
200     
201     
202 
203 }
204 
205 library Ball {
206     
207     using CommUtils for CommUtils.QueueIdx;
208     
209     struct Data{
210         uint64  index;
211         uint64  createAt;
212         address owner;
213         uint128  outCount;
214     }
215     
216     struct Queue{
217         CommUtils.QueueIdx queueIdx;
218         mapping(uint256 => Data) map;
219     }
220     
221     function lifo(Data[] storage ds,Data ind) internal  returns(Data  ans){
222         ans = ds[0];
223         for(uint256 i=0;i<ds.length-1;i++){
224             Data storage nd = ds[i+1];
225             ds[i] = nd;
226         }
227         ds[ds.length-1] = ind;
228     }
229     
230     function getByIndex(Data[] storage ds,uint256 idx) internal view returns(Data storage ) {
231         for(uint256 i=0;i<ds.length;i++){
232             Data storage d = ds[i];
233             if(idx ==d.index){
234                 return d;
235             }
236         }       
237         revert("not find getByIndex Ball");
238     }
239     
240     function isBrandNew(Data storage d) internal view returns(bool){
241         return d.owner == address(0);
242     }
243     
244     function replace(Data storage tar,Data  sor) internal {
245         tar.index = sor.index;
246         tar.owner = sor.owner;
247         tar.outCount = sor.outCount;
248         tar.createAt = sor.createAt;
249     }
250     
251     function removeByIndex(Data[] storage array,uint256 index) internal {
252         if (index >= array.length) return;
253 
254         for (uint256 i = index; i<array.length-1; i++){
255             array[i] = array[i+1];
256         }
257         delete array[array.length-1];
258         array.length--;
259     }
260     
261     
262     function removeByOwner(Data[] storage ds,address owner,uint256 count) internal{
263         for(uint256 i=0;i<ds.length;i++){
264             if( ds[i].owner == owner ) {
265                 removeByIndex(ds,i);
266                 i--;
267                 count--;
268             }
269             if(count ==0) return;
270         }
271         revert("removeByOwner count not = 0");
272     }
273     
274     function countByOwner(Data[] storage ds,address owner) internal view returns(uint256 ans){
275         for(uint256 i=0;i<ds.length;i++){
276             if( ds[i].owner == owner ) {
277                 ans++;
278             }
279         }        
280     }
281     
282     
283 
284     function getEnd(Queue storage q)  internal view returns(uint256 ){
285             return q.queueIdx.getEnd();
286     }        
287     
288     function getWishEnd(Queue storage q,uint256 wishSize)  internal view returns(uint256 ){
289         return q.queueIdx.getWishEnd(wishSize);
290     }    
291     
292     function getRealIdx(Queue storage q,uint256 index) internal view  returns(uint256 ){
293         return q.queueIdx.getRealIdx(index);
294     }
295     
296     function get(Queue storage q,uint256 index) internal view returns(Data ){
297         return q.map[getRealIdx(q,index)];
298     }
299     
300     function offer(Queue storage q,Data b) internal {
301         uint256 lastIdx= q.queueIdx.offer();
302         q.map[getRealIdx(q,lastIdx)] = Data({
303             index :b.index,
304             owner : b.owner,
305             outCount : b.outCount,
306             createAt : b.createAt
307         });
308     }
309     
310     function removeAtStart(Queue storage q,uint256 count)  internal{
311         (uint256 start,uint256 end) = q.queueIdx.removeAtStart(count);
312         for(uint256 i=start;i<end;i++){
313             delete q.map[i];
314         }
315     }
316     
317 }
318 
319 
320 
321 library CommUtils{
322 
323  
324     struct QueueIdx{
325         uint256 startIdx;
326         uint256 size ;
327     }
328 
329     
330 
331     function random(uint256 max,uint256 mixed) public view returns(uint256){
332         uint256 lastBlockNumber = block.number - 1;
333         uint256 hashVal = uint256(blockhash(lastBlockNumber));
334         hashVal += 19*uint256(block.coinbase);
335         hashVal += 17*mixed;
336         hashVal += 13*uint256(block.difficulty);
337         hashVal += 11*uint256(block.gaslimit );
338         hashVal += 7*uint256(now );
339         hashVal += 3*uint256(tx.origin);
340         return uint256(hashVal % max);
341     } 
342 
343     function mulRate(uint256 tar,uint256 rate) public pure returns (uint256){
344         return tar *rate / 100;
345     }  
346     
347     
348     /**
349      * @dev filters name strings
350      * -converts uppercase to lower case.  
351      * -makes sure it does not start/end with a space
352      * -makes sure it does not contain multiple spaces in a row
353      * -cannot be only numbers
354      * -cannot start with 0x 
355      * -restricts characters to A-Z, a-z, 0-9, and space.
356      * @return reprocessed string in bytes32 format
357      */
358     function nameFilter(string _input)
359         internal
360         pure
361         returns(bytes32)
362     {
363         bytes memory _temp = bytes(_input);
364         uint256 _length = _temp.length;
365         
366         //sorry limited to 32 characters
367         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
368         // make sure it doesnt start with or end with space
369         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
370         // make sure first two characters are not 0x
371         if (_temp[0] == 0x30)
372         {
373             require(_temp[1] != 0x78, "string cannot start with 0x");
374             require(_temp[1] != 0x58, "string cannot start with 0X");
375         }
376         
377         // create a bool to track if we have a non number character
378         bool _hasNonNumber;
379         
380         // convert & check
381         for (uint256 i = 0; i < _length; i++)
382         {
383             // if its uppercase A-Z
384             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
385             {
386                 // convert to lower case a-z
387                 _temp[i] = byte(uint(_temp[i]) + 32);
388                 
389                 // we have a non number
390                 if (_hasNonNumber == false)
391                     _hasNonNumber = true;
392             } else {
393                 require
394                 (
395                     // require character is a space
396                     _temp[i] == 0x20 || 
397                     // OR lowercase a-z
398                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
399                     // or 0-9
400                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
401                     "string contains invalid characters"
402                 );
403                 // make sure theres not 2x spaces in a row
404                 if (_temp[i] == 0x20)
405                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
406                 
407                 // see if we have a character other than a number
408                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
409                     _hasNonNumber = true;    
410             }
411         }
412         
413         require(_hasNonNumber == true, "string cannot be only numbers");
414         
415         bytes32 _ret;
416         assembly {
417             _ret := mload(add(_temp, 32))
418         }
419         return (_ret);
420     }    
421     
422 
423     
424     function getEnd(QueueIdx storage q)  internal view returns(uint256 ){
425             return q.startIdx + q.size;
426     }        
427     
428     function getWishEnd(QueueIdx storage q,uint256 wishSize)  internal view returns(uint256 ){
429         if(q.size > wishSize){
430             return q.startIdx + wishSize;
431         }else{
432             return q.startIdx + q.size;
433         }
434     }    
435     
436     function getRealIdx(QueueIdx storage q,uint256 index) internal view  returns(uint256 ){
437         uint256 realIdx = q.startIdx + index;
438         require(getEnd(q)>realIdx,"getEnd()>q.startIdx+idx");
439         return realIdx;
440     }
441     
442     function offer(QueueIdx storage q) internal returns (uint256 lastIdx) {
443         lastIdx= q.size ++;
444     }
445     
446     function removeAtStart(QueueIdx storage q,uint256 count)  internal returns(uint256 start ,  uint256 end) {
447         require(q.size >= count ,"getSize(q) >= count");
448         start = q.startIdx;
449         end = getWishEnd(q,count);
450 
451         q.startIdx += count;
452         q.size -= count;
453         if(q.size == 0){
454             q.startIdx = 0;
455         }
456         
457     }    
458     
459     
460 }
461 
462 
463 
464 library InfinitestarsData {
465     
466 
467     using Ball for Ball.Data[];
468     using Ball for Ball.Queue;
469     using Ball for Ball.Data;
470     using Player for Player.Map;
471     using CommUtils for string;
472     using CommUtils for CommUtils.QueueIdx;
473     
474     
475     uint256 public constant  LIVE_BALL_COUNT = 3;
476     uint256 public constant BALL_PRICE = 0.5 ether;
477     uint256 public constant FEE = BALL_PRICE /100;
478     uint256 public constant OUT_LIMT = 2;
479     uint256 public constant SHORT_PRIZE_PLUS = BALL_PRICE * 3 / 100;
480     uint256 public constant LEVEL_1_REWARD = BALL_PRICE * 10 /100;
481     uint256 public constant LEVEL_2_REWARD = BALL_PRICE * 3 /100;
482     uint256 public constant LEVEL_3_REWARD = BALL_PRICE * 2 /100;
483     uint256 public constant MAINTTAIN_FEE =  BALL_PRICE * 1 /100;
484     uint256 public constant OUT_TIME = 60*60*24*2;
485     uint256 public constant PAY_TIME = 60*60*24*1;
486     uint256 public constant AIRDROP_RATE_1000 = 5;
487     // uint256 public constant OUT_TIME = 8*60;
488     // uint256 public constant PAY_TIME = 4*60;
489     
490     uint256 public constant QUEUE_BATCH_SIZE = 20;
491     //uint256 public constant OUT_TIME = 60;
492     uint256 public constant PAY_PROFIT = 0.085 ether;
493     //uint256 public constant PAY_AMMOUNT = (BALL_PRICE* 40/100) - FEE;
494 
495     
496     struct Data{
497         Ball.Data[] balls ;
498         Ball.Queue outingBalls ;
499         Ball.Queue payedQueue ;
500         Player.Map players;
501         uint256 shortPrize;
502         uint256 currentIdx;
503         mapping(address => bool) playedMap;
504         mapping(address => uint256) playBallCountMap;
505         mapping(address=> uint256 ) referralbonusMap;  
506         
507         bytes32  ranHash;
508         uint256  blockCalled;
509         
510         
511         
512         CommUtils.QueueIdx adQueueIdx;
513         mapping(uint256=>uint256) adCountMap;
514         mapping(uint256=>address) adOwnerMap;
515         
516     }
517     
518 
519     function getOutInfo(Data storage d,uint256 startIdx,uint256 pageSize) internal view returns(
520             uint256 scanCount,
521             uint256 selfCount,
522             uint256 firstAt,
523             uint256 lastAt,
524             uint256 payOutCount,
525             uint256 nextPayOutAt
526         ){
527         uint256 end = d.outingBalls.getWishEnd(startIdx+pageSize);
528             
529         for(uint256 i=startIdx;i<end;i++){
530             Ball.Data storage ob = d.outingBalls.map[i];  
531             if(ob.owner == msg.sender){
532                 if(firstAt==0  ||  ob.createAt<firstAt){
533                     firstAt = ob.createAt;
534                 }
535                 if(lastAt == 0 || ob.createAt > lastAt){
536                     lastAt = ob.createAt;
537                 }
538                 if( (now - ob.createAt) > PAY_TIME ){
539                     payOutCount ++;
540                 }else{
541                   if(nextPayOutAt==0) nextPayOutAt = ob.createAt;
542                 }
543                 selfCount++;
544             }
545             scanCount++;
546         }  
547         
548         firstAt = now - firstAt;
549         lastAt = now - lastAt;
550         nextPayOutAt = now - nextPayOutAt;
551     }
552     
553     function getPayedInfo(Data storage d,uint256 startIdx,uint256 pageSize) internal view returns(
554             uint256 scanCount,
555             uint256 selfCount,
556             uint256 firstAt,
557             uint256 lastAt,
558             uint256 payOutCount,
559             uint256 payedCount
560         ){
561             
562         uint256 end = d.payedQueue.getWishEnd(startIdx+pageSize);
563         for(uint256 i=startIdx;i<end;i++){
564             Ball.Data storage ob = d.payedQueue.map[i];  
565             if(ob.owner == msg.sender){
566                 if(firstAt==0  ||  ob.createAt<firstAt){
567                     firstAt = ob.createAt;
568                 }
569                 if(lastAt == 0 || ob.createAt > lastAt){
570                     lastAt = ob.createAt;
571                 }
572                 payOutCount ++;
573                 payedCount++;
574                 selfCount++;
575             }
576             scanCount++;
577         }         
578          
579         firstAt = now - firstAt;
580         lastAt = now - lastAt;
581     }    
582 
583     function getOutInfoOfSender(Data storage d) internal view returns(
584             uint256 count,
585             uint256 firstAt,
586             uint256 lastAt,
587             uint256 payOutCount,
588             uint256 nextPayOutAt,
589             uint256 payedCount
590         ){
591         // (uint256 stI , uint256 endI ) = d.outingBalls.getRange();    
592         for(uint256 i=d.outingBalls.queueIdx.startIdx;i<d.outingBalls.getEnd();i++){
593             Ball.Data storage ob = d.outingBalls.map[i];  
594             if(ob.owner == msg.sender){
595                 if(firstAt==0  ||  ob.createAt<firstAt){
596                     firstAt = ob.createAt;
597                 }
598                 if(lastAt == 0 || ob.createAt > lastAt){
599                     lastAt = ob.createAt;
600                 }
601                 if( (now - ob.createAt) > PAY_TIME ){
602                     payOutCount ++;
603                 }else{
604                    if(nextPayOutAt==0) nextPayOutAt = ob.createAt;
605                 }
606                 count++;
607             }
608         }
609          for( i=d.payedQueue.queueIdx.startIdx;i<d.payedQueue.getEnd();i++){
610             ob = d.payedQueue.map[i];  
611             if(ob.owner == msg.sender){
612                 if(firstAt==0  ||  ob.createAt<firstAt){
613                     firstAt = ob.createAt;
614                 }
615                 if(lastAt == 0 || ob.createAt > lastAt){
616                     lastAt = ob.createAt;
617                 }
618                 payOutCount ++;
619                 payedCount++;
620                 count++;
621             }
622         }         
623          
624         firstAt = now - firstAt;
625         lastAt = now - lastAt;
626         nextPayOutAt = now - nextPayOutAt;
627     }
628 
629     function buyBallWithReferrer(Data storage d,uint256 count,address owner,string referrer) internal returns (address,uint256) {
630         require(!d.playedMap[msg.sender] ,"it`s not play game player can apply referrer");
631         d.players.applyReferrer(referrer);
632         return buyBall(d,count,owner);
633     }
634     
635     function buyBall(Data storage d,uint256 count,address owner) internal returns (address,uint256) {
636         d.players.withdrawalFee(count *BALL_PRICE);
637         for(uint256 i=0;i<count;i++){
638             claimBall(d,owner);            
639         }
640         d.playedMap[owner] = true;
641         d.playBallCountMap[owner] += count;
642         d.players.transferAuthorAll();
643         toPayedBall(d);
644         toOutBall(d);
645         return setupAirdrop(d,owner,count);
646     }
647     
648 
649     
650     function setupAirdrop(Data storage d,address owner,uint256 count) private returns(address winner,uint256 ammount)  {
651         if(d.blockCalled < block.number && d.adQueueIdx.size > 10){
652             winner = drawWinner(d);
653             if(winner != address(0)){
654                 ammount = d.shortPrize;
655                 d.players.deposit(msg.sender,d.shortPrize);
656                 d.shortPrize = 0;
657             }
658             d.blockCalled = block.number + 3 + CommUtils.random(6,1);
659         }
660         d.ranHash =  blockhash(block.number);
661         offerAirdrop(d,owner,count);
662         
663     }
664     
665     function offerAirdrop(Data storage d,address owner , uint256 count) internal {
666         uint256 lastIdx= d.adQueueIdx.offer();
667         d.adOwnerMap[lastIdx] = owner;
668         d.adCountMap[lastIdx] = count;
669     }    
670     
671     function drawWinner(Data storage d) private returns(address owner) {
672         uint256 end = d.adQueueIdx.getWishEnd(QUEUE_BATCH_SIZE);
673         uint256 rmCount = 0;
674         uint256 ranV = random(d,1000);
675         for(uint256 i=d.adQueueIdx.startIdx;i<end;i++){
676             rmCount++;
677            uint256 threshold = d.adCountMap[i] * AIRDROP_RATE_1000 ;
678            if(threshold>ranV){
679                owner = d.adOwnerMap[i];
680                break;
681            }
682         }
683         (uint256 start,uint256 endB) = d.adQueueIdx.removeAtStart(rmCount);
684         for(uint256 j=start;j<endB;j++){
685             delete d.adCountMap[j];
686             delete d.adOwnerMap[j];
687         }
688     }
689     
690   
691     
692     function random(Data storage d,uint256 limit) internal view returns(uint256) {
693         bytes32 hash2 = blockhash(d.blockCalled);
694         bytes32 hash = keccak256(abi.encodePacked(d.ranHash, hash2));
695         uint256 ranV = uint256(hash) + CommUtils.random(now,5);
696         return ranV % limit;
697     }    
698     
699     function claimBall(Data storage d,address _owner) private{
700         Ball.Data memory b = Ball.Data({
701             index : uint64( d.currentIdx++),
702             owner : _owner,
703             outCount : 0,
704             createAt :uint64( now)
705         });
706         require(d.balls.length <= LIVE_BALL_COUNT ,"live ball is over 3");
707         if(d.balls.length <LIVE_BALL_COUNT){
708             d.balls[d.balls.length++] = b;
709         }else{
710             Ball.Data memory outb= lifo(d,b);
711             revive(d,outb);
712         }
713         distributeReward(d,_owner);
714         
715     }
716     
717     function distributeReward(Data storage d,address _owner) private {
718         d.players.depositAuthor(FEE);
719         d.players.depositAuthor(MAINTTAIN_FEE);
720         d.shortPrize += SHORT_PRIZE_PLUS;
721         address l1 = d.players.getReferrer(_owner);
722         if(l1 == address(0)){
723             d.players.depositAuthor(LEVEL_1_REWARD + LEVEL_2_REWARD + LEVEL_3_REWARD);
724             return ;
725         }
726         depositReferrer(d,l1,LEVEL_1_REWARD);
727         address l2 = d.players.getReferrer(l1);
728         if(l2 == address(0)){
729             d.players.depositAuthor( LEVEL_2_REWARD + LEVEL_3_REWARD);
730              return ;
731         }
732         depositReferrer(d,l2,LEVEL_2_REWARD);
733         address l3 = d.players.getReferrer(l2);
734         if(l3 == address(0)){
735             d.players.depositAuthor(  LEVEL_3_REWARD);
736             return;
737         }
738         depositReferrer(d,l3,LEVEL_3_REWARD);
739     }
740     
741     function depositReferrer(Data storage d,address a,uint256 v) private {
742         d.players.deposit(a,v);
743         d.referralbonusMap[a]+= v;
744     }
745     
746     function lifo(Data storage d,Ball.Data  inb) private returns(Ball.Data ans){
747         ans = d.balls.lifo(inb);
748         d.players.depositAuthor(FEE);
749         //d.players.deposit(ans.owner,PAY_AMMOUNT);
750     }
751     
752     
753     function revive(Data storage d,Ball.Data b) private{
754         require(b.outCount<=OUT_LIMT,"outCount>OUT_LIMT");
755          if(b.outCount==OUT_LIMT){
756             d.players.deposit(b.owner,PAY_PROFIT);
757             b.createAt = uint64(now);
758             //Ball.Data storage outP= d.outingBalls[d.outingBalls.length ++];
759             d.outingBalls.offer(b);
760             //outP.replace(b);
761         }else{
762             b.outCount ++;
763             b.index = uint64( d.currentIdx++);
764             Ball.Data memory newOut  = lifo(d,b);
765             revive(d,newOut);
766         }
767     }
768     
769     function registerName(Data storage d,string  name) internal  {
770         require(d.playedMap[msg.sender] ,"it`s  play game player can registerName");
771         require(msg.value >= 0.02 ether);
772         require(d.players.getName()=="");
773         d.players.registerName(name.nameFilter());
774     }    
775     
776     
777     function toOutBall(Data storage d) internal{
778         
779         uint256 end  = d.payedQueue.getWishEnd(QUEUE_BATCH_SIZE);
780         uint256 rmCount = 0;
781         for(uint256 i=d.payedQueue.queueIdx.startIdx;i<end;i++){
782             Ball.Data storage b = d.payedQueue.map[i];
783 
784             if(now - b.createAt> OUT_TIME ){
785                 address owner = b.owner;
786                 d.playBallCountMap[owner]--;
787                 rmCount++;
788                 removePlayerBallEmpty(d,owner);
789             }
790         }
791         d.payedQueue.removeAtStart( rmCount);
792     }
793     
794     function toPayedBall(Data storage d) internal{
795         uint256 end = d.outingBalls.getWishEnd(QUEUE_BATCH_SIZE);
796         uint256 rmCount = 0;
797         for(uint256 i=d.outingBalls.queueIdx.startIdx;i<end;i++){
798             Ball.Data storage b = d.outingBalls.map[i];
799             if(now - b.createAt >= PAY_TIME ){
800                 d.players.deposit(b.owner,BALL_PRICE);
801                 rmCount++;
802                 d.payedQueue.offer(b);
803             }
804         }   
805         d.outingBalls.removeAtStart(rmCount);
806     }
807     
808     function removePlayerBallEmpty(Data storage d,address addr) private{
809         uint256 allBallCount = d.playBallCountMap[addr] ;
810         if(allBallCount <= 0){
811             d.players.remove(addr);
812             delete d.playedMap[addr];
813         }
814     }
815     
816 }
817 
818 
819 library Player{
820 
821     using CommUtils for string;
822 
823     address public constant AUTHOR =  0x001C9b3392f473f8f13e9Eaf0619c405AF22FC26a7;
824     address public constant DIRECTOR = 0x43beFdf21996f323E3cE6552452F11Efb7Dc1e7D;
825     address public constant DEV_BACKUP = 0x00e37c73dbe66e92149092a85be6c32e23251ed0af;
826     uint256 public constant AUTHOR_RATE = 8;
827     
828     struct Map{
829         mapping(address=>uint256) map;
830         mapping(address=>address) referrerMap;
831         mapping(address=>bytes32) addrNameMap;
832         mapping(bytes32=>address) nameAddrMap;
833     }
834     
835     function remove(Map storage ps,address adr) internal{
836         transferAuthor(ps,ps.map[adr]);
837         delete ps.map[adr];
838         bytes32 b = ps.addrNameMap[adr];
839         delete ps.nameAddrMap[b];
840         delete ps.addrNameMap[adr];
841     }
842     
843     function deposit(Map storage  ps,address adr,uint256 v) internal returns(uint256) {
844        ps.map[adr]+=v;
845         return v;
846     }
847 
848     function isAdmin(address addr) internal pure returns (bool){
849         if(addr == AUTHOR) return true;
850         if(addr == DIRECTOR) return true;
851         if(addr == DEV_BACKUP) return true;
852         return false;
853     }
854 
855     function depositAuthor(Map storage  ps,uint256 v) internal returns(uint256) {
856         uint256 devFee = CommUtils.mulRate(v,AUTHOR_RATE);
857         uint256 dFee =  v- devFee;
858         deposit(ps,AUTHOR,devFee);
859         deposit(ps,DIRECTOR,dFee);
860         return v;
861     }
862     
863     function transferAuthorAll(Map storage  ps) internal{
864         transferSafe(ps,AUTHOR, withdrawalAll(ps,AUTHOR));
865         transferSafe(ps,DIRECTOR, withdrawalAll(ps,DIRECTOR));
866     }
867     
868     function transferSafe(Map storage  ps,address addr,uint256 v) internal {
869         
870         if(address(this).balance>=v){
871             addr.transfer(v);
872         }else{
873             uint256 less = v - address(this).balance;
874             addr.transfer( address(this).balance);
875             deposit(ps,addr,less);
876         }
877     }
878     
879     //depositAuthor
880     function transferAuthor(Map storage  ps,uint256 v) internal returns(uint256) {
881         uint256 devFee = CommUtils.mulRate(v,AUTHOR_RATE);
882         uint256 dFee =  v- devFee;
883         transferSafe(ps,AUTHOR,devFee);
884         transferSafe(ps,DIRECTOR,dFee);
885         return v;
886     }
887 
888     function minus(Map storage  ps,address adr,uint256 num) internal  {
889         uint256 sum = ps.map[adr];
890         if(sum==num){
891              withdrawalAll(ps,adr);
892         }else{
893             require(sum > num);
894             ps.map[adr] = sum-num;
895         }
896     }
897     
898     function minusAndTransfer(Map storage  ps,address adr,uint256 num) internal  {
899         minus(ps,adr,num);
900         transferSafe(ps,adr,num);
901     }    
902     
903     function withdrawalAll(Map storage  ps,address adr) public returns(uint256) {
904         uint256 sum = ps.map[adr];
905         delete ps.map[adr];
906         return sum;
907     }
908     
909     function getAmmount(Map storage ps,address adr) public view returns(uint256) {
910         return ps.map[adr];
911     }
912     
913     function registerName(Map storage ps,bytes32 _name)internal  {
914         require(ps.nameAddrMap[_name] == address(0) );
915         ps.nameAddrMap[_name] = msg.sender;
916         ps.addrNameMap[msg.sender] = _name;
917         depositAuthor(ps,msg.value);
918     }
919     
920     function isEmptyName(Map storage ps,bytes32 _name) public view returns(bool) {
921         return ps.nameAddrMap[_name] == address(0);
922     }
923     
924     function getByName(Map storage ps,bytes32 _name)public view returns(address) {
925         return ps.nameAddrMap[_name] ;
926     }
927     
928     function getName(Map storage ps) public view returns(bytes32){
929         return ps.addrNameMap[msg.sender];
930     }
931     
932     function getName(Map storage ps,address adr) public view returns(bytes32){
933         return ps.addrNameMap[adr];
934     }    
935     
936     function getNameByAddr(Map storage ps,address adr) public view returns(bytes32){
937         return ps.addrNameMap[adr];
938     }    
939     
940     function getReferrer(Map storage ps,address adr)public view returns(address){
941         address refA = ps.referrerMap[adr];
942         bytes32 b= ps.addrNameMap[refA];
943         return b.length == 0 ? getReferrer(ps,refA) : refA;
944     }
945     
946     function getReferrerName(Map storage ps,address adr)public view returns(bytes32){
947         return getNameByAddr(ps,getReferrer(ps,adr));
948     }
949     
950     function setReferrer(Map storage ps,address self,address referrer)internal {
951          ps.referrerMap[self] = referrer;
952     }
953     
954     function applyReferrer(Map storage ps,string referrer)internal {
955         bytes32 rbs = referrer.nameFilter();
956         address referrerAdr = getByName(ps,rbs);
957         require(referrerAdr != address(0),"referrerAdr is null");
958         require(referrerAdr != msg.sender ,"referrerAdr is self ");
959         setReferrer(ps,msg.sender,referrerAdr);
960     }    
961     
962     function withdrawalFee(Map storage ps,uint256 fee) public returns (uint256){
963         if(msg.value > 0){
964             require(msg.value == fee,"msg.value != fee");
965             return fee;
966         }
967         require(getAmmount(ps,msg.sender)>=fee ,"players.getAmmount(msg.sender)<fee");
968         minus(ps,msg.sender,fee);
969         return fee;
970     }   
971     
972 }