1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 library Helper {
10     using SafeMath for uint256;
11 
12     uint256 constant public ZOOM = 1000;
13     uint256 constant public SDIVIDER = 3450000;
14     uint256 constant public PDIVIDER = 3450000;
15     uint256 constant public RDIVIDER = 1580000;
16     // Starting LS price (SLP)
17     uint256 constant public SLP = 0.002 ether;
18     // Starting Added Time (SAT)
19     uint256 constant public SAT = 30; // seconds
20     // Price normalization (PN)
21     uint256 constant public PN = 777;
22     // EarlyIncome base
23     uint256 constant public PBASE = 13;
24     uint256 constant public PMULTI = 26;
25     uint256 constant public LBase = 15;
26 
27     uint256 constant public ONE_HOUR = 3600;
28     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
29     //uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
30     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
31     
32     function bytes32ToString (bytes32 data)
33         public
34         pure
35         returns (string) 
36     {
37         bytes memory bytesString = new bytes(32);
38         for (uint j=0; j<32; j++) {
39             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
40             if (char != 0) {
41                 bytesString[j] = char;
42             }
43         }
44         return string(bytesString);
45     }
46     
47     function uintToBytes32(uint256 n)
48         public
49         pure
50         returns (bytes32) 
51     {
52         return bytes32(n);
53     }
54     
55     function bytes32ToUint(bytes32 n) 
56         public
57         pure
58         returns (uint256) 
59     {
60         return uint256(n);
61     }
62     
63     function stringToBytes32(string memory source) 
64         public
65         pure
66         returns (bytes32 result) 
67     {
68         bytes memory tempEmptyStringTest = bytes(source);
69         if (tempEmptyStringTest.length == 0) {
70             return 0x0;
71         }
72 
73         assembly {
74             result := mload(add(source, 32))
75         }
76     }
77     
78     function stringToUint(string memory source) 
79         public
80         pure
81         returns (uint256)
82     {
83         return bytes32ToUint(stringToBytes32(source));
84     }
85     
86     function uintToString(uint256 _uint) 
87         public
88         pure
89         returns (string)
90     {
91         return bytes32ToString(uintToBytes32(_uint));
92     }
93 
94 /*     
95     function getSlice(uint256 begin, uint256 end, string text) public pure returns (string) {
96         bytes memory a = new bytes(end-begin+1);
97         for(uint i = 0; i <= end - begin; i++){
98             a[i] = bytes(text)[i + begin - 1];
99         }
100         return string(a);    
101     }
102  */
103     function validUsername(string _username)
104         public
105         pure
106         returns(bool)
107     {
108         uint256 len = bytes(_username).length;
109         // Im Raum [4, 18]
110         if ((len < 4) || (len > 18)) return false;
111         // Letzte Char != ' '
112         if (bytes(_username)[len-1] == 32) return false;
113         // Erste Char != '0'
114         return uint256(bytes(_username)[0]) != 48;
115     }
116 
117     // Lottery Helper
118 
119     // Seconds added per LT = SAT - ((Current no. of LT + 1) / SDIVIDER)^6
120     function getAddedTime(uint256 _rTicketSum, uint256 _tAmount)
121         public
122         pure
123         returns (uint256)
124     {
125         //Luppe = 10000 = 10^4
126         uint256 base = (_rTicketSum + 1).mul(10000) / SDIVIDER;
127         uint256 expo = base;
128         expo = expo.mul(expo).mul(expo); // ^3
129         expo = expo.mul(expo); // ^6
130         // div 10000^6
131         expo = expo / (10**24);
132 
133         if (expo > SAT) return 0;
134         return (SAT - expo).mul(_tAmount);
135     }
136 
137     function getNewEndTime(uint256 toAddTime, uint256 slideEndTime, uint256 fixedEndTime)
138         public
139         view
140         returns(uint256)
141     {
142         uint256 _slideEndTime = (slideEndTime).add(toAddTime);
143         uint256 timeout = _slideEndTime.sub(block.timestamp);
144         // timeout capped at TIMEOUT1
145         if (timeout > TIMEOUT1) timeout = TIMEOUT1;
146         _slideEndTime = (block.timestamp).add(timeout);
147         // Capped at fixedEndTime
148         if (_slideEndTime > fixedEndTime)  return fixedEndTime;
149         return _slideEndTime;
150     }
151 
152     // get random in range [1, _range] with _seed
153     function getRandom(uint256 _seed, uint256 _range)
154         public
155         pure
156         returns(uint256)
157     {
158         if (_range == 0) return _seed;
159         return (_seed % _range) + 1;
160     }
161 
162 
163     function getEarlyIncomeMul(uint256 _ticketSum)
164         public
165         pure
166         returns(uint256)
167     {
168         // Early-Multiplier = 1 + PBASE / (1 + PMULTI * ((Current No. of LT)/RDIVIDER)^6)
169         uint256 base = _ticketSum * ZOOM / RDIVIDER;
170         uint256 expo = base.mul(base).mul(base); //^3
171         expo = expo.mul(expo) / (ZOOM**6); //^6
172         return (1 + PBASE / (1 + expo.mul(PMULTI)));
173     }
174 
175     // get reveiced Tickets, based on current round ticketSum
176     function getTAmount(uint256 _ethAmount, uint256 _ticketSum) 
177         public
178         pure
179         returns(uint256)
180     {
181         uint256 _tPrice = getTPrice(_ticketSum);
182         return _ethAmount.div(_tPrice);
183     }
184 
185     // Lotto-Multiplier = 1 + LBase * (Current No. of Tickets / PDivider)^6
186     function getTMul(uint256 _ticketSum) // Unit Wei
187         public
188         pure
189         returns(uint256)
190     {
191         uint256 base = _ticketSum * ZOOM / PDIVIDER;
192         uint256 expo = base.mul(base).mul(base);
193         expo = expo.mul(expo); // ^6
194         return 1 + expo.mul(LBase) / (10**18);
195     }
196 
197     // get ticket price, based on current round ticketSum
198     //unit in ETH, no need / zoom^6
199     function getTPrice(uint256 _ticketSum)
200         public
201         pure
202         returns(uint256)
203     {
204         uint256 base = (_ticketSum + 1).mul(ZOOM) / PDIVIDER;
205         uint256 expo = base;
206         expo = expo.mul(expo).mul(expo); // ^3
207         expo = expo.mul(expo); // ^6
208         uint256 tPrice = SLP + expo / PN;
209         return tPrice;
210     }
211 
212     // get weight of slot, chance to win grandPot
213     function getSlotWeight(uint256 _ethAmount, uint256 _ticketSum)
214         public
215         pure
216         returns(uint256)
217     {
218         uint256 _tAmount = getTAmount(_ethAmount, _ticketSum);
219         uint256 _tMul = getTMul(_ticketSum);
220         return (_tAmount).mul(_tMul);
221     }
222 
223     // used to draw grandpot results
224     // weightRange = roundWeight * grandpot / (grandpot - initGrandPot)
225     // grandPot = initGrandPot + round investedSum(for grandPot)
226     function getWeightRange(uint256 grandPot, uint256 initGrandPot, uint256 curRWeight)
227         public
228         pure
229         returns(uint256)
230     {
231         //calculate round grandPot-investedSum
232         uint256 grandPotInvest = grandPot - initGrandPot;
233         if (grandPotInvest == 0) return 8;
234         uint256 zoomMul = grandPot * ZOOM / grandPotInvest;
235         uint256 weightRange = zoomMul * curRWeight / ZOOM;
236         if (weightRange < curRWeight) weightRange = curRWeight;
237         return weightRange;
238     }
239 }
240 
241 interface F2mInterface {
242     function joinNetwork(address[6] _contract) public;
243     // one time called
244     function disableRound0() public;
245     function activeBuy() public;
246     // Dividends from all sources (DApps, Donate ...)
247     function pushDividends() public payable;
248     /**
249      * Converts all of caller's dividends to tokens.
250      */
251     //function reinvest() public;
252     //function buy() public payable;
253     function buyFor(address _buyer) public payable;
254     function sell(uint256 _tokenAmount) public;
255     function exit() public;
256     function devTeamWithdraw() public returns(uint256);
257     function withdrawFor(address sender) public returns(uint256);
258     function transfer(address _to, uint256 _tokenAmount) public returns(bool);
259     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
260     function setAutoBuy() public;
261     /*==========================================
262     =            public FUNCTIONS            =
263     ==========================================*/
264     // function totalEthBalance() public view returns(uint256);
265     function ethBalance(address _address) public view returns(uint256);
266     function myBalance() public view returns(uint256);
267     function myEthBalance() public view returns(uint256);
268 
269     function swapToken() public;
270     function setNewToken(address _newTokenAddress) public;
271 }
272 
273 interface BankInterface {
274     function joinNetwork(address[6] _contract) public;
275     // Core functions
276     function pushToBank(address _player) public payable;
277 }
278 
279 
280 interface DevTeamInterface {
281     function setF2mAddress(address _address) public;
282     function setLotteryAddress(address _address) public;
283     function setCitizenAddress(address _address) public;
284     function setBankAddress(address _address) public;
285     function setRewardAddress(address _address) public;
286     function setWhitelistAddress(address _address) public;
287 
288     function setupNetwork() public;
289 }
290 
291 interface LotteryInterface {
292     function joinNetwork(address[6] _contract) public;
293     // call one time
294     function activeFirstRound() public;
295     // Core Functions
296     function pushToPot() public payable;
297     function finalizeable() public view returns(bool);
298     // bounty
299     function finalize() public;
300     function buy(string _sSalt) public payable;
301     function buyFor(string _sSalt, address _sender) public payable;
302     //function withdraw() public;
303     function withdrawFor(address _sender) public returns(uint256);
304 
305     function getRewardBalance(address _buyer) public view returns(uint256);
306     function getTotalPot() public view returns(uint256);
307     // EarlyIncome
308     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
309     // included claimed amount
310     // function getEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
311     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
312     // function getCurEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
313     function getCurRoundId() public view returns(uint256);
314     // set endRound, prepare to upgrade new version
315     function setLastRound(uint256 _lastRoundId) public;
316     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
317     function cashoutable(address _address) public view returns(bool);
318     function isLastRound() public view returns(bool);
319 }
320 
321 /**
322  * @title SafeMath
323  * @dev Math operations with safety checks that revert on error
324  */
325 library SafeMath {
326     int256 constant private INT256_MIN = -2**255;
327 
328     /**
329     * @dev Multiplies two unsigned integers, reverts on overflow.
330     */
331     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
332         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
333         // benefit is lost if 'b' is also tested.
334         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
335         if (a == 0) {
336             return 0;
337         }
338 
339         uint256 c = a * b;
340         require(c / a == b);
341 
342         return c;
343     }
344 
345     /**
346     * @dev Multiplies two signed integers, reverts on overflow.
347     */
348     function mul(int256 a, int256 b) internal pure returns (int256) {
349         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350         // benefit is lost if 'b' is also tested.
351         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
352         if (a == 0) {
353             return 0;
354         }
355 
356         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
357 
358         int256 c = a * b;
359         require(c / a == b);
360 
361         return c;
362     }
363 
364     /**
365     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
366     */
367     function div(uint256 a, uint256 b) internal pure returns (uint256) {
368         // Solidity only automatically asserts when dividing by 0
369         require(b > 0);
370         uint256 c = a / b;
371         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
372 
373         return c;
374     }
375 
376     /**
377     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
378     */
379     function div(int256 a, int256 b) internal pure returns (int256) {
380         require(b != 0); // Solidity only automatically asserts when dividing by 0
381         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
382 
383         int256 c = a / b;
384 
385         return c;
386     }
387 
388     /**
389     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
390     */
391     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
392         require(b <= a);
393         uint256 c = a - b;
394 
395         return c;
396     }
397 
398     /**
399     * @dev Subtracts two signed integers, reverts on overflow.
400     */
401     function sub(int256 a, int256 b) internal pure returns (int256) {
402         int256 c = a - b;
403         require((b >= 0 && c <= a) || (b < 0 && c > a));
404 
405         return c;
406     }
407 
408     /**
409     * @dev Adds two unsigned integers, reverts on overflow.
410     */
411     function add(uint256 a, uint256 b) internal pure returns (uint256) {
412         uint256 c = a + b;
413         require(c >= a);
414 
415         return c;
416     }
417 
418     /**
419     * @dev Adds two signed integers, reverts on overflow.
420     */
421     function add(int256 a, int256 b) internal pure returns (int256) {
422         int256 c = a + b;
423         require((b >= 0 && c >= a) || (b < 0 && c < a));
424 
425         return c;
426     }
427 
428     /**
429     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
430     * reverts when dividing by zero.
431     */
432     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
433         require(b != 0);
434         return a % b;
435     }
436 }
437 
438 contract Citizen {
439     using SafeMath for uint256;
440 
441     event Register(address indexed _member, address indexed _ref);
442 
443     modifier withdrawRight(){
444         require((msg.sender == address(bankContract)), "Bank only");
445         _;
446     }
447 
448     modifier onlyAdmin() {
449         require(msg.sender == devTeam, "admin required");
450         _;
451     }
452 
453     modifier notRegistered(){
454         require(!isCitizen[msg.sender], "already exist");
455         _;
456     }
457 
458     modifier registered(){
459         require(isCitizen[msg.sender], "must be a citizen");
460         _;
461     }
462 
463     struct Profile{
464         uint256 id;
465         uint256 username;
466         uint256 refWallet;
467         address ref;
468         address[] refTo;
469         uint256 totalChild;
470         uint256 donated;
471         uint256 treeLevel;
472         // logs
473         uint256 totalSale;
474         uint256 allRoundRefIncome;
475         mapping(uint256 => uint256) roundRefIncome;
476         mapping(uint256 => uint256) roundRefWallet;
477     }
478 
479     //bool public oneWayTicket = true;
480     mapping (address => Profile) public citizen;
481     mapping (address => bool) public isCitizen;
482     mapping (uint256 => address) public idAddress;
483     mapping (uint256 => address) public usernameAddress;
484 
485     mapping (uint256 => address[]) levelCitizen;
486 
487     BankInterface bankContract;
488     LotteryInterface lotteryContract;
489     F2mInterface f2mContract;
490     address devTeam;
491 
492     uint256 citizenNr;
493     uint256 lastLevel;
494 
495     // logs
496     mapping(uint256 => uint256) public totalRefByRound;
497     uint256 public totalRefAllround;
498 
499     constructor (address _devTeam)
500         public
501     {
502         DevTeamInterface(_devTeam).setCitizenAddress(address(this));
503         devTeam = _devTeam;
504 
505         // first citizen is the development team
506         citizenNr = 1;
507         idAddress[1] = devTeam;
508         isCitizen[devTeam] = true;
509         //root => self ref
510         citizen[devTeam].ref = devTeam;
511         // username rules bypass
512         uint256 _username = Helper.stringToUint("f2m");
513         citizen[devTeam].username = _username;
514         usernameAddress[_username] = devTeam; 
515         citizen[devTeam].id = 1;
516         citizen[devTeam].treeLevel = 1;
517         levelCitizen[1].push(devTeam);
518         lastLevel = 1;
519     }
520 
521     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
522     function joinNetwork(address[6] _contract)
523         public
524     {
525         require(address(lotteryContract) == 0,"already setup");
526         f2mContract = F2mInterface(_contract[0]);
527         bankContract = BankInterface(_contract[1]);
528         lotteryContract = LotteryInterface(_contract[3]);
529     }
530 
531     /*----------  WRITE FUNCTIONS  ----------*/
532     function updateTotalChild(address _address)
533         private
534     {
535         address _member = _address;
536         while(_member != devTeam) {
537             _member = getRef(_member);
538             citizen[_member].totalChild ++;
539         }
540     }
541 
542     function register(string _sUsername, address _ref)
543         public
544         notRegistered()
545     {
546         require(Helper.validUsername(_sUsername), "invalid username");
547         address sender = msg.sender;
548         uint256 _username = Helper.stringToUint(_sUsername);
549         require(usernameAddress[_username] == 0x0, "username already exist");
550         usernameAddress[_username] = sender;
551         //ref must be a citizen, else ref = devTeam
552         address validRef = isCitizen[_ref] ? _ref : devTeam;
553 
554         //Welcome new Citizen
555         isCitizen[sender] = true;
556         citizen[sender].username = _username;
557         citizen[sender].ref = validRef;
558         citizenNr++;
559 
560         idAddress[citizenNr] = sender;
561         citizen[sender].id = citizenNr;
562         
563         uint256 refLevel = citizen[validRef].treeLevel;
564         if (refLevel == lastLevel) lastLevel++;
565         citizen[sender].treeLevel = refLevel + 1;
566         levelCitizen[refLevel + 1].push(sender);
567         //add child
568         citizen[validRef].refTo.push(sender);
569         updateTotalChild(sender);
570         emit Register(sender, validRef);
571     }
572 
573     function updateUsername(string _sNewUsername)
574         public
575         registered()
576     {
577         require(Helper.validUsername(_sNewUsername), "invalid username");
578         address sender = msg.sender;
579         uint256 _newUsername = Helper.stringToUint(_sNewUsername);
580         require(usernameAddress[_newUsername] == 0x0, "username already exist");
581         uint256 _oldUsername = citizen[sender].username;
582         citizen[sender].username = _newUsername;
583         usernameAddress[_oldUsername] = 0x0;
584         usernameAddress[_newUsername] = sender;
585     }
586 
587     //Sources: Token contract, DApps
588     function pushRefIncome(address _sender)
589         public
590         payable
591     {
592         uint256 curRoundId = lotteryContract.getCurRoundId();
593         uint256 _amount = msg.value;
594         address sender = _sender;
595         address ref = getRef(sender);
596         // logs
597         citizen[sender].totalSale += _amount;
598         totalRefAllround += _amount;
599         totalRefByRound[curRoundId] += _amount;
600         // push to root
601         // lower level cost less gas
602         while (sender != devTeam) {
603             _amount = _amount / 2;
604             citizen[ref].refWallet = _amount.add(citizen[ref].refWallet);
605             citizen[ref].roundRefIncome[curRoundId] += _amount;
606             citizen[ref].allRoundRefIncome += _amount;
607             sender = ref;
608             ref = getRef(sender);
609         }
610         citizen[sender].refWallet = _amount.add(citizen[ref].refWallet);
611         // devTeam Logs
612         citizen[sender].roundRefIncome[curRoundId] += _amount;
613         citizen[sender].allRoundRefIncome += _amount;
614     }
615 
616     function withdrawFor(address sender) 
617         public
618         withdrawRight()
619         returns(uint256)
620     {
621         uint256 amount = citizen[sender].refWallet;
622         if (amount == 0) return 0;
623         citizen[sender].refWallet = 0;
624         bankContract.pushToBank.value(amount)(sender);
625         return amount;
626     }
627 
628     function devTeamWithdraw()
629         public
630         onlyAdmin()
631     {
632         uint256 _amount = citizen[devTeam].refWallet;
633         if (_amount == 0) return;
634         devTeam.transfer(_amount);
635         citizen[devTeam].refWallet = 0;
636     }
637 
638     function devTeamReinvest()
639         public
640         returns(uint256)
641     {
642         address sender = msg.sender;
643         require(sender == address(f2mContract), "only f2m contract");
644         uint256 _amount = citizen[devTeam].refWallet;
645         citizen[devTeam].refWallet = 0;
646         address(f2mContract).transfer(_amount);
647         return _amount;
648     }
649 
650     /*----------  READ FUNCTIONS  ----------*/
651 
652     function getTotalChild(address _address)
653         public
654         view
655         returns(uint256)
656     {
657         return citizen[_address].totalChild;
658     }
659 
660     function getAllRoundRefIncome(address _address)
661         public
662         view
663         returns(uint256)
664     {
665         return citizen[_address].allRoundRefIncome;
666     }
667 
668     function getRoundRefIncome(address _address, uint256 _rId)
669         public
670         view
671         returns(uint256)
672     {
673         return citizen[_address].roundRefIncome[_rId];
674     }
675 
676     function getRefWallet(address _address)
677         public
678         view
679         returns(uint256)
680     {
681         return citizen[_address].refWallet;
682     }
683 
684     function getAddressById(uint256 _id)
685         public
686         view
687         returns (address)
688     {
689         return idAddress[_id];
690     }
691 
692     function getAddressByUserName(string _username)
693         public
694         view
695         returns (address)
696     {
697         return usernameAddress[Helper.stringToUint(_username)];
698     }
699 
700     function exist(string _username)
701         public
702         view
703         returns (bool)
704     {
705         return usernameAddress[Helper.stringToUint(_username)] != 0x0;
706     }
707 
708     function getId(address _address)
709         public
710         view
711         returns (uint256)
712     {
713         return citizen[_address].id;
714     }
715 
716     function getUsername(address _address)
717         public
718         view
719         returns (string)
720     {
721         if (!isCitizen[_address]) return "";
722         return Helper.uintToString(citizen[_address].username);
723     }
724 
725     function getUintUsername(address _address)
726         public
727         view
728         returns (uint256)
729     {
730         return citizen[_address].username;
731     }
732 
733     function getRef(address _address)
734         public
735         view
736         returns (address)
737     {
738         return citizen[_address].ref == 0x0 ? devTeam : citizen[_address].ref;
739     }
740 
741     function getRefTo(address _address)
742         public
743         view
744         returns (address[])
745     {
746         return citizen[_address].refTo;
747     }
748 
749     function getRefToById(address _address, uint256 _id)
750         public
751         view
752         returns (address, string, uint256, uint256, uint256, uint256)
753     {
754         address _refTo = citizen[_address].refTo[_id];
755         return (
756             _refTo,
757             Helper.uintToString(citizen[_refTo].username),
758             citizen[_refTo].treeLevel,
759             citizen[_refTo].refTo.length,
760             citizen[_refTo].refWallet,
761             citizen[_refTo].totalSale
762             );
763     }
764 
765     function getRefToLength(address _address)
766         public
767         view
768         returns (uint256)
769     {
770         return citizen[_address].refTo.length;
771     }
772 
773     function getLevelCitizenLength(uint256 _level)
774         public
775         view
776         returns (uint256)
777     {
778         return levelCitizen[_level].length;
779     }
780 
781     function getLevelCitizenById(uint256 _level, uint256 _id)
782         public
783         view
784         returns (address)
785     {
786         return levelCitizen[_level][_id];
787     }
788 
789     function getCitizenLevel(address _address)
790         public
791         view
792         returns (uint256)
793     {
794         return citizen[_address].treeLevel;
795     }
796 
797     function getLastLevel()
798         public
799         view
800         returns(uint256)
801     {
802         return lastLevel;
803     }
804 
805 }