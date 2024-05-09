1 pragma solidity ^0.4.24;
2 
3 
4 library Player{
5 
6     using CommUtils for string;
7 
8     address public constant AUTHOR =  0x001C9b3392f473f8f13e9Eaf0619c405AF22FC26a7;
9     
10     struct Map{
11         mapping(address=>uint256) map;
12         mapping(address=>address) referrerMap;
13         mapping(address=>bytes32) addrNameMap;
14         mapping(bytes32=>address) nameAddrMap;
15     }
16     
17     function deposit(Map storage  ps,address adr,uint256 v) internal returns(uint256) {
18        ps.map[adr]+=v;
19         return v;
20     }
21     
22     function depositAuthor(Map storage  ps,uint256 v) public returns(uint256) {
23         return deposit(ps,AUTHOR,v);
24     }
25 
26     function withdrawal(Map storage  ps,address adr,uint256 num) public returns(uint256) {
27         uint256 sum = ps.map[adr];
28         if(sum==num){
29             withdrawalAll(ps,adr);
30         }
31         require(sum > num);
32         ps.map[adr] = (sum-num);
33         return sum;
34     }
35     
36     function withdrawalAll(Map storage  ps,address adr) public returns(uint256) {
37         uint256 sum = ps.map[adr];
38         require(sum >= 0);
39         delete ps.map[adr];
40         return sum;
41     }
42     
43     function getAmmount(Map storage ps,address adr) public view returns(uint256) {
44         return ps.map[adr];
45     }
46     
47     function registerName(Map storage ps,bytes32 _name)internal  {
48         require(ps.nameAddrMap[_name] == address(0) );
49         ps.nameAddrMap[_name] = msg.sender;
50         ps.addrNameMap[msg.sender] = _name;
51         depositAuthor(ps,msg.value);
52     }
53     
54     function isEmptyName(Map storage ps,bytes32 _name) public view returns(bool) {
55         return ps.nameAddrMap[_name] == address(0);
56     }
57     
58     function getByName(Map storage ps,bytes32 _name)public view returns(address) {
59         return ps.nameAddrMap[_name] ;
60     }
61     
62     function getName(Map storage ps) public view returns(bytes32){
63         return ps.addrNameMap[msg.sender];
64     }
65     
66     function getNameByAddr(Map storage ps,address adr) public view returns(bytes32){
67         return ps.addrNameMap[adr];
68     }    
69     
70     function getReferrer(Map storage ps,address adr)public view returns(address){
71         return ps.referrerMap[adr];
72     }
73     
74     function getReferrerName(Map storage ps,address adr)public view returns(bytes32){
75         return getNameByAddr(ps,getReferrer(ps,adr));
76     }
77     
78     function setReferrer(Map storage ps,address self,address referrer)internal {
79          ps.referrerMap[self] = referrer;
80     }
81     
82     function applyReferrer(Map storage ps,string referrer)internal {
83         require(getReferrer(ps,msg.sender) == address(0));
84         bytes32 rbs = referrer.nameFilter();
85         address referrerAdr = getByName(ps,rbs);
86         if(referrerAdr != msg.sender){
87             setReferrer(ps,msg.sender,referrerAdr);
88         }
89     }    
90     
91     function withdrawalFee(Map storage ps,uint256 fee) public returns (uint256){
92         if(msg.value > 0){
93             require(msg.value >= fee,"msg.value < fee");
94             return fee;
95         }
96         require(getAmmount(ps,msg.sender)>=fee ,"players.getAmmount(msg.sender)<fee");
97         withdrawal(ps,msg.sender,fee);
98         return fee;
99     }   
100     
101 }
102 
103 
104 library CommUtils{
105     
106 
107     function removeByIdx(uint256[] array,uint256 idx) public pure returns(uint256[] memory){
108          uint256[] memory ans = copy(array,array.length-1);
109         while((idx+1) < array.length){
110             ans[idx] = array[idx+1];
111             idx++;
112         }
113         return ans;
114     }
115     
116     function copy(uint256[] array,uint256 len) public pure returns(uint256[] memory){
117         uint256[] memory ans = new uint256[](len);
118         len = len > array.length? array.length : len;
119         for(uint256 i =0;i<len;i++){
120             ans[i] = array[i];
121         }
122         return ans;
123     }
124     
125     function getHash(uint256[] array) public pure returns(uint256) {
126         uint256 baseStep =100;
127         uint256 pow = 1;
128         uint256 ans = 0;
129         for(uint256 i=0;i<array.length;i++){
130             ans= ans+ uint256(array[i] *pow ) ;
131             pow= pow* baseStep;
132         }
133         return ans;
134     }
135     
136     function contains(address[] adrs,address adr)public pure returns(bool){
137         for(uint256 i=0;i<adrs.length;i++){
138             if(adrs[i] ==  adr) return true;
139         }
140         return false;
141     }
142 
143     
144     function random(uint256 max,uint256 mixed) public view returns(uint256){
145         uint256 lastBlockNumber = block.number - 1;
146         uint256 hashVal = uint256(blockhash(lastBlockNumber));
147         hashVal += 31*uint256(block.coinbase);
148         hashVal += 19*mixed;
149         hashVal += 17*uint256(block.difficulty);
150         hashVal += 13*uint256(block.gaslimit );
151         hashVal += 11*uint256(now );
152         hashVal += 7*uint256(block.timestamp );
153         hashVal += 3*uint256(tx.origin);
154         return uint256(hashVal % max);
155     } 
156     
157     function getIdxArray(uint256 len) public pure returns(uint256[]){
158         uint256[] memory ans = new uint256[](len);
159         for(uint128 i=0;i<len;i++){
160             ans[i] = i;
161         }
162         return ans;
163     }
164     
165     function genRandomArray(uint256 digits,uint256 templateLen,uint256 base) public view returns(uint256[]) {
166         uint256[] memory ans = new uint256[](digits);
167         uint256[] memory idxs  = getIdxArray( templateLen);
168        for(uint256 i=0;i<digits;i++){
169             uint256  idx = random(idxs.length,i+base);
170             uint256 wordIdx = idxs[idx];
171             ans[i] = wordIdx;
172             idxs = removeByIdx(idxs,idx);
173            
174        }
175        return ans;
176     }
177    
178    
179 
180     
181    /**
182     * @dev Multiplies two numbers, throws on overflow.
183     */
184     function multiplies(uint256 a, uint256 b) 
185         private 
186         pure 
187         returns (uint256 c) 
188     {
189         if (a == 0) {
190             return 0;
191         }
192         c = a * b;
193         require(c / a == b, "SafeMath mul failed");
194         return c;
195     }
196     
197     function pwr(uint256 x, uint256 y)
198         internal 
199         pure 
200         returns (uint256)
201     {
202         if (x==0)
203             return (0);
204         else if (y==0)
205             return (1);
206         else 
207         {
208             uint256 z = x;
209             for (uint256 i=1; i < y; i++)
210                 z = multiplies(z,x);
211             return (z);
212         }
213     }
214     
215     function pwrFloat(uint256 tar,uint256 numerator,uint256 denominator,uint256 pwrN) public pure returns(uint256) {
216         for(uint256 i=0;i<pwrN;i++){
217             tar = tar * numerator / denominator;
218         }
219         return tar ;
220         
221     }
222 
223     
224     function mulRate(uint256 tar,uint256 rate) public pure returns (uint256){
225         return tar *rate / 100;
226     }  
227     
228     
229     /**
230      * @dev filters name strings
231      * -converts uppercase to lower case.  
232      * -makes sure it does not start/end with a space
233      * -makes sure it does not contain multiple spaces in a row
234      * -cannot be only numbers
235      * -cannot start with 0x 
236      * -restricts characters to A-Z, a-z, 0-9, and space.
237      * @return reprocessed string in bytes32 format
238      */
239     function nameFilter(string _input)
240         internal
241         pure
242         returns(bytes32)
243     {
244         bytes memory _temp = bytes(_input);
245         uint256 _length = _temp.length;
246         
247         //sorry limited to 32 characters
248         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
249         // make sure it doesnt start with or end with space
250         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
251         // make sure first two characters are not 0x
252         if (_temp[0] == 0x30)
253         {
254             require(_temp[1] != 0x78, "string cannot start with 0x");
255             require(_temp[1] != 0x58, "string cannot start with 0X");
256         }
257         
258         // create a bool to track if we have a non number character
259         bool _hasNonNumber;
260         
261         // convert & check
262         for (uint256 i = 0; i < _length; i++)
263         {
264             // if its uppercase A-Z
265             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
266             {
267                 // convert to lower case a-z
268                 _temp[i] = byte(uint(_temp[i]) + 32);
269                 
270                 // we have a non number
271                 if (_hasNonNumber == false)
272                     _hasNonNumber = true;
273             } else {
274                 require
275                 (
276                     // require character is a space
277                     _temp[i] == 0x20 || 
278                     // OR lowercase a-z
279                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
280                     // or 0-9
281                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
282                     "string contains invalid characters"
283                 );
284                 // make sure theres not 2x spaces in a row
285                 if (_temp[i] == 0x20)
286                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
287                 
288                 // see if we have a character other than a number
289                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
290                     _hasNonNumber = true;    
291             }
292         }
293         
294         require(_hasNonNumber == true, "string cannot be only numbers");
295         
296         bytes32 _ret;
297         assembly {
298             _ret := mload(add(_temp, 32))
299         }
300         return (_ret);
301     }    
302     
303     
304 }
305 
306 
307 
308 library PlayerReply{
309     
310     using CommUtils for address[];
311     using CommUtils for uint256[];
312     
313     uint256 constant VISABLE_NONE = 0;
314     uint256 constant VISABLE_FINAL = 1;
315     uint256 constant VISABLE_ALL = 2;
316     uint256 constant VISABLE_OWNER = 3;
317     uint256 constant VISABLE_BUYED = 4;
318     
319     uint256 constant HIDE_TIME = 5*60;
320     
321     uint256 constant GRAND_TOTAL_TIME = 10*60;
322     
323     
324     struct Data{
325         address[] ownerIds;
326         uint256 aCount;
327         uint256 bCount;
328         uint256[] answer;
329         uint replyAt;
330     }
331     
332     struct List{
333         uint256 size;
334         mapping (uint256 => uint256) hashIds;
335         mapping (uint256 => Data) map;
336         mapping (uint256=>uint256) sellPriceMap;
337         mapping (uint256=>address) seller;
338         mapping (uint256=>address[]) buyer;
339     }
340     
341     
342     function init(Data storage d,uint256 ac,uint256 bc,address own) internal{
343           d.ownerIds.push(own)  ;
344           d.aCount = ac;
345           d.bCount = bc;
346           d.replyAt = now;
347     }
348     
349     function clear(List storage ds) internal{
350         for(uint256 i =0;i<ds.size;i++){
351             uint256 key = ds.hashIds[i];
352             delete ds.map[key];
353             delete ds.sellPriceMap[key];
354             delete ds.seller[key];
355             delete ds.buyer[key];
356             delete ds.hashIds[i];
357         }
358         ds.size = 0;
359     }
360     
361     function setSellPrice(List storage ds,uint256 ansHash,uint256 price) internal {
362         require(ds.map[ansHash].ownerIds.contains(msg.sender));
363         require(ds.seller[ansHash] == address(0));
364         ds.seller[ansHash] = msg.sender;
365         ds.sellPriceMap[ansHash] = price;
366     }
367     
368     function getSellPrice(List storage ds,uint256 idx) public view returns(uint256) {
369         return ds.sellPriceMap[ds.hashIds[idx]] ;
370     }
371     
372     function isOwner(Data storage d) internal view returns(bool){
373         return d.replyAt>0 && d.answer.length>0 && d.ownerIds.contains(msg.sender);
374     }
375     
376     function isWined(Data storage d) internal view returns(bool){
377         return d.replyAt>0 && d.answer.length>0 && d.aCount == d.answer.length ;
378     }
379     
380     function getWin(List storage ds) internal view returns(Data storage lastAns){
381         for(uint256 i=0;i<ds.size;i++){
382             Data storage d = get(ds,i);
383            if(isWined(d)){
384              return d;  
385            } 
386         }
387         
388         return lastAns;
389     }
390     
391     function getVisibleType(List storage ds,uint256 ansHash) internal view returns(uint256) {
392         Data storage d = ds.map[ansHash];
393         if(d.ownerIds.contains(msg.sender)){
394             return VISABLE_OWNER;
395         }else if(d.answer.length == d.aCount){
396             return VISABLE_FINAL;
397         }else if(ds.buyer[ansHash].contains(msg.sender)){
398             return VISABLE_BUYED;
399         }else if((now - d.replyAt)> HIDE_TIME && ds.sellPriceMap[ansHash] == 0){
400             return VISABLE_ALL;
401         }
402         return VISABLE_NONE;
403     }
404     
405     function getReplay(List storage ds,uint256 idx) internal view returns(
406         uint256 ,//aCount;
407         uint256,// bCount;
408         uint256[],// answer;
409         uint,// Timeline;
410         uint256, // VisibleType
411         uint256, //sellPrice
412         uint256 //ansHash
413         ) {
414             uint256 ansHash = ds.hashIds[idx];
415             uint256 sellPrice = ds.sellPriceMap[ansHash];
416             Data storage d= ds.map[ansHash];
417             uint256 vt = getVisibleType(ds,ansHash);
418         return (
419             d.aCount,
420             d.bCount,
421             vt!=VISABLE_NONE ?  d.answer : new uint256[](0),
422             now-d.replyAt,
423             vt,
424             sellPrice,
425             vt!=VISABLE_NONE ? ansHash : 0
426         );
427     } 
428     
429     function listBestScore(List storage ds) internal view returns(
430         uint256 aCount , //aCount    
431         uint256 bCount , //bCount
432         uint256 bestCount // Count
433         ){
434         uint256 sorce = 0;
435         for(uint256 i=0;i<ds.size;i++){
436             Data storage d = get(ds,i);
437             uint256 curSore = (d.aCount *100) + d.bCount;
438             if(curSore > sorce){
439                 aCount = d.aCount;
440                 bCount = d.bCount;
441                 sorce = curSore;
442                 bestCount = 1;
443             }else if(curSore == sorce){
444                 bestCount++;
445             }
446         }
447     }
448     
449     
450     function getOrGenByAnwser(List storage ds,uint256[] ans) internal  returns(Data storage ){
451         uint256 ansHash = ans.getHash();
452         Data storage d = ds.map[ansHash];
453         if(d.answer.length>0) return d;
454         d.answer = ans;
455         ds.hashIds[ds.size] = ansHash;
456         ds.size ++;
457         return d;
458     }
459     
460     
461     function get(List storage ds,uint256 idx) public view returns(Data storage){
462         return ds.map[ ds.hashIds[idx]];
463     }
464     
465     function getByHash(List storage ds ,uint256 ansHash)public view returns(Data storage){
466         return ds.map[ansHash];
467     }
468     
469     
470     function getLastReplyAt(List storage list) internal view returns(uint256){
471         return list.size>0 ? (now- get(list,list.size-1).replyAt) : 0;
472     }
473     
474     function getLastReply(List storage ds) internal view returns(Data storage d){
475         if( ds.size>0){
476             return get(ds,ds.size-1);
477         }
478         return d;
479     }    
480     
481     function countByGrand(List storage ds) internal view returns(uint256) {
482         if(ds.size == 0 ) return 0;
483         uint256 count = 0;
484         uint256 _lastAt = now;
485         uint256 lastIdx = ds.size-1;
486         Data memory d = get(ds,lastIdx-count);
487         while((_lastAt - d.replyAt)<= GRAND_TOTAL_TIME ){
488             count++;
489             _lastAt = d.replyAt;
490             if(count>lastIdx) return count;
491             d = get(ds,lastIdx-count);
492         }
493         return count;       
494     }
495     
496 }
497 
498 
499 library RoomInfo{
500     
501     using PlayerReply for PlayerReply.Data;
502     using PlayerReply for PlayerReply.List;
503     using Player for Player.Map;
504     using CommUtils for uint256[];
505     uint256 constant DIVIDEND_AUTH = 5;
506     uint256 constant DIVIDEND_INVITE = 2;
507     uint256 constant DIVIDEND_INVITE_REFOUND = 3;
508     uint256 constant DECIMAL_PLACE = 100;
509 
510     uint256 constant GRAND_RATE = 110;
511     
512     
513     
514     struct Data{
515         address ownerId;
516         uint256 charsLength;
517         uint256[] answer;
518         PlayerReply.List replys;
519         bytes32 name;
520         uint256 prize;
521         uint256 minReplyFee;
522         uint256 replayCount;
523         uint256 firstReplayAt;
524         uint256 rateCode;
525         uint256 round;
526         uint256 maxReplyFeeRate;
527         uint256 toAnswerRate;
528         uint256 toOwner;
529         uint256 nextRoundRate;
530         uint256 increaseRate_1000;
531         uint256 initAwardTime ;
532         uint256 plusAwardTime ;
533     }
534     
535     struct List{
536         mapping(uint256 => Data)  map;
537         uint256  size ;
538     }
539     
540     
541     
542     function genOrGetReplay(Data storage d,uint256[] ans) internal returns(PlayerReply.Data storage ) {
543         (PlayerReply.Data storage replayData)  = d.replys.getOrGenByAnwser(ans);
544         d.replayCount++;
545         if(d.firstReplayAt == 0) d.firstReplayAt = now;
546         return (replayData);
547     }
548     
549     function tryAnswer(Data storage d ,uint256[] _t ) internal view returns(uint256,uint256){
550         require(d.answer.length == _t.length);
551         uint256 aCount;
552         uint256 bCount;
553         for(uint256 i=0;i<_t.length;i++){
554             for(uint256 j=0;j<d.answer.length;j++){
555                 if(d.answer[j] == _t[i]){
556                     if(i == j){
557                         aCount++;
558                     }else{
559                         bCount ++;
560                     }
561                 }
562             }
563         }
564         return (aCount,bCount);
565     }
566 
567     function init(
568         Data storage d,
569         uint256 digits,
570         uint256 templateLen,
571         bytes32 n,
572         uint256 toAnswerRate,
573         uint256 toOwner,
574         uint256 nextRoundRate,
575         uint256 minReplyFee,
576         uint256 maxReplyFeeRate,
577         uint256 increaseRate_1000,
578         uint256 initAwardTime,
579         uint256 plusAwardTime
580         ) public {
581         require(maxReplyFeeRate<1000 && maxReplyFeeRate > 5 );
582         require(minReplyFee<= msg.value *maxReplyFeeRate /DECIMAL_PLACE && minReplyFee>= 0.000005 ether);
583         require(digits>=2 && digits <= 9 );
584         require((toAnswerRate+toOwner)<=90);
585         require(msg.value >= 0.001 ether);
586         require(nextRoundRate <= 70);
587         require(templateLen >= 10);
588         require(initAwardTime < 60*60*24*90);
589         require(plusAwardTime < 60*60*24*20);
590         require(CommUtils.mulRate(msg.value,100-nextRoundRate) >= minReplyFee);
591         
592         d.charsLength = templateLen;
593         d.answer = CommUtils.genRandomArray(digits,templateLen,0);       
594         d.ownerId = msg.sender;
595         d.name = n;
596         d.prize = msg.value;
597         d.minReplyFee = minReplyFee;
598         d.round = 1;
599         d.maxReplyFeeRate = maxReplyFeeRate;
600         d.toAnswerRate = toAnswerRate;
601         d.toOwner = toOwner;
602         d.nextRoundRate = nextRoundRate;
603         d.increaseRate_1000 = increaseRate_1000;
604         d.initAwardTime = initAwardTime;
605         d.plusAwardTime = plusAwardTime;
606         
607     }
608     
609     function replayAnser(Data storage r,Player.Map storage ps,uint256 fee,uint256[] tryA) internal returns(
610             uint256, // aCount
611             uint256 // bCount
612         )  {
613         (uint256 a, uint256 b) = tryAnswer(r,tryA);
614         saveReplyFee(r,ps,fee);
615         (PlayerReply.Data storage pr) = genOrGetReplay(r,tryA);
616         pr.init(a,b,msg.sender); 
617         return (a,b);
618     }
619     
620     function saveReplyFee(Data storage d,Player.Map storage ps,uint256 replayFee) internal  {
621         uint256 lessFee = replayFee;
622         //uint256 toAnswerRate= rates[IdxToAnswerRate];
623         //uint256 toOwner = rates[IdxToOwnerRate];
624         
625         lessFee -=sendReplayDividend(d,ps,replayFee*d.toAnswerRate/DECIMAL_PLACE);
626         address refer = ps.getReferrer(msg.sender);
627         if(refer == address(0)){
628             lessFee -=ps.depositAuthor(replayFee*(DIVIDEND_AUTH+DIVIDEND_INVITE+DIVIDEND_INVITE_REFOUND)/DECIMAL_PLACE);            
629         }else{
630             lessFee -=ps.deposit(msg.sender,replayFee*DIVIDEND_INVITE_REFOUND/DECIMAL_PLACE);
631             lessFee -=ps.deposit(refer,replayFee*DIVIDEND_INVITE/DECIMAL_PLACE);
632             lessFee -=ps.depositAuthor(replayFee*DIVIDEND_AUTH/DECIMAL_PLACE);
633         }
634         lessFee -=ps.deposit(d.ownerId,replayFee*d.toOwner/DECIMAL_PLACE);
635         
636         d.prize += lessFee;
637     }
638     
639     function sendReplayDividend(Data storage d,Player.Map storage ps,uint256 ammount) private returns(uint256) {
640         if(d.replayCount <=0) return 0;
641         uint256 oneD = ammount /  d.replayCount;
642         for(uint256 i=0;i<d.replys.size;i++){
643             PlayerReply.Data storage rp = d.replys.get(i);
644             for(uint256 j=0;j<rp.ownerIds.length;j++){
645                 ps.deposit(rp.ownerIds[j],oneD);          
646             }
647         }
648         return ammount;
649     }
650 
651     
652     
653     function getReplay(Data storage d,uint256 replayIdx) internal view returns(
654         uint256 ,//aCount;
655         uint256,// bCount;
656         uint256[],// answer;
657         uint,// replyAt;
658         uint256, // VisibleType
659         uint256, //sellPrice
660         uint256 //ansHash
661         ) {
662         return d.replys.getReplay(replayIdx);
663     }   
664     
665     function isAbleNextRound(Data storage d,uint256 nextRound) internal view returns(bool){
666         return ( CommUtils.mulRate(nextRound,100-d.nextRoundRate)> d.minReplyFee  );
667     }    
668     
669     function clearAndNextRound(Data storage d,uint256 prize) internal {
670         d.prize = prize;
671         d.replys.clear();
672         d.replayCount  = 0;
673         d.firstReplayAt = 0;
674         d.round++;
675         d.answer = CommUtils.genRandomArray(d.answer.length,d.charsLength,0); 
676     }
677     
678     function getReplyFee(Data storage d) internal view returns(uint256){
679         uint256 prizeMax = (d.prize *  d.maxReplyFeeRate ) /DECIMAL_PLACE;
680         uint256 ans = CommUtils.pwrFloat(d.minReplyFee, d.increaseRate_1000 +1000,1000,d.replys.size);
681         ans = ans > prizeMax ? prizeMax : ans;
682         uint256 count = d.replys.countByGrand();
683         if(count>0){
684             ans = CommUtils.pwrFloat(ans,GRAND_RATE,DECIMAL_PLACE,count);       
685         }
686         ans = ans < d.minReplyFee ? d.minReplyFee : ans;
687         return ans;
688     }
689     
690     function sellReply(Data storage d,Player.Map storage ps,uint256 ansHash,uint256 price,uint256 fee) internal{
691         d.replys.setSellPrice(ansHash,price);
692         saveReplyFee(d,ps,fee);
693     }
694     
695     function buyReply(Data storage d,Player.Map storage ps,uint256 replyIdx,uint256 buyFee) internal{
696         uint256 ansHash = d.replys.hashIds[replyIdx];
697         require(buyFee >= d.replys.getSellPrice(replyIdx) ,"buyFee to less");
698         require(d.replys.seller[ansHash]!=address(0),"d.replys.seller[ansHash]!=address(0)");
699         d.replys.buyer[ansHash].push(msg.sender);
700         uint256 lessFee = buyFee;
701         address refer = ps.referrerMap[msg.sender];
702         if(refer == address(0)){
703             lessFee -=ps.depositAuthor(buyFee*(DIVIDEND_AUTH+DIVIDEND_INVITE+DIVIDEND_INVITE_REFOUND)/100);            
704         }else{
705             lessFee -=ps.deposit(msg.sender,buyFee*DIVIDEND_INVITE_REFOUND/100);
706             lessFee -=ps.deposit(refer,buyFee*DIVIDEND_INVITE/100);
707             lessFee -=ps.depositAuthor(buyFee*DIVIDEND_AUTH/100);
708         }        
709         lessFee -=ps.deposit(d.ownerId,buyFee*    d.toOwner  /100);
710         ps.deposit(d.replys.seller[ansHash],lessFee);
711     }
712     
713     
714     function getGameItem(Data storage d) public view returns(
715         bytes32, //name
716         uint256, //bestACount 
717         uint256, //bestBCount
718         uint256, //answer count
719         uint256, //totalPrize
720         uint256, // reply Fee
721         uint256 //OverTimeLeft
722         ){
723              (uint256 aCount,uint256 bCount,uint256 bestCount) = d.replys.listBestScore();
724              bestCount = bestCount;
725              uint256 fee = getReplyFee(d);
726              uint256 overTimeLeft = getOverTimeLeft(d);
727              uint256 replySize = d.replys.size;
728         return(
729             d.name,
730             d.prize,
731             aCount,
732             bCount,
733             replySize,
734             fee,
735             overTimeLeft
736         );  
737         
738     }    
739     
740     function getByPrizeLeast(List storage ds) internal view returns (Data storage){
741         Data storage ans = ds.map[0];
742         uint256 _cp = ans.prize;
743         for(uint256 i=0;i<ds.size;i++){
744             if(_cp > ds.map[i].prize){
745                 ans= ds.map[i];
746                 _cp = ans.prize;
747             }
748         }
749         return ans;
750     }
751     
752     function getByPrizeLargestIdx(List storage ds) internal view returns (uint256 ){
753         uint256 ans = 0;
754         uint256 _cp = 0;
755         for(uint256 i=0;i<ds.size;i++){
756             if(_cp < ds.map[i].prize){
757                 ans= i;
758                 _cp = ds.map[i].prize;
759             }
760         }
761         return ans;
762     }    
763     
764     function getByName(List storage ds,bytes32 name) internal view returns( Data ){
765         for(uint256 i=0;i<ds.size;i++){
766             if(ds.map[i].name == name){
767                 return ds.map[i];
768             }
769         }
770     }
771     
772     function getIdxByNameElseLargest(List storage ds,bytes32 name) internal view returns( uint256 ){
773         for(uint256 i=0;i<ds.size;i++){
774             if(ds.map[i].name == name){
775                 return i;
776             }
777         }
778         return getByPrizeLargestIdx(ds);
779     } 
780     
781     function getEmpty(List storage ds) internal returns(Data storage){
782         for(uint256 i=0;i<ds.size;i++){
783             if(ds.map[i].ownerId == address(0)){
784                 return ds.map[i];
785             }
786         }
787         uint256 lastIdx= ds.size++;
788         return ds.map[lastIdx];
789     }
790     
791     
792     function award(RoomInfo.Data storage r,Player.Map storage players) internal  returns(
793             address[] memory winners,
794             uint256[] memory rewords,
795             uint256 nextRound
796         
797         )  {
798         (PlayerReply.Data storage pr) = getWinReply(r);
799         require( pr.isOwner()," pr.isSelfWinnwer()");
800         
801         nextRound = r.nextRoundRate * r.prize / 100;
802         require(nextRound<=r.prize, "nextRound<=r.prize");
803         uint256 reward = r.prize - nextRound;
804         address[] storage ownerIds = pr.ownerIds;
805         winners = new address[](ownerIds.length);
806         rewords = new uint256[](ownerIds.length);
807         uint256 sum = 0;
808         if(ownerIds.length==1){
809             sum +=players.deposit(msg.sender , reward);
810             winners[0] = msg.sender;
811             rewords[0] = reward;
812            // emit Wined(msg.sender , reward,roomIdx ,players.getNameByAddr(msg.sender) );
813         }else{
814             uint256 otherReward = reward * 30 /100;
815             reward -= otherReward;
816             otherReward = otherReward / (ownerIds.length-1);
817             bool firstGived = false;
818             for(uint256 i=0;i<ownerIds.length;i++){
819                 if(!firstGived && ownerIds[i] == msg.sender){
820                     firstGived = true;
821                     sum +=players.deposit(ownerIds[i] , reward);
822                     winners[i] = ownerIds[i];
823                     rewords[i] = reward;
824                    // emit Wined(ownerIds[i] , reward,roomIdx,players.getNameByAddr(ownerIds[i] ));
825                 }else{
826                     sum +=players.deposit(ownerIds[i] , otherReward);
827                     //emit Wined(ownerIds[i] , otherReward,roomIdx,players.getNameByAddr(ownerIds[i] ));
828                     winners[i] = ownerIds[i];
829                     rewords[i] = otherReward;
830                 }
831             }
832         }     
833         if(sum>(r.prize-nextRound)){
834             revert("sum>(r.prize-nextRound)");
835         }
836     }    
837     
838     function getOverTimeLeft(Data storage d) internal view returns(uint256){
839         if(d.replayCount == 0) return 0;
840         //uint256 time = (d.replayCount * 5 * 60 )+ (3*24*60*60) ;
841         uint256 time = (d.replayCount *d.plusAwardTime )+ d.initAwardTime ;
842         uint256 spendT = (now-d.firstReplayAt);
843         if(time<spendT) return 0;
844         return time - spendT ;
845     }
846     
847     
848     function getWinReply(Data storage d) internal view returns (PlayerReply.Data storage){
849         PlayerReply.Data storage pr = d.replys.getWin();
850         if(pr.isWined()) return pr;
851         if(d.replayCount > 0 && getOverTimeLeft(d)==0 ) return d.replys.getLastReply();
852         return pr;
853     }
854     
855     function getRoomExReplyInfo(Data storage r) internal view returns(uint256 time,uint256 count) {
856         time = r.replys.getLastReplyAt();
857         count = r.replys.countByGrand();
858     }
859     
860     function get(List storage ds,uint256 idx) internal view returns(Data storage){
861         return ds.map[idx];
862     }
863     
864     
865 }
866 
867 
868 contract BullsAndCows {
869 
870     using Player for Player.Map;
871     //using PlayerReply for PlayerReply.Data;
872     //using PlayerReply for PlayerReply.List;
873     using RoomInfo for RoomInfo.Data;
874     using RoomInfo for RoomInfo.List;
875     using CommUtils for string;
876     
877 
878 
879     uint256 public constant DIGIT_MIN = 4;    
880     uint256 public constant SELL_PRICE_RATE = 200;
881     uint256 public constant SELL_MIN_RATE = 50;
882 
883    // RoomInfo.Data[] private roomInfos ;
884     RoomInfo.List roomInfos;
885     Player.Map private players;
886     
887     //constructor() public   {    }
888     
889     // function createRoomQuick() public payable {
890     //     createRoom(4,10,"AAA",35,10,20,0.05 ether,20,20,60*60,60*60);
891     // }
892         
893     // function getBalance() public view returns (uint){
894     //     return address(this).balance;
895     // }    
896     
897     // function testNow() public  view returns(uint256[]) {
898     //     RoomInfo.Data storage r = roomInfos[0]    ; 
899     //     return r.answer;
900     // }
901     
902     // function TestreplayAnser(uint256 roomIdx) public payable   {
903     //     RoomInfo.Data storage r = roomInfos.map[roomIdx];
904     //     for(uint256 i=0;i<4;i++){
905     //         uint256[] memory aa = CommUtils.genRandomArray(r.answer.length,r.charsLength,i);
906     //         r.replayAnser(players,0.5 ether,aa);
907     //     }
908     // }    
909     
910     
911     function getInitInfo() public view returns(
912         uint256,//roomSize
913         bytes32 //refert
914         ){
915         return (
916             roomInfos.size,
917             players.getReferrerName(msg.sender)
918         );
919     }
920     
921     function getRoomIdxByNameElseLargest(string _roomName) public view returns(uint256 ){
922         return roomInfos.getIdxByNameElseLargest(_roomName.nameFilter());
923     }    
924     
925     function getRoomInfo(uint256 roomIdx) public view returns(
926         address, //ownerId
927         bytes32, //roomName,
928         uint256, // replay visible idx type
929         uint256, // prize
930         uint256, // replyFee
931         uint256, // reply combo count
932         uint256, // lastReplyAt
933         uint256, // get over time
934         uint256,  // round
935         bool // winner
936         ){
937         RoomInfo.Data storage r = roomInfos.get(roomIdx)    ;
938         (uint256 time,uint256 count) = r.getRoomExReplyInfo();
939         (PlayerReply.Data storage pr) = r.getWinReply();
940         return (
941             r.ownerId,
942             r.name,
943             r.replys.size,
944             r.prize,
945             r.getReplyFee(),
946             count,
947             time,
948             r.getOverTimeLeft(),
949             r.round,
950             PlayerReply.isOwner(pr)
951         );
952     }
953     
954     function getRoom(uint256 roomIdx) public view returns(
955         uint256, //digits,
956         uint256, //templateLen,
957         uint256, //toAnswerRate,
958         uint256, //toOwner,
959         uint256, //nextRoundRate,
960         uint256, //minReplyFee,
961         uint256, //maxReplyFeeRate           
962         uint256  //IdxIncreaseRate
963         ){
964         RoomInfo.Data storage r = roomInfos.map[roomIdx]    ;
965         return(
966         r.answer.length,
967         r.charsLength,
968         r.toAnswerRate ,  //r.toAnswerRate 
969         r.toOwner , //r.toOwner,
970         r.nextRoundRate ,  //r.nextRoundRate,
971         r.minReplyFee, 
972         r.maxReplyFeeRate,     //r.maxReplyFeeRate  
973         r.increaseRate_1000     //IdxIncreaseRate
974         );
975         
976     }
977     
978     function getGameItem(uint256 idx) public view returns(
979         bytes32 ,// name
980         uint256, //totalPrize
981         uint256, //bestACount 
982         uint256 , //bestBCount
983         uint256 , //answer count
984         uint256, //replyFee
985         uint256 //OverTimeLeft
986         ){
987         return roomInfos.map[idx].getGameItem();
988     }
989     
990     function getReplyFee(uint256 roomIdx) public view returns(uint256){
991         return roomInfos.map[roomIdx].getReplyFee();
992     }
993     
994     function getReplay(uint256 roomIdx,uint256 replayIdx) public view returns(
995         uint256 ,//aCount;
996         uint256,// bCount;
997         uint256[],// answer;
998         uint,// replyAt;
999         uint256, // VisibleType
1000         uint256 ,//sellPrice
1001         uint256 //ansHash
1002         ) {
1003         RoomInfo.Data storage r = roomInfos.map[roomIdx];
1004         return r.getReplay(replayIdx);
1005     }
1006     
1007     function replayAnserWithReferrer(uint256 roomIdx,uint256[] tryA,string referrer)public payable {
1008         players.applyReferrer(referrer);
1009         replayAnser(roomIdx,tryA);
1010     }
1011 
1012     function replayAnser(uint256 roomIdx,uint256[] tryA) public payable   {
1013         RoomInfo.Data storage r = roomInfos.map[roomIdx];
1014         (uint256 a, uint256 b)= r.replayAnser(players,players.withdrawalFee(r.getReplyFee()),tryA);
1015         emit ReplayAnserResult (a,b,roomIdx);
1016     }
1017     
1018     
1019     function sellReply(uint256 roomIdx,uint256 ansHash,uint256 price) public payable {
1020         RoomInfo.Data storage r = roomInfos.map[roomIdx];
1021         require(price >= r.prize * SELL_MIN_RATE / 100,"price too low");
1022         r.sellReply(players,ansHash,price,players.withdrawalFee(price * SELL_PRICE_RATE /100));
1023     }
1024     
1025     function buyReply(uint256 roomIdx,uint256 replyIdx) public payable{
1026         roomInfos.map[roomIdx].buyReply(players,replyIdx,msg.value);
1027     }
1028     
1029     
1030 
1031     function isEmptyName(string _n) public view returns(bool){
1032         return players.isEmptyName(_n.nameFilter());
1033     }
1034     
1035     function award(uint256 roomIdx) public  {
1036         RoomInfo.Data storage r = roomInfos.map[roomIdx];
1037         (
1038             address[] memory winners,
1039             uint256[] memory rewords,
1040             uint256 nextRound
1041         )=r.award(players);
1042         emit Wined(winners , rewords,roomIdx);
1043         //(nextRound >= CREATE_INIT_PRIZE && SafeMath.mulRate(nextRound,maxReplyFeeRate) > r.minReplyFee  ) || roomInfos.length == 1
1044         if(r.isAbleNextRound(nextRound)){
1045             r.clearAndNextRound(nextRound);   
1046         }else if(roomInfos.size>1){
1047             for(uint256 i = roomIdx; i<roomInfos.size-1; i++){
1048                 roomInfos.map[i] = roomInfos.map[i+1];
1049             }
1050             delete roomInfos.map[roomInfos.size-1];
1051             roomInfos.size--;
1052             roomInfos.getByPrizeLeast().prize += nextRound;
1053         }else{
1054             delete roomInfos.map[roomIdx];
1055             players.depositAuthor(nextRound);
1056             roomInfos.size = 0;
1057         }
1058     }
1059     
1060 
1061     function createRoom(
1062         uint256 digits,
1063         uint256 templateLen,
1064         string roomName,
1065         uint256 toAnswerRate,
1066         uint256 toOwner,
1067         uint256 nextRoundRate,
1068         uint256 minReplyFee,
1069         uint256 maxReplyFeeRate,
1070         uint256 increaseRate,
1071         uint256 initAwardTime,
1072         uint256 plusAwardTime
1073         )  public payable{
1074 
1075         bytes32 name = roomName.nameFilter();
1076         require(roomInfos.getByName(name).ownerId == address(0));
1077         RoomInfo.Data storage r = roomInfos.getEmpty();
1078         r.init(
1079             digits,
1080             templateLen,
1081             name,
1082             toAnswerRate,
1083             toOwner,
1084             nextRoundRate,
1085             minReplyFee,
1086             maxReplyFeeRate,
1087             increaseRate,
1088             initAwardTime,
1089             plusAwardTime
1090         );
1091     }
1092     
1093     function getPlayerWallet() public view returns(  uint256   ){
1094         return players.getAmmount(msg.sender);
1095     }
1096     
1097     function withdrawal() public payable {
1098         uint256 sum=players.withdrawalAll(msg.sender);
1099         msg.sender.transfer(sum);
1100     }
1101     
1102     function registerName(string  name) public payable {
1103         require(msg.value >= 0.1 ether);
1104         require(players.getName()=="");
1105         players.registerName(name.nameFilter());
1106     }
1107     
1108     function getPlayerName() public view returns(bytes32){
1109         return players.getName();
1110     }
1111     
1112     event ReplayAnserResult(
1113         uint256 aCount,
1114         uint256 bCount,
1115         uint256 roomIdx
1116     );
1117     
1118     event Wined(
1119         address[]  winners,
1120         uint256[]  rewords,
1121         uint256 roomIdx
1122     );    
1123     
1124 }