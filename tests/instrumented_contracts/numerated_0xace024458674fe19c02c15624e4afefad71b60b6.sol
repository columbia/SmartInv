1 pragma solidity ^0.4.24;
2 // pragma experimental ABIEncoderV2;
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     int256 constant private INT256_MIN = -2**255;
9 
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Multiplies two signed integers, reverts on overflow.
29     */
30     function mul(int256 a, int256 b) internal pure returns (int256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
39 
40         int256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
60     */
61     function div(int256 a, int256 b) internal pure returns (int256) {
62         require(b != 0); // Solidity only automatically asserts when dividing by 0
63         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
64 
65         int256 c = a / b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81     * @dev Subtracts two signed integers, reverts on overflow.
82     */
83     function sub(int256 a, int256 b) internal pure returns (int256) {
84         int256 c = a - b;
85         require((b >= 0 && c <= a) || (b < 0 && c > a));
86 
87         return c;
88     }
89 
90     /**
91     * @dev Adds two unsigned integers, reverts on overflow.
92     */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a);
96 
97         return c;
98     }
99 
100     /**
101     * @dev Adds two signed integers, reverts on overflow.
102     */
103     function add(int256 a, int256 b) internal pure returns (int256) {
104         int256 c = a + b;
105         require((b >= 0 && c >= a) || (b < 0 && c < a));
106 
107         return c;
108     }
109 
110     /**
111     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
112     * reverts when dividing by zero.
113     */
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b != 0);
116         return a % b;
117     }
118 }
119 
120 
121 library Helper {
122     using SafeMath for uint256;
123     
124         
125     function bytes32ToUint(bytes32 n) 
126         public
127         pure
128         returns (uint256) 
129     {
130         return uint256(n);
131     }
132     
133     function stringToBytes32(string memory source) 
134         public
135         pure
136         returns (bytes32 result) 
137     {
138         bytes memory tempEmptyStringTest = bytes(source);
139         if (tempEmptyStringTest.length == 0) {
140             return 0x0;
141         }
142 
143         assembly {
144             result := mload(add(source, 32))
145         }
146     }
147     
148     function stringToUint(string memory source) 
149         public
150         pure
151         returns (uint256)
152     {
153         return bytes32ToUint(stringToBytes32(source));
154     }
155     
156     function validUsername(string _username)
157         public
158         pure
159         returns(bool)
160     {
161         bytes memory b = bytes(_username);
162         // Im Raum [4, 18]
163         if ((b.length < 4) || (b.length > 18)) return false;
164         // Letzte Char != ' '
165         
166         for(uint i; i<b.length; i++){
167             bytes1 char = b[i];
168             if(
169                 !(char >= 0x30 && char <= 0x39) &&
170                 !(char >= 0x41 && char <= 0x5A) //A-Z
171             )
172                 return false;
173         }
174         
175         if (b[0] >= 0x30 && b[0] <= 0x39) return false;
176         
177         return true;
178     }   
179 }
180 
181 interface DAAInterface {
182     function citizenMintToken(address _buyer, uint256 _buyPrice, int8 _is_win) external returns(uint256);
183     function transfer(address _to, uint256 _value) external returns(bool);
184     function transferFrom(address _from, address _to, uint256 _tokenAmount) external returns(bool);
185     function balanceOf(address _from) external returns(uint256);
186     function currentRoundDividend() external;
187     function getDividendView(address _sender) external returns(uint256);
188     function getDividendPull(address _sender, uint256 _value) external returns(uint256);
189     function payOut(address _winner, uint256 _unit, uint256 _value, uint256 _valuebet) external;
190     function getCitizenBalanceEth(address _sender) external returns(uint256);
191     function totalSupplyByAddress(address _sender) external returns(uint256);
192 }
193 
194 interface TicketInterface{
195     function getEarlyIncomePull(address _sender) external returns(uint256);
196     function getEarlyIncomeView(address _sender, bool _current) external returns(uint256); 
197     function getEarlyIncomeByRound(address _buyer, uint256 _round) external returns(uint256);
198     function currentRound() external returns(uint256);
199     function ticketSumByAddress(address _sender) external returns(uint256);
200 }
201 
202 contract CitizenStorage{
203     using SafeMath for uint256;
204     
205     address controller; 
206     modifier onlyCoreContract() {
207         require(msg.sender == controller, "admin required");
208         _;
209     }
210     
211     mapping (address => uint256) public citizenWinIncome;
212     mapping (address => uint256) public citizenGameWinIncome;
213     mapping (address => uint256) public citizenWithdrawed;
214     
215     function addWinIncome(address _citizen, uint256 _value) public onlyCoreContract() {
216          citizenWinIncome[_citizen] = _value.add(citizenWinIncome[_citizen]);
217          citizenWithdrawed[_citizen] = citizenWithdrawed[_citizen].add(_value);
218     }
219     function addGameWinIncome(address _citizen, uint256 _value, bool _enough) public onlyCoreContract() {
220         citizenGameWinIncome[_citizen] = _value.add(citizenGameWinIncome[_citizen]);
221         if (_enough){
222             citizenWithdrawed[_citizen] = citizenWithdrawed[_citizen].add(_value);
223         }
224     }
225     function pushCitizenWithdrawed(address _sender, uint256 _value) public onlyCoreContract(){
226         citizenWithdrawed[_sender] = citizenWithdrawed[_sender].add(_value);
227     }
228     constructor (address _contract)
229         public
230     {
231         require(controller== 0x0, "require setup");
232         controller = _contract;
233     }
234 }
235 
236 contract Citizen{
237     using SafeMath for uint256;
238     
239     // event Register(uint256 id, uint256 username, address indexed citizen, address indexed ref,
240     //                 uint256 ticket, uint256 ticketSpend, uint256 totalGameSpend, uint256 totalMined,
241     //                 uint256 dateJoin, uint256 totalWithdraw);
242                     
243     event Register(uint256 id, uint256 username, address indexed citizen, address indexed ref, uint256 ticketSpend, uint256 totalGameSpend, uint256 dateJoin);
244     modifier onlyAdmin() {
245         require(msg.sender == devTeam1, "admin required");
246         _;
247     }
248     
249     modifier onlyCoreContract() {
250         require(isCoreContract[msg.sender], "admin required");
251         _;
252     }
253 
254     modifier notRegistered(){
255         require(!isCitizen[msg.sender], "already exist");
256         _;
257     }
258 
259     modifier registered(){
260         require(isCitizen[msg.sender], "must be a citizen");
261         _;
262     }
263     
264     uint8[10] public TICKET_LEVEL_REF = [uint8(60),40,20,10,10,10,5,5,5,5];// 3 demical
265     uint8[10] public GAME_LEVEL_REF = [uint8(5),2,1,1,1,1,1,1,1,1];// 3 demical
266     
267     
268     struct Profile{
269         uint256 id;
270         uint256 username;
271         address ref;
272         mapping(uint => address[]) refTo;
273         mapping(address => uint256) payOut;
274         uint256 totalChild;
275         uint256 treeLevel;
276         
277         uint256 citizenBalanceEth;
278         uint256 citizenBalanceEthBackup;
279         
280         uint256 citizenTicketSpend;
281         uint256 citizenGameEthSpend;
282         uint256 citizenGameTokenSpend;
283         
284         
285         uint256 citizenEarlyIncomeRevenue;
286         uint256 citizenTicketRevenue;
287         uint256 citizenGameEthRevenue;
288         uint256 citizenGameTokenRevenue;
289     }
290 
291 
292     
293     mapping (address => uint256) public citizenEthDividend;
294 
295     address[21] public mostTotalSpender;
296     mapping (address => uint256) public mostTotalSpenderId;
297     mapping (address => mapping(uint256 => uint256)) public payOutByLevel;
298     
299     mapping (address => Profile) public citizen;
300     mapping (address => bool) public isCitizen;
301     mapping (uint256 => address) public idAddress;
302     mapping (uint256 => address) public usernameAddress;
303     mapping (uint256 => address[]) public levelCitizen;
304 
305 
306     address devTeam1; 
307     address devTeam2; 
308     address devTeam3; 
309     address devTeam4;
310     
311     uint256 public citizenNr;
312     uint256 lastLevel;
313     
314     uint256 earlyIncomeBalanceEth;
315     
316     DAAInterface public DAAContract;
317     TicketInterface public TicketContract;
318     CitizenStorage public CitizenStorageContract;
319     mapping (address => bool) public isCoreContract;
320     uint256 public coreContractSum;
321     address[] public coreContracts;
322     
323 
324     constructor (address[4] _devTeam)
325         public
326     {
327         devTeam1 = _devTeam[0];
328         devTeam2 = _devTeam[1];
329         devTeam3 = _devTeam[2];
330         devTeam4 = _devTeam[3];
331 
332         // first citizen is the development team
333         citizenNr = 1;
334         idAddress[1] = devTeam3;
335         isCitizen[devTeam3] = true;
336         //root => self ref
337         citizen[devTeam3].ref = devTeam3;
338         // username rules bypass
339         uint256 _username = Helper.stringToUint("GLOBAL");
340         citizen[devTeam3].username = _username;
341         usernameAddress[_username] = devTeam3; 
342         citizen[devTeam3].id = 1;
343         citizen[devTeam3].treeLevel = 1;
344         levelCitizen[1].push(devTeam3);
345         lastLevel = 1;
346     }
347     
348     // DAAContract, TicketContract, CitizenContract, CitizenStorage 
349     function joinNetwork(address[4] _contract)
350         public
351     {
352         require(address(DAAContract) == 0x0,"already setup");
353         DAAContract = DAAInterface(_contract[0]);
354         TicketContract = TicketInterface(_contract[1]);
355         CitizenStorageContract = CitizenStorage(_contract[3]);
356         for(uint256 i =0; i<3; i++){
357             isCoreContract[_contract[i]]=true;
358             coreContracts.push(_contract[i]);
359         }
360         coreContractSum = 3;
361     }
362 
363     function updateTotalChild(address _address)
364         private
365     {
366         address _member = _address;
367         while(_member != devTeam3) {
368             _member = getRef(_member);
369             citizen[_member].totalChild ++;
370         }
371     }
372     
373     function addCoreContract(address _address) public  // [dev1]
374         onlyAdmin()
375     {
376         require(_address!=0x0,"Invalid address");
377         isCoreContract[_address] = true;
378         coreContracts.push(_address);
379         coreContractSum+=1;
380     }
381     
382     function updateRefTo(address _address) private {
383         address _member = _address;
384         uint256 level =1;
385         while (_member != devTeam3 && level<11){
386             _member = getRef(_member);
387             citizen[_member].refTo[level].push(_address);
388             level = level+1;
389         }
390     }
391 
392     function register(string _sUsername, address _ref)
393         public
394         notRegistered()
395     {
396         require(Helper.validUsername(_sUsername), "invalid username");
397         address sender = msg.sender;
398         uint256 _username = Helper.stringToUint(_sUsername);
399         require(usernameAddress[_username] == 0x0, "username already exist");
400         usernameAddress[_username] = sender;
401         //ref must be a citizen, else ref = devTeam
402         address validRef = isCitizen[_ref] ? _ref : devTeam3;
403 
404         //Welcome new Citizen
405         isCitizen[sender] = true;
406         citizen[sender].username = _username;
407         citizen[sender].ref = validRef;
408         citizenNr++;
409 
410         idAddress[citizenNr] = sender;
411         citizen[sender].id = citizenNr;
412         
413         uint256 refLevel = citizen[validRef].treeLevel;
414         if (refLevel == lastLevel) lastLevel++;
415         citizen[sender].treeLevel = refLevel + 1;
416         levelCitizen[refLevel + 1].push(sender);
417         //add child
418         updateRefTo(sender);
419         updateTotalChild(sender);
420         emit Register(citizenNr,_username, sender, validRef, citizen[sender].citizenTicketSpend, citizen[sender].citizenGameEthSpend, now);
421     }
422     
423     // function updateUsername(string _sNewUsername)
424     //     public
425     //     registered()
426     // {
427     //     require(Helper.validUsername(_sNewUsername), "invalid username");
428     //     address sender = msg.sender;
429     //     uint256 _newUsername = Helper.stringToUint(_sNewUsername);
430     //     require(usernameAddress[_newUsername] == 0x0, "username already exist");
431     //     uint256 _oldUsername = citizen[sender].username;
432     //     citizen[sender].username = _newUsername;
433     //     usernameAddress[_oldUsername] = 0x0;
434     //     usernameAddress[_newUsername] = sender;
435     // }
436 
437     function getRef(address _address)
438         public
439         view
440         returns (address)
441     {
442         return citizen[_address].ref == 0x0 ? devTeam3 : citizen[_address].ref;
443     }
444     
445     function getUsername(address _address)
446         public
447         view
448         returns (uint256)
449     {
450         return citizen[_address].username;
451     }
452     
453     function isDev() public view returns(bool){
454         if (msg.sender == devTeam1) return true;
455         return false;
456     }
457     
458     function getAddressById(uint256 _id)
459         public
460         view
461         returns (address)
462     {
463         return idAddress[_id];
464     }
465 
466     function getAddressByUserName(string _username)
467         public
468         view
469         returns (address)
470     {
471         return usernameAddress[Helper.stringToUint(_username)];
472     }
473     
474     function pushTicketRefIncome(address _sender)
475         public
476         payable
477         onlyCoreContract() 
478     {
479         uint256 _amount = msg.value; // 17%
480         _amount = _amount.div(170);
481         address sender = _sender;
482         address ref = getRef(sender);
483         uint256 money;
484         uint8 level;
485         
486         for (level=0; level<10; level++){
487             money = _amount.mul(TICKET_LEVEL_REF[level]);
488             citizen[ref].citizenBalanceEth = money.add(citizen[ref].citizenBalanceEth);
489             citizen[ref].citizenTicketRevenue = money.add(citizen[ref].citizenTicketRevenue);
490             citizen[ref].payOut[_sender] = money.add(citizen[ref].payOut[_sender]);
491             payOutByLevel[ref][level+1] = money.add(payOutByLevel[ref][level+1]);
492             sender = ref;
493             ref = getRef(sender);
494         }
495     }    
496     
497     function pushGametRefIncome(address _sender)
498         public
499         payable
500         onlyCoreContract() 
501     {
502         uint256 _amount =  msg.value; // 1.5%
503         _amount = _amount.div(15);
504         address sender = _sender;
505         address ref = getRef(sender);
506         uint256 level;
507         uint256 money;
508         uint256 forDaa;
509         for (level=0; level<10; level++){
510             forDaa=0;
511             money = _amount.mul(GAME_LEVEL_REF[level]);
512             if (citizen[ref].citizenGameEthRevenue<citizen[ref].citizenGameEthSpend.div(10)){
513                 if (citizen[ref].citizenGameEthRevenue+money>citizen[ref].citizenGameEthSpend.div(10)){
514                     forDaa = citizen[ref].citizenGameEthRevenue+money-citizen[ref].citizenGameEthSpend.div(10);
515                     money = money.sub(forDaa);
516                 }
517             } else {
518                 forDaa = money;
519                 money = 0;
520             }
521             
522             citizen[ref].citizenBalanceEth = money.add(citizen[ref].citizenBalanceEth);
523             citizen[ref].citizenGameEthRevenue = money.add(citizen[ref].citizenGameEthRevenue);
524             citizen[ref].payOut[_sender] = money.add(citizen[ref].payOut[_sender]);
525             payOutByLevel[ref][level+1] = money.add(payOutByLevel[ref][level+1]);
526             
527             citizen[devTeam3].citizenBalanceEth = forDaa.add(citizen[devTeam3].citizenBalanceEth);
528             citizen[devTeam3].citizenGameEthRevenue = forDaa.add(citizen[devTeam3].citizenGameEthRevenue);
529             
530             sender = ref;
531             ref = getRef(sender);
532         }
533     }    
534     function pushGametRefIncomeToken(address _sender, uint256 _amount)
535         public
536         payable
537         onlyCoreContract() 
538     {
539         _amount = _amount.div(15);
540         address sender = _sender;
541         address ref = getRef(sender);
542         uint256 level;
543         uint256 money;
544         uint256 forDaa;
545         
546         for (level=0; level<10; level++){
547             forDaa=0;
548             money = _amount.mul(GAME_LEVEL_REF[level]);
549             if (citizen[ref].citizenGameTokenRevenue<citizen[ref].citizenGameTokenSpend.div(10)){
550                 if (citizen[ref].citizenGameTokenRevenue+money>citizen[ref].citizenGameTokenSpend.div(10)){
551                     forDaa = citizen[ref].citizenGameTokenRevenue+money-citizen[ref].citizenGameTokenSpend.div(10);
552                     money = money.sub(forDaa);
553                 }
554             } else {
555                 forDaa = money;
556                 money = 0;
557             }
558             
559             DAAContract.payOut(ref,1,money,0);
560             citizen[ref].citizenGameTokenRevenue=money.add(citizen[ref].citizenGameTokenRevenue);
561             
562             DAAContract.payOut(devTeam3,1,forDaa,0);
563             citizen[devTeam3].citizenGameTokenRevenue = forDaa.add(citizen[devTeam3].citizenGameTokenRevenue);
564             
565             sender = ref;
566             ref = getRef(sender);
567         }
568     }
569     
570     function pushEarlyIncome() public payable{
571         uint256 _value = msg.value;
572         earlyIncomeBalanceEth = earlyIncomeBalanceEth.add(_value);
573     }
574     
575     function sortMostSpend(address _citizen) private {
576         uint256 citizen_spender = getTotalSpend(_citizen);
577         uint256 i=1;
578         while (i<21) {
579             if (mostTotalSpender[i]==0x0||(mostTotalSpender[i]!=0x0&&getTotalSpend(mostTotalSpender[i])<citizen_spender)){
580                 if (mostTotalSpenderId[_citizen]!=0&&mostTotalSpenderId[_citizen]<i){
581                     break;
582                 }
583                 if (mostTotalSpenderId[_citizen]!=0){
584                     mostTotalSpender[mostTotalSpenderId[_citizen]]=0x0;
585                 }
586                 address temp1 = mostTotalSpender[i];
587                 address temp2;
588                 uint256 j=i+1;
589                 while (j<21&&temp1!=0x0){
590                     temp2 = mostTotalSpender[j];
591                     mostTotalSpender[j]=temp1;
592                     mostTotalSpenderId[temp1]=j;
593                     temp1 = temp2;
594                     j++;
595                 }
596                 mostTotalSpender[i]=_citizen;
597                 mostTotalSpenderId[_citizen]=i;
598                 break;
599             }
600             i++;
601         }
602     }
603     
604     function addTicketEthSpend(address _citizen, uint256 _value) onlyCoreContract() public {
605         citizen[_citizen].citizenTicketSpend = citizen[_citizen].citizenTicketSpend.add(_value);
606         DAAContract.citizenMintToken(_citizen,_value,0);// buy ticket 0, win 1, lose -1;
607         sortMostSpend(_citizen);
608     }   
609     
610     // Game spend 
611     function addGameEthSpendWin(address _citizen, uint256 _value, uint256 _valuewin, bool _enough) onlyCoreContract() public {
612         citizen[_citizen].citizenGameEthSpend = citizen[_citizen].citizenGameEthSpend.add(_value);
613         // DAAContract.citizenMintToken(_citizen,_value,1);// buy ticket 0, win 1, lose -1;
614         CitizenStorageContract.addGameWinIncome(_citizen, _valuewin, _enough);
615         sortMostSpend(_citizen);
616     }     
617     function addGameEthSpendLose(address _citizen, uint256 _value) onlyCoreContract() public {
618         citizen[_citizen].citizenGameEthSpend = citizen[_citizen].citizenGameEthSpend.add(_value);
619         DAAContract.citizenMintToken(_citizen,_value,-1);// buy ticket 0, win 1, lose -1;
620         sortMostSpend(_citizen);
621     }    
622     function addGameTokenSpend(address _citizen, uint256 _value) onlyCoreContract() public {
623         citizen[_citizen].citizenGameTokenSpend = citizen[_citizen].citizenGameTokenSpend.add(_value);
624     }
625     
626     function withdrawEth() public registered() {
627         address _sender = msg.sender;
628         uint256 _earlyIncome = TicketContract.getEarlyIncomePull(_sender);
629         uint256 _devidend = DAAContract.getDividendView(msg.sender);
630         uint256 _citizenBalanceEth = citizen[_sender].citizenBalanceEth;
631         uint256 _total = _earlyIncome.add(_devidend).add(_citizenBalanceEth).add(DAAContract.getCitizenBalanceEth(_sender));
632         require(_total>0,"Balance none");
633         CitizenStorageContract.pushCitizenWithdrawed(_sender,_total);
634         DAAContract.getDividendPull(_sender,_citizenBalanceEth+_earlyIncome);
635         _sender.transfer(_citizenBalanceEth+_earlyIncome);
636         citizen[_sender].citizenBalanceEthBackup = citizen[_sender].citizenBalanceEthBackup.add(_citizenBalanceEth).add(_earlyIncome).add(_devidend);
637         citizen[_sender].citizenEarlyIncomeRevenue = citizen[_sender].citizenEarlyIncomeRevenue.add(_earlyIncome);
638         citizenEthDividend[_sender] = citizenEthDividend[_sender].add(_devidend);
639         earlyIncomeBalanceEth= earlyIncomeBalanceEth.sub(_earlyIncome);
640         citizen[_sender].citizenBalanceEth = 0;
641     }
642     
643     function addWinIncome(address _citizen, uint256 _value)  onlyCoreContract()  public {
644         CitizenStorageContract.addWinIncome(_citizen, _value); 
645     }
646     // function addGameWinIncome(address _citizen, uint256 _value, bool _enough) public {
647     //     CitizenStorageContract.addGameWinIncome(_citizen, _value, _enough);
648     // }
649     
650     // function getInWallet() public view returns (uint256){
651     //     uint256 _sum;
652     //     address _sender = msg.sender;
653     //     _sum = _sum.add(citizen[_sender].citizenBalanceEth);
654     //     _sum = _sum.add(TicketContract.getEarlyIncomeView(_sender));
655     //     _sum = _sum.add(DAAContract.getDividendView(_sender));
656     //     _sum = _sum.add(DAAContract.getCitizenBalanceEth(_sender));
657     //     return _sum;
658     // }  
659     
660     function getTotalEth() public registered() view returns(uint256){
661         uint256 _sum;
662         address _sender = msg.sender;
663         _sum = _sum.add(citizen[_sender].citizenBalanceEth);
664         _sum = _sum.add(citizen[_sender].citizenBalanceEthBackup);
665         _sum = _sum.add(CitizenStorageContract.citizenWinIncome(_sender));
666         _sum = _sum.add(TicketContract.getEarlyIncomeView(_sender, false));
667         _sum = _sum.add(DAAContract.getDividendView(_sender));
668         return _sum;
669     }
670     
671     function getTotalDividend(address _sender) public registered() view returns(uint256){
672         return citizenEthDividend[_sender].add(DAAContract.getDividendView(_sender));
673     }
674     
675     function getTotalEarlyIncome(address _sender) public registered() view returns(uint256){
676         uint256 _sum;
677         _sum = citizen[_sender].citizenEarlyIncomeRevenue;
678         _sum = _sum.add(TicketContract.getEarlyIncomeView(_sender, true));
679         return _sum;
680     }
681     
682     function getTotalSpend(address _sender) public view returns(uint256){
683         return citizen[_sender].citizenGameEthSpend+citizen[_sender].citizenTicketSpend;
684     }
685     
686     function getMemberByLevelToTal(uint256 _level) public view returns(uint256, uint256){
687         address _sender = msg.sender;
688         return(citizen[_sender].refTo[_level].length,payOutByLevel[_sender][_level]);
689     }
690     
691     function getMemberByLevel(uint256 _level, address _sender, uint256 _id) public view returns(address){
692         return citizen[_sender].refTo[_level][_id];
693     }
694     
695     function citizenPayForRef(address _citizen, address _ref) public view returns(uint256){
696         return citizen[_ref].payOut[_citizen];
697     }
698 }