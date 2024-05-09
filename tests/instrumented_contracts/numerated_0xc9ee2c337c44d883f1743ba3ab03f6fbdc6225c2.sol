1 pragma solidity^0.4.24;
2 
3 /*interface DiviesInterface {
4     function deposit() external payable;
5 }*/
6 
7 contract Cryptorank{
8     using SafeMath for *;
9     using NameFilter for string;
10 
11     struct Round
12     {
13        bool active;
14        address lastvoter;
15        uint256  jackpot; //奖池 25%
16        uint256 start; 
17        uint256 end;
18        uint256 tickets;//总票数
19        uint256 pot;//空投，1%
20        
21     }
22     
23     struct Coin
24     {
25         string symbol;
26         string name;
27         uint256 votes;
28     }
29     
30     address[] public players;
31     //Coin[] public coins;
32     Coin[] public coinSorting;//排序数组
33     
34     mapping(uint256 => Round) public rounds;
35     
36     //DiviesInterface constant private Divies = DiviesInterface(0x4a771aa796ba9fd4c5ed3d6e7b6e98270d5de880);
37    
38     
39     address  private owner;
40     address  public manager;
41     uint256  public roundid = 0;//局数
42     uint256  constant private initvotetime = 1 hours;
43 	uint256  constant private voteinterval = 90 seconds;
44 	uint256  constant private maxvotetime = 24 hours;
45 	
46 	uint256 public addcoinfee = 1 ether;
47     uint256 private SortingCoinstime;
48 	
49 	uint256  public raiseethamount = 0;//众筹100个ether
50     uint8 public addcoinslimit = 5;// 用户一次性最多添加5个币种，待管理员调整上币价格
51 	uint256 public tonextround = 0;//留到下一轮的资金
52 	
53 	//uint8 constant public  raiseicoprice = 100;
54 	//uint8 private invitation = 10;//邀请分比,10%
55 	//uint8 private promote = 5;//推广.5%
56 	uint256 private fund = 0;//基金,8%
57 	uint256 public nextRoundCoolingTime = 10 minutes;//下局开始的冷却时间
58 	
59 	uint256 public ticketPrice = 0.01 ether;//票价
60 	
61 
62     mapping(string=>bool) have;
63 
64     mapping(string=>uint)  cvotes;
65     
66     mapping(uint256 => uint256) public awardedReward;//已发放的奖励
67     mapping(uint256 => uint256) public ticketHolderReward;//持票者奖励
68     mapping(address => uint256) public selfharvest;//占比提成 
69     mapping(address => uint256) public selfvoteamount;//个人投资总金额
70     mapping(address => uint256) public selfvotes;//个人票数
71     mapping(address => uint8) public selfOdds;//中奖概率
72     mapping(address => uint256) public selfpotprofit;//空投奖励
73     mapping(address => uint256) public selfcommission;//邀请抽成
74     mapping(address => string) public playername;
75     mapping(address => address) public playerreferees;
76     mapping(bytes32 => uint256) public verifyName;//验证名字是否重复
77     mapping(address => bool) public pState; //状态 表示地址是否已经注册为会员
78     mapping(address => uint256) public raisemax;//众筹个人限制在1ether内
79     
80     
81      modifier isactivity(uint256 rid){
82          
83          require(rounds[rid].active == true);
84          _;
85      }
86      
87      modifier onlyowner()
88     {
89         require(msg.sender == owner);
90         _;
91     }
92     
93      modifier isRepeat(string _name)
94     {
95         require(have[_name]==false);
96        _;
97     }
98     
99      modifier isHave (string _name)
100     {
101         require(have[_name]==true);
102         _;
103     }
104     
105     //排序刷新事件
106     event Sortime(address indexed adr,uint256 indexed time);
107     event AddCoin(uint _id,string _name,string _symbol);
108     
109     constructor()  public {
110         
111         owner = msg.sender;
112         
113         startRound();
114       
115     }
116     
117     //货币函数
118      //添加币
119     function addcoin(string _name,string _symbol) 
120        public
121        payable
122        isRepeat(_name)
123     {
124         require(addcoinslimit > 1);
125         
126         if(msg.sender != owner){
127             require(msg.value >= addcoinfee);
128             
129         }
130         
131         uint id = coinSorting.push(Coin(_symbol,_name, 0)) - 1;
132 
133         cvotes[_name]=id;
134 
135         emit AddCoin(id,_name,_symbol);
136 
137         have[_name]=true;
138         
139         addcoinslimit --;
140         
141         rounds[roundid].jackpot =   rounds[roundid].jackpot.add(msg.value);
142     }
143     
144     
145     function tovote(string _name,uint256 _votes,uint256 reward) private 
146        isHave(_name)
147        {
148         
149         coinSorting[cvotes[_name]].votes = coinSorting[cvotes[_name]].votes.add(_votes) ;
150         
151         for(uint256 i = 0;i < players.length;i++){
152             
153             address player = players[i];
154             
155             uint256 backreward = reward.mul(selfvotes[player]).div(rounds[roundid].tickets);
156             
157             selfharvest[player] = selfharvest[player].add(backreward);
158         }
159         
160         
161     }
162     
163     //由大到小排序
164     function SortingCoins() public {
165         
166        /* delete coinSorting;
167         coinSorting.length = 0;
168         
169         for(uint256 i = 0;i<coins.length;i++){
170           
171             coinSorting.push(Coin(coins[i].symbol,coins[i].name,coins[i].votes));
172          
173         }*/
174         
175         for(uint256 i = 0;i< coinSorting.length;i++){
176             
177             for(uint256 j = i + 1;j < coinSorting.length;j++){
178               
179                 if(coinSorting[i].votes < coinSorting[j].votes){
180                     
181                     cvotes[coinSorting[i].name] =  j;
182                     cvotes[coinSorting[j].name] =  i;
183                     
184                     Coin memory temp = Coin(coinSorting[i].symbol,coinSorting[i].name,coinSorting[i].votes);
185                     coinSorting[i] = Coin(coinSorting[j].symbol,coinSorting[j].name,coinSorting[j].votes);
186                     coinSorting[j] = Coin(temp.symbol,temp.name,temp.votes);
187                     
188                     
189                 }
190             }
191         }
192      
193      }
194       
195   
196     //设置上币价
197     function setcoinfee(uint256 _fee)  external onlyowner{
198         
199         addcoinfee = _fee;
200         
201         addcoinslimit = 5;
202     }
203     
204     function getcoinSortinglength() public view returns(uint )
205     {
206         return coinSorting.length;
207     }
208 
209     function getcvotesid(string _name)public view returns (uint)
210     {
211         return cvotes[_name];
212     }
213     function getcoinsvotes(string _name) public view returns(uint)
214     {
215         return coinSorting[cvotes[_name]].votes;
216     }
217 
218     
219 
220     //众筹
221     function raisevote()
222         payable
223         public
224         isactivity(roundid){
225         
226         require(raiseethamount < 100 ether);
227         
228         require(raisemax[msg.sender].add(msg.value) <= 1 ether);
229         
230         uint256 raiseeth;
231         
232         if(raiseethamount.add(msg.value) > 100 ether){
233             
234             raiseeth = 100 - raiseethamount;
235             
236             uint256 backraise = raiseethamount.add(msg.value) - 100 ether;
237         
238             selfpotprofit[msg.sender] = selfpotprofit[msg.sender].add(backraise);
239             
240         }else{
241             
242             raiseeth = msg.value;
243         }
244       
245         raiseethamount = raiseethamount.add(raiseeth);
246         
247         raisemax[msg.sender] = raisemax[msg.sender].add(raiseeth);
248         
249         uint256 ticketamount = raiseeth.div(0.01 ether);
250         
251         //Divies.deposit.value(msg.value.mul(5).div(100))();
252         
253         uint256 reward = msg.value.mul(51).div(100);
254         
255         for(uint256 i = 0;i < players.length;i++){
256             
257             address player = players[i];
258             
259             uint256 backreward = reward.mul(selfvotes[player]).div(rounds[roundid].tickets);
260             
261             selfharvest[player] = selfharvest[player].add(backreward);
262         }
263         
264         allot(ticketamount);
265     }
266     
267     
268 	///////////////////////////////////////////////
269 	// OWNER FUNCTIONS
270 	///////////////////////////////////////////////
271     function transferOwnership(address newOwner) public {
272 		require(msg.sender == owner);
273 
274 		owner = newOwner;
275 	}
276 	
277 	//设置manager地址，用以取款基金和注册费
278 	function setManager(address _manager) public  onlyowner{
279 	   
280 	   manager = _manager;
281 	}
282     
283     
284     
285     //开始下一轮
286     function startRound() private{
287        
288        roundid++;
289        
290        rounds[roundid].active = true;
291        rounds[roundid].lastvoter = 0x0;
292        rounds[roundid].jackpot = tonextround;
293        rounds[roundid].start = now;
294        rounds[roundid].end = now + initvotetime;
295        rounds[roundid].tickets = 0;
296        rounds[roundid].pot = 0;
297        
298        ticketPrice = 0.01 ether;
299        
300   
301     }
302     
303     //计算票价
304     function calculatVotePrice() 
305          public
306          view
307          returns(uint256){
308         
309         uint256 playersnum = players.length;
310         
311         if(playersnum <= 30)
312            return  ticketPrice.mul(112).div(100);
313         if(playersnum>30 && playersnum <= 100)
314            return  ticketPrice.mul(103).div(100);
315         if(playersnum > 100)
316            return ticketPrice.mul(101).div(100);
317     }
318     
319     //判断是非中奖
320     function airdrop()
321         private 
322         view 
323         returns(bool)
324     {
325         uint256 seed = uint256(keccak256(abi.encodePacked(
326             
327             (block.timestamp).add
328             (block.difficulty).add
329             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
330             (block.gaslimit).add
331             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
332             (block.number)
333             
334         )));
335         if((seed - ((seed / 100) * 100)) < selfOdds[msg.sender])
336             return(true);
337         else
338             return(false);
339     }
340     
341     //计算空投奖励
342     function airdrppReward()
343         private
344         returns(string){
345         
346         if(airdrop() == false){
347             return "非常遗憾！没有空投！";
348         }
349         else{
350             if(selfvoteamount[msg.sender] <= 1 ether && rounds[roundid].pot >= 0.1 ether){
351               
352               selfpotprofit[msg.sender] =  selfpotprofit[msg.sender].add(0.1 ether);        }
353               
354               rounds[roundid].pot = rounds[roundid].pot.sub(0.1 ether);
355               
356               return "恭喜获得空投 0.1 ether";
357              }
358             if(1 ether < selfvoteamount[msg.sender] && selfvoteamount[msg.sender] <= 5 ether && rounds[roundid].pot >=0.5 ether){
359               
360               selfpotprofit[msg.sender] = selfpotprofit[msg.sender].add(0.5 ether);
361               
362               rounds[roundid].pot = rounds[roundid].pot.sub(0.5 ether);
363               
364               return "恭喜获得空投 0.5 ether";
365             }
366             if(selfvoteamount[msg.sender] > 5 ether && rounds[roundid].pot >= 1 ether){
367               
368               selfpotprofit[msg.sender] = selfpotprofit[msg.sender].add(1 ether);
369               
370               rounds[roundid].pot = rounds[roundid].pot.sub(1 ether);
371               
372               return "恭喜获得空投 1 ether";
373             }
374     }
375     
376     //更新时间
377     function updateTimer(uint256 _votes)
378         private
379     {
380         // grab time
381         uint256 _now = now;
382         
383         // calculate time based on number of keys bought
384         uint256 _newTime;
385         if (_now > rounds[roundid].end && rounds[roundid].lastvoter == address(0))
386             _newTime = (_votes.mul(voteinterval)).add(_now);
387         else
388             _newTime = (_votes.mul(voteinterval)).add(rounds[roundid].end);
389         
390         // compare to max and set new end time
391         if (_newTime < (maxvotetime).add(_now))
392             rounds[roundid].end = _newTime;
393         else
394             rounds[roundid].end = maxvotetime.add(_now);
395     }
396     
397     //投票
398     function voting (string _name) 
399        payable 
400        public 
401        isactivity(roundid)
402        returns(string)
403     {
404 
405         //require(raiseethamount == 100);
406         
407         uint256 currentticketPrice = ticketPrice;
408        
409         require(msg.value >= currentticketPrice);
410         
411         string memory ifgetpot = airdrppReward();
412         
413         require(now > (rounds[roundid].start + nextRoundCoolingTime) &&(now <= rounds[roundid].end ||rounds[roundid].lastvoter == address(0) ));
414         
415           
416           selfvoteamount[msg.sender] = selfvoteamount[msg.sender].add(msg.value);
417           
418           uint256 votes = msg.value.div(currentticketPrice);
419           
420           //Divies.deposit.value(msg.value.mul(5).div(100))();
421           
422           uint256 reward = msg.value.mul(51).div(100);
423           
424           uint256 _now = now;
425         if(_now - SortingCoinstime >2 hours){
426             SortingCoins();
427             SortingCoinstime = _now;
428             emit Sortime(msg.sender,_now);
429         }
430           
431           tovote(_name,votes,reward);
432          
433           allot(votes);
434          
435           calculateselfOdd();
436           
437           ticketPrice = calculatVotePrice();
438         
439         
440       
441        return ifgetpot;
442    }
443     
444     //计算空投中奖概率
445     function calculateselfOdd() private {
446         
447          if(selfvoteamount[msg.sender] <= 1 ether)
448               selfOdds[msg.sender] = 25;
449             if(1 ether < selfvoteamount[msg.sender] &&selfvoteamount[msg.sender] <= 10 ether)
450                selfOdds[msg.sender] = 50;
451             if(selfvoteamount[msg.sender] > 10 ether)
452                selfOdds[msg.sender] = 75;
453         
454         
455     }
456     
457     //分配资金
458     function allot(uint256 votes) private  isactivity(roundid){
459         
460           if(playerreferees[msg.sender] != address(0)){
461                
462               selfcommission[playerreferees[msg.sender]] = selfcommission[playerreferees[msg.sender]].add(msg.value.mul(10).div(100));
463           }else{
464              
465              rounds[roundid].jackpot = rounds[roundid].jackpot.add(msg.value.mul(10).div(100)); 
466           }
467           
468            if(selectplayer() == false){
469               players.push(msg.sender);
470           }
471           
472           fund = fund.add(msg.value.mul(13).div(100));
473           
474           ticketHolderReward[roundid] = ticketHolderReward[roundid].add(msg.value.mul(51).div(100));
475           
476           rounds[roundid].jackpot = rounds[roundid].jackpot.add(msg.value.mul(25).div(100));
477           
478           rounds[roundid].pot =  rounds[roundid].pot.add(msg.value.mul(1).div(100));
479           
480           rounds[roundid].lastvoter = msg.sender;
481           
482           rounds[roundid].tickets = rounds[roundid].tickets.add(votes);
483           
484           selfvotes[msg.sender] = selfvotes[msg.sender].add(votes);
485         
486           updateTimer(votes);
487           
488     }
489     
490     
491     
492     //发奖
493     function endround() public isactivity(roundid) {
494         
495         require(now > rounds[roundid].end && rounds[roundid].lastvoter != address(0));
496 
497         uint256 reward = rounds[roundid].jackpot;
498         
499         for(uint i = 0 ;i< players.length;i++){
500             
501             address player = players[i];
502             
503             uint256 selfbalance = selfcommission[msg.sender] + selfharvest[msg.sender] + selfpotprofit[msg.sender];
504             
505             uint256 endreward = reward.mul(42).div(100).mul(selfvotes[player]).div(rounds[roundid].tickets);
506             
507             selfcommission[player] = 0;
508          
509             selfharvest[player] = 0;
510          
511             selfpotprofit[player] = 0;
512             
513             selfvoteamount[player] = 0;
514             
515             selfvotes[player] = 0;
516             
517             player.transfer(endreward.add(selfbalance));
518         }
519         
520     
521         rounds[roundid].lastvoter.transfer(reward.mul(48).div(100));
522         
523         tonextround = reward.mul(10).div(100);
524         
525         uint256 remainingpot =  rounds[roundid].pot;
526         
527         tonextround = tonextround.add(remainingpot);
528         
529         rounds[roundid].active = false;
530         
531         delete players;
532         players.length = 0;
533         
534         startRound();
535 
536      }
537      
538      //注册
539      function registerNameXNAME(string _nameString,address _inviter) 
540         public
541         payable {
542         // make sure name fees paid
543         require (msg.value >= 0.01 ether, "umm.....  you have to pay the name fee");
544 
545         bytes32 _name = NameFilter.nameFilter(_nameString);
546 
547         require(verifyName[_name]!=1 ,"sorry that names already taken");
548         
549         bool state =   validation_inviter(_inviter);
550         require(state,"注册失败");
551         if(!pState[msg.sender]){
552             
553             verifyName[_name] = 1;
554             playername[msg.sender] = _nameString;
555             playerreferees[msg.sender] = _inviter;
556             pState[msg.sender] = true;
557         }
558 
559         manager.transfer(msg.value);
560     }
561     
562      function  validation_inviter (address y_inviter) public view returns (bool){
563         if(y_inviter== 0x0000000000000000000000000000000000000000){
564             return true;
565         }
566         else if(pState[y_inviter]){
567             return true;
568         }
569         else {
570 
571             return false;
572         }
573 
574     }
575      
576      
577      
578      //取款
579      function withdraw() public{
580          
581          uint256 reward = selfcommission[msg.sender] + selfharvest[msg.sender] + selfpotprofit[msg.sender];
582          
583          uint256 subselfharvest = selfharvest[msg.sender];
584          
585          selfcommission[msg.sender] = 0;
586          
587          selfharvest[msg.sender] = 0;
588          
589          selfpotprofit[msg.sender] = 0;
590          
591          ticketHolderReward[roundid] = ticketHolderReward[roundid].sub(subselfharvest);
592          
593          awardedReward[roundid] = awardedReward[roundid].add(reward);
594          
595          msg.sender.transfer(reward);
596      }
597      
598      //manager取款
599      function withdrawbymanager() public{
600          
601          require(msg.sender == manager);
602          
603          uint256 fundvalue = fund;
604          
605          fund = 0;
606          
607          manager.transfer(fundvalue);
608      }
609      
610      //查询空投奖励
611      function getpotReward() public view returns(uint256){
612          
613          return selfpotprofit[msg.sender];
614      }
615      
616      //查询分红
617      function getBonus() public view returns(uint256){
618          
619          return selfvotes[msg.sender] / rounds[roundid].tickets * rounds[roundid].jackpot;
620      }
621      
622      //查询是否投票人已经在数组里
623      function selectplayer() public view returns(bool){
624          
625          for(uint i = 0;i< players.length ;i++){
626              
627              if(players[i] == msg.sender)
628                return true;
629          
630              }
631             
632              return false;
633          
634      }
635     
636     
637     //返回开奖时间
638     function getroundendtime() public view returns(uint256){
639         
640         if(rounds[roundid].end >= now){
641             
642             return  rounds[roundid].end - now;
643         }
644         
645         return 0;
646     }
647     
648     
649     function getamountvotes() public view returns(uint) {
650         
651         return rounds[roundid].tickets;
652     }
653     
654      function getjackpot() public view returns(uint)
655    {
656        return rounds[roundid].jackpot;
657    }
658 
659     function () payable public {
660         
661         selfpotprofit[msg.sender] = selfpotprofit[msg.sender].add(msg.value);
662     }
663 }
664 
665 
666 library SafeMath {
667 
668   /**
669   * @dev Multiplies two numbers, throws on overflow.
670   */
671   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
672     if (a == 0) {
673       return 0;
674     }
675     uint256 c = a * b;
676     assert(c / a == b);
677     return c;
678   }
679 
680   /**
681   * @dev Integer division of two numbers, truncating the quotient.
682   */
683   function div(uint256 a, uint256 b) internal pure returns (uint256) {
684     // assert(b > 0); // Solidity automatically throws when dividing by 0
685     uint256 c = a / b;
686     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
687     return c;
688   }
689 
690   /**
691   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
692   */
693   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
694     assert(b <= a);
695     return a - b;
696   }
697 
698   /**
699   * @dev Adds two numbers, throws on overflow.
700   */
701   function add(uint256 a, uint256 b) internal pure returns (uint256) {
702     uint256 c = a + b;
703     assert(c >= a);
704     return c;
705   }
706 }
707 
708 
709 library NameFilter {
710 
711     /**
712      * @dev filters name strings
713      * -converts uppercase to lower case.
714      * -makes sure it does not start/end with a space
715      * -makes sure it does not contain multiple spaces in a row
716      * -cannot be only numbers
717      * -cannot start with 0x
718      * -restricts characters to A-Z, a-z, 0-9, and space.
719      * @return reprocessed string in bytes32 format
720      */
721     function nameFilter(string _input) //名字过滤器
722         internal
723         pure
724         returns(bytes32)
725     {
726         bytes memory _temp = bytes(_input);
727         uint256 _length = _temp.length;
728 
729         //sorry limited to 32 characters
730         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
731         // make sure it doesnt start with or end with space
732         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
733         // make sure first two characters are not 0x
734         if (_temp[0] == 0x30)
735         {
736             require(_temp[1] != 0x78, "string cannot start with 0x");
737             require(_temp[1] != 0x58, "string cannot start with 0X");
738         }
739 
740         // create a bool to track if we have a non number character
741         bool _hasNonNumber;
742 
743         // convert & check
744         for (uint256 i = 0; i < _length; i++)
745         {
746             // if its uppercase A-Z
747             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
748             {
749                 // convert to lower case a-z
750                 _temp[i] = byte(uint(_temp[i]) + 32);
751 
752                 // we have a non number
753                 if (_hasNonNumber == false)
754                     _hasNonNumber = true;
755             } else {
756                 require
757                 (
758                     // require character is a space
759                     _temp[i] == 0x20 ||
760                     // OR lowercase a-z
761                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
762                     // or 0-9
763                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
764                     "string contains invalid characters"
765                 );
766                 // make sure theres not 2x spaces in a row
767                 if (_temp[i] == 0x20)
768                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
769 
770                 // see if we have a character other than a number
771                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
772                     _hasNonNumber = true;
773             }
774         }
775 
776         require(_hasNonNumber == true, "string cannot be only numbers");
777 
778         bytes32 _ret;
779         assembly {
780             _ret := mload(add(_temp, 32))
781         }
782         return (_ret);
783     }
784 }