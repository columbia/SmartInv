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
60   function getPlayRate(uint playId,uint level) internal pure returns (uint){
61       uint result = 0;
62       if(playId == 1 || playId == 3){
63         result = 19;//10bei
64       }else if(playId == 2){
65         result = 9;
66       }
67       return result;
68     }
69 
70     function doBet(uint[] memory playid,uint[] memory betMoney,uint[] memory betContent,uint mutiply) public payable returns (bytes32 queryId) {
71       require(onoff==1);
72       require(playid.length > 0);
73       require(mutiply > 0);
74       require(msg.value >= minBet);
75 
76       checkBet(playid,betMoney,betContent,mutiply,msg.value);
77 
78       /* uint total = 0; */
79       bytes32 queryId;
80       queryId = keccak256(abi.encodePacked(blockhash(block.number-1),now,randonce));
81       //  uint oraGasLimit = oraclizeGasLimit;
82       //  if(playid.length > 1 && playid.length <= 3){
83       //      oraGasLimit = 600000;
84       //  }else{
85       //      oraGasLimit = 1000000;
86       //  }
87         emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..",queryId);
88       //  queryId = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data", '\n{"jsonrpc":"2.0","method":"generateIntegers","params":{"apiKey":"8817de90-6e86-4d0d-87ec-3fd9b437f711","n":4,"min":1,"max":52,"replacement":false,"base":10},"id":1}',oraGasLimit);
89       /* } */
90 
91        uint[7] memory tmp ;
92        uint totalspand = 0;
93       for(uint i=0;i<playid.length;i++){
94         orderId++;
95         tmp[0] =orderId;
96         tmp[1] =playid[i];
97         tmp[2] =betContent[i];
98         tmp[3] =betMoney[i]*mutiply;
99         totalspand +=betMoney[i]*mutiply;
100         tmp[4] =now;
101         tmp[5] =0;
102         tmp[6] =0;
103         betList[queryId][i] =tmp;
104       }
105       require(msg.value >= totalspand);
106 
107       lableTime[queryId] = now;
108       lableCount[queryId] = playid.length;
109       lableUser[queryId] = msg.sender;
110       uint[4] memory codes = [uint(0),0,0,0];
111       openNumberList[queryId] = codes;
112       openNumberStr[queryId] ="0,0,0,0";
113       lableStatus[queryId] = 0;
114 
115       uint index=playerLableList[msg.sender].length++;
116       playerLableList[msg.sender][index]=queryId;//index:id
117       emit LogBet(queryId);
118       opencode(queryId);
119       return queryId;
120     }
121 
122     function opencode(bytes32 queryId) private {
123       if (lableCount[queryId] < 1) revert();
124       uint[4] memory codes = [uint(0),0,0,0];//开奖号码
125 
126       bytes32 code0hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
127       randonce  = randonce + uint(code0hash)%1000;
128       //uint code0int = uint(code0hash) % 52 + 1;
129       codes[0] = uint(code0hash) % 52 + 1;
130       string memory code0 =uint2str(uint(code0hash) % 52 + 1);
131 
132       bytes32 code1hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
133       randonce  = randonce + uint(code1hash)%1000;
134       //uint code1int = uint(code1hash) % 52 + 1;
135       codes[1] = uint(code1hash) % 52 + 1;
136       string memory code1=uint2str(uint(code1hash) % 52 + 1);
137 
138       bytes32 code2hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
139       randonce  = randonce + uint(code2hash)%1000;
140       //uint code2int = uint(code2hash) % 52 + 1;
141       codes[2] = uint(code2hash) % 52 + 1;
142       string memory code2=uint2str(uint(code2hash) % 52 + 1);
143 
144       bytes32 code3hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,msg.sender,randonce));
145       randonce  = randonce + uint(code3hash)%1000;
146       //uint code3int = uint(code3hash) % 52 + 1;
147       codes[3] = uint(code3hash) % 52 + 1;
148       string memory code3=uint2str(uint(code3hash) % 52 + 1);
149 
150       //string memory code0 =uint2str(code0int);
151       //string memory code1=uint2str(code1int);
152       //string memory code2=uint2str(code2int);
153       //string memory code3=uint2str(code3int);
154       //codes[0] = code0int;
155       //codes[1] = code1int;
156       //codes[2] = code2int;
157       //codes[3] = code3int;
158       openNumberList[queryId] = codes;
159       string memory codenum = "";
160       codenum = strConcat(code0,",",code1,",",code2);
161       openNumberStr[queryId] = strConcat(codenum,",",code3);
162       //结算，派奖
163       doCheckBounds(queryId);
164     }
165 
166     function checkBet(uint[] memory playid,uint[] memory betMoney,uint[] memory betContent,uint mutiply,uint betTotal) internal{
167         uint totalMoney = 0;
168       uint totalWin1 = 0;
169       uint totalWin2 = 0;
170       uint rate;
171       uint i;
172       for(i=0;i<playid.length;i++){
173         if(playid[i] >=1 && playid[i]<= 3){
174           totalMoney += betMoney[i] * mutiply;
175         }else{
176           revert();
177         }
178         if(playid[i] ==1 || playid[i] ==3){//龙虎
179           rate = getPlayRate(playid[i],0);
180           totalWin1+=betMoney[i] * mutiply *rate/10;
181           totalWin2+=betMoney[i] * mutiply *rate/10;
182         }else if(playid[i] ==2){//和
183           rate = getPlayRate(playid[i],0);
184           totalWin2+=betMoney[i] * mutiply *rate;
185         }
186       }
187       uint maxWin=totalWin1;
188       if(totalWin2 > maxWin){
189         maxWin=totalWin2;
190       }
191       require(betTotal >= totalMoney);
192 
193       require(maxWin < maxProfit);
194     }
195     /*
196     function __callback(bytes32 queryId, string memory result) public onlyOraclize {
197         if (lableCount[queryId] < 1) revert();
198       if (msg.sender != oraclize_cbAddress()) revert();
199         emit LogNewRandomNumber(result,queryId);
200         bytes memory tmp = bytes(result);
201         uint[4] memory codes = [uint(0),0,0,0];
202         uint [] memory codess ;
203         codess = splitStr(result,",");
204         uint k = 0;
205         for(uint i = 0;i<codess.length;i++){
206             if(k < codes.length){
207                      codes[k] = codess[i];
208                      k++;
209             }
210         }
211 
212         string memory code0=uint2str(codes[0]);
213         string memory code1=uint2str(codes[1]);
214         string memory code2=uint2str(codes[2]);
215         string memory code3=uint2str(codes[3]);
216         openNumberList[queryId] = codes;
217         string memory codenum = "";
218         codenum = strConcat(code0,",",code1,",",code2);
219         openNumberStr[queryId] = strConcat(codenum,",",code3);
220         doCheckBounds(queryId);
221     }
222     */
223     function doCancel(bytes32 queryId) internal {
224       uint sta = lableStatus[queryId];
225       require(sta == 0);
226       uint[4] memory codes = openNumberList[queryId];
227       require(codes[0] == 0 || codes[1] == 0 ||codes[2] == 0 ||codes[3] == 0);
228 
229       uint totalBet = 0;
230       uint len = lableCount[queryId];
231 
232       address payable to = lableUser[queryId];
233       for(uint aa = 0 ; aa<len; aa++){
234         //未结算
235         if(betList[queryId][aa][5] == 0){
236           totalBet+=betList[queryId][aa][3];
237         }
238       }
239 
240       if(totalBet > 0){
241         to.transfer(totalBet);
242       }
243       contractBalance=address(this).balance;
244       maxProfit=(address(this).balance * maxmoneypercent)/100;
245       lableStatus[queryId] = 1;
246     }
247 
248     function doSendBounds(bytes32 queryId) public payable {
249       uint sta = lableStatus[queryId];
250       require(sta == 2);
251 
252       uint totalWin = 0;
253       uint len = lableCount[queryId];
254 
255       address payable to = lableUser[queryId];
256       for(uint aa = 0 ; aa<len; aa++){
257         //中奖
258         if(betList[queryId][aa][5] == 2){
259           totalWin+=betList[queryId][aa][6];
260         }
261       }
262 
263       if(totalWin > 0){
264           to.transfer(totalWin);//转账
265       }
266       lableStatus[queryId] = 3;
267       contractBalance=address(this).balance;
268       maxProfit=(address(this).balance * maxmoneypercent)/100;
269     }
270 
271     //中奖判断
272     function checkWinMoney(uint[7] storage betinfo,uint[4] memory codes) internal {
273       uint rates;
274       uint code0 = codes[0]%13==0?13:codes[0]%13;
275       uint code1 = codes[1]%13==0?13:codes[1]%13;
276       uint code2 = codes[2]%13==0?13:codes[2]%13;
277       uint code3 = codes[3]%13==0?13:codes[3]%13;
278       uint  onecount = code0 + code2;
279       uint  twocount = code1 + code3;
280       onecount = onecount%10;
281       twocount = twocount%10;
282       if(betinfo[1] ==1){//long
283           if(onecount > twocount){
284               betinfo[5]=2;
285               rates = getPlayRate(betinfo[1],0);
286               betinfo[6]=betinfo[3]*rates/10;
287           }else{
288              // if(onecount == twocount){//和
289              //     betinfo[5]=2;
290              //     rates = 1;
291              //     betinfo[6]=betinfo[3]*rates;
292              // }else{
293                   betinfo[5]=1;
294              // }
295           }
296       }else if(betinfo[1] == 2){//和
297           if(onecount == twocount){
298             betinfo[5]=2;
299             rates = getPlayRate(betinfo[1],0);
300             betinfo[6]=betinfo[3]*rates;
301           }else{
302             betinfo[5]=1;
303           }
304 
305         }else if(betinfo[1] == 3){//虎
306           betinfo[5]=1;
307           if(onecount < twocount ){
308             betinfo[5]=2;
309             rates = getPlayRate(betinfo[1],0);
310             betinfo[6]=betinfo[3]*rates/10;
311           }else{
312               //if(onecount == twocount){//和
313               //    betinfo[5]=2;
314               //    rates = 1;
315               //    betinfo[6]=betinfo[3]*rates;
316              // }else{
317                   betinfo[5]=1;
318              // }
319           }
320         }
321 
322     }
323 
324     function getLastBet() public view returns(string memory opennum,uint[7][] memory result){
325       uint len=playerLableList[msg.sender].length;
326       require(len>0);
327 
328       uint i=len-1;
329       bytes32 lastLable = playerLableList[msg.sender][i];
330       uint max = lableCount[lastLable];
331       if(max > 50){
332           max = 50;
333       }
334       uint[7][] memory result = new uint[7][](max) ;
335       string memory opennum = "";
336       for(uint a=0;a<max;a++){
337          string memory ttmp =openNumberStr[lastLable];
338          if(a==0){
339            opennum =ttmp;
340          }else{
341            opennum = strConcat(opennum,";",ttmp);
342          }
343 
344          result[a] = betList[lastLable][a];
345          if(lableStatus[lastLable] == 1){
346            result[a][5]=3;
347          }
348 
349       }
350 
351       return (opennum,result);
352     }
353 
354     function getLableRecords(bytes32 lable) public view returns(string memory opennum,uint[7][] memory result){
355       uint max = lableCount[lable];
356       if(max > 50){
357           max = 50;
358       }
359       uint[7][] memory result = new uint[7][](max) ;
360       string memory opennum="";
361 
362       for(uint a=0;a<max;a++){
363          result[a] = betList[lable][a];
364          if(lableStatus[lable] == 1){
365            result[a][5]=3;
366          }
367          string memory ttmp =openNumberStr[lable];
368          if(a==0){
369            opennum =ttmp;
370          }else{
371            opennum = strConcat(opennum,";",ttmp);
372          }
373       }
374 
375       return (opennum,result);
376     }
377 
378     function getAllRecords() public view returns(string  memory opennum,uint[7][] memory result){
379         uint len=playerLableList[msg.sender].length;
380         require(len>0);
381 
382         uint max;
383         bytes32 lastLable ;
384         uint ss;
385 
386         for(uint i1=0;i1<len;i1++){
387             ss = len-i1-1;
388             lastLable = playerLableList[msg.sender][ss];
389             max += lableCount[lastLable];
390             if(100 < max){
391               max = 100;
392               break;
393             }
394         }
395 
396         uint[7][] memory result = new uint[7][](max) ;
397         bytes32[] memory resultlable = new bytes32[](max) ;
398         string memory opennum="";
399 
400         bool flag=false;
401         uint betnums;
402         uint j=0;
403 
404         for(uint ii=0;ii<len;ii++){
405             ss = len-ii-1;
406             lastLable = playerLableList[msg.sender][ss];
407             betnums = lableCount[lastLable];
408             for(uint k= 0; k<betnums; k++){
409               if(j<max){
410                   resultlable[j] = lastLable;
411               	 string memory ttmp =openNumberStr[lastLable];
412                  if(j==0){
413                    opennum =ttmp;
414                  }else{
415                    opennum = strConcat(opennum,";",ttmp);
416                  }
417                   result[j] = betList[lastLable][k];
418                   if(lableStatus[lastLable] == 1){
419                     result[j][5]=3;
420                   }else if(lableStatus[lastLable] == 2){
421                     if(result[j][5]==2){
422                       result[j][5]=4;
423                     }
424                   }else if(lableStatus[lastLable] == 3){
425                     if(result[j][5]==2){
426                       result[j][5]=5;
427                     }
428                   }
429                   j++;
430               }else{
431                 flag = true;
432                 break;
433               }
434             }
435             if(flag){
436                 break;
437             }
438         }
439         return (opennum,result);
440     }
441 
442   //function setoraclegasprice(uint newGas) public onlyAdmin(){
443   //  oraclize_setCustomGasPrice(newGas * 1 wei);
444   //}
445   //function setoraclelimitgas(uint _oraclizeGasLimit) public onlyAdmin(){
446   //  oraclizeGasLimit=(_oraclizeGasLimit);
447   //}
448 
449   function senttest() public payable onlyAdmin{
450       contractBalance=address(this).balance;
451       maxProfit=(address(this).balance*maxmoneypercent)/100;
452   }
453 
454   function withdraw(uint _amount , address payable desaccount) public onlyAdmin{
455       desaccount.transfer(_amount);
456       contractBalance=address(this).balance;
457       maxProfit=(address(this).balance * maxmoneypercent)/100;
458   }
459 
460   function deposit() public payable onlyAdmin returns(uint8 ret){
461       contractBalance=address(this).balance;
462       maxProfit=(address(this).balance * maxmoneypercent)/100;
463       ret = 1;
464   }
465 
466   function getDatas() public view returns(
467     uint _maxProfit,
468     uint _minBet,
469     uint _contractbalance,
470     uint _onoff,
471     address _owner,
472     uint _oraclizeFee
473     ){
474         _maxProfit=maxProfit;
475         _minBet=minBet;
476         _contractbalance=contractBalance;
477         _onoff=onoff;
478         _owner=owner;
479        // _oraclizeFee=oraclizeFee;
480     }
481 
482     function getLableList() public view returns(string memory opennum,bytes32[] memory lablelist,uint[] memory labletime,uint[] memory lablestatus,uint){
483       uint len=playerLableList[msg.sender].length;
484       require(len>0);
485 
486       uint max=50;
487       if(len < 50){
488           max = len;
489       }
490 
491       bytes32[] memory lablelist = new bytes32[](max) ;
492       uint[] memory labletime = new uint[](max) ;
493       uint[] memory lablestatus = new uint[](max) ;
494       string memory opennum="";
495 
496       bytes32 lastLable ;
497       for(uint i=0;i<max;i++){
498           lastLable = playerLableList[msg.sender][max-i-1];
499           lablelist[i]=lastLable;
500           labletime[i]=lableTime[lastLable];
501           lablestatus[i]=lableStatus[lastLable];
502           string memory ttmp =openNumberStr[lastLable];
503          if(i==0){
504            opennum =ttmp;
505          }else{
506            opennum = strConcat(opennum,";",ttmp);
507          }
508       }
509 
510       return (opennum,lablelist,labletime,lablestatus,now);
511     }
512 
513     function doCheckBounds(bytes32 queryId) internal{
514         uint sta = lableStatus[queryId];
515         require(sta == 0 || sta == 2);
516         uint[4] memory codes = openNumberList[queryId];
517         require(codes[0] > 0);
518 
519         uint len = lableCount[queryId];
520 
521         uint totalWin;
522         address payable to = lableUser[queryId];
523         for(uint aa = 0 ; aa<len; aa++){
524           if(sta == 0){
525            if(betList[queryId][aa][5] == 0){
526              checkWinMoney(betList[queryId][aa],codes);
527              totalWin+=betList[queryId][aa][6];
528            }
529           }else if(sta == 2){
530               totalWin+=betList[queryId][aa][6];
531           }
532         }
533 
534         lableStatus[queryId] = 2;
535 
536         if(totalWin > 0){
537           if(totalWin < address(this).balance){
538             to.transfer(totalWin);
539             lableStatus[queryId] = 3;
540           }else{
541               emit LogNewOraclizeQuery("sent bouns fail.",queryId);
542           }
543         }else{
544           lableStatus[queryId] = 3;
545         }
546         contractBalance=address(this).balance;
547         maxProfit=(address(this).balance * maxmoneypercent)/100;
548     }
549 
550     function getOpenNum(bytes32 queryId) public view returns(string memory result){
551         result = openNumberStr[queryId];
552         //return openNumberStr[queryId];
553     }
554 
555     function doCheckSendBounds() public payable{
556         uint len=playerLableList[msg.sender].length;
557 
558       uint max=50;
559       if(len < 50){
560           max = len;
561       }
562 
563       uint sta;
564       bytes32 lastLable ;
565       for(uint i=0;i<max;i++){
566           lastLable = playerLableList[msg.sender][max-i-1];
567           sta = lableStatus[lastLable];
568           if(sta == 0 || sta==2){
569             doCheckBounds(lastLable);
570           }
571       }
572     }
573 
574     function doCancelAll() public payable{
575         uint len=playerLableList[msg.sender].length;
576 
577       uint max=50;
578       if(len < 50){
579           max = len;
580       }
581 
582       uint sta;
583       uint bettime;
584       bytes32 lastLable ;
585       for(uint i=0;i<max;i++){
586           lastLable = playerLableList[msg.sender][max-i-1];
587           sta = lableStatus[lastLable];
588           bettime = lableTime[lastLable];
589           if(sta == 0 && (now - bettime)>600){
590             doCancel(lastLable);
591           }
592       }
593     }
594 
595     function splitStr(string memory str, string memory delimiter) internal returns (uint [] memory){ //delimiter can be any character that separates the integers
596      bytes memory b = bytes(str); //cast the string to bytes to iterate
597      bytes memory delm = bytes(delimiter);
598      delete(numbers);
599      delete(tempNum);
600      for(uint i; i<b.length ; i++){
601      if(b[i] != delm[0]) { //check if a not space
602        tempNum.push(b[i]);
603       }
604       else {
605        numbers.push(parseInt(string(tempNum))); //push the int value converted from string to numbers array
606        tempNum = ""; //reset the tempNum to catch the net number
607       }
608      }
609      if(b[b.length-1] != delm[0]) {
610       numbers.push(parseInt(string(tempNum)));
611      }
612      return numbers;
613     }
614 
615     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
616         if (_i == 0) {
617             return "0";
618         }
619         uint j = _i;
620         uint len;
621         while (j != 0) {
622             len++;
623             j /= 10;
624         }
625         bytes memory bstr = new bytes(len);
626         uint k = len - 1;
627         while (_i != 0) {
628             bstr[k--] = byte(uint8(48 + _i % 10));
629             _i /= 10;
630         }
631      return string(bstr);
632     }
633 
634     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
635         return strConcat(_a, _b, "", "", "");
636     }
637 
638     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
639         return strConcat(_a, _b, _c, "", "");
640     }
641 
642     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
643         return strConcat(_a, _b, _c, _d, "");
644     }
645 
646     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
647         bytes memory _ba = bytes(_a);
648         bytes memory _bb = bytes(_b);
649         bytes memory _bc = bytes(_c);
650         bytes memory _bd = bytes(_d);
651         bytes memory _be = bytes(_e);
652         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
653         bytes memory babcde = bytes(abcde);
654         uint k = 0;
655         uint i = 0;
656         for (i = 0; i < _ba.length; i++) {
657             babcde[k++] = _ba[i];
658         }
659         for (i = 0; i < _bb.length; i++) {
660             babcde[k++] = _bb[i];
661         }
662         for (i = 0; i < _bc.length; i++) {
663             babcde[k++] = _bc[i];
664         }
665         for (i = 0; i < _bd.length; i++) {
666             babcde[k++] = _bd[i];
667         }
668         for (i = 0; i < _be.length; i++) {
669             babcde[k++] = _be[i];
670         }
671         return string(babcde);
672     }
673 
674     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
675         return safeParseInt(_a, 0);
676     }
677 
678     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
679         bytes memory bresult = bytes(_a);
680         uint mint = 0;
681         bool decimals = false;
682         for (uint i = 0; i < bresult.length; i++) {
683             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
684                 if (decimals) {
685                    if (_b == 0) break;
686                     else _b--;
687                 }
688                 mint *= 10;
689                 mint += uint(uint8(bresult[i])) - 48;
690             } else if (uint(uint8(bresult[i])) == 46) {
691                 require(!decimals, 'More than one decimal encountered in string!');
692                 decimals = true;
693             } else {
694                 revert("Non-numeral character encountered in string!");
695             }
696         }
697         if (_b > 0) {
698             mint *= 10 ** _b;
699         }
700         return mint;
701     }
702 
703     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
704         return parseInt(_a, 0);
705     }
706 
707     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
708         bytes memory bresult = bytes(_a);
709         uint mint = 0;
710         bool decimals = false;
711         for (uint i = 0; i < bresult.length; i++) {
712             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
713                 if (decimals) {
714                    if (_b == 0) {
715                        break;
716                    } else {
717                        _b--;
718                    }
719                 }
720                 mint *= 10;
721                 mint += uint(uint8(bresult[i])) - 48;
722             } else if (uint(uint8(bresult[i])) == 46) {
723                 decimals = true;
724             }
725         }
726         if (_b > 0) {
727             mint *= 10 ** _b;
728         }
729         return mint;
730     }
731 
732 
733     function setRandomSeed(uint _randomSeed) public payable onlyAdmin{
734       randonce = _randomSeed;
735     }
736 
737     function getRandomSeed() public view onlyAdmin returns(uint _randonce) {
738       _randonce = randonce;
739     }
740 
741 }