1 pragma solidity ^ 0.4.21;
2 
3 /**
4  *   @title SafeMath
5  *   @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns(uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns(uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 /**
35  *   @title ERC20
36  *   @dev Standart ERC20 token interface
37  */
38 contract ERC20 {
39     function balanceOf(address _owner) public constant returns(uint256);
40     function transfer(address _to, uint256 _value) public returns(bool);
41     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
42     function approve(address _spender, uint256 _value) public returns(bool);
43     function allowance(address _owner, address _spender) public constant returns(uint256);
44     mapping(address => uint256) balances;
45     mapping(address => mapping(address => uint256)) allowed;
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 /**
52  *   @dev CRET token contract
53  */
54 contract WbcToken is ERC20 {
55     using SafeMath for uint256;
56     string public name = "WhizBizCoin";
57     string public symbol = "WB";
58     uint256 public decimals = 18;
59     uint256 public totalSupply = 888000000 * 1e18;
60     uint256 public timeStamp = 0;
61     uint256 constant fundPartYear = 44400000 * 1e18; 
62     uint256 constant trioPartYear = 8880000 * 1e18; //1% of tokens for CrowdSale, Film Comany and Investors in one year for 6 years
63     uint256 constant minimumAge = 30 days; // minimum age for coins
64     uint256 constant oneYear = 360 days;
65     uint256 public minted = 0;
66     address public teamCSN;
67     address public teamFilmCompany;
68     address public teamInvestors;
69     address public teamFund;
70     address public manager;
71     address public reserveFund;
72     
73     struct transferStruct{
74     uint128 amount;
75     uint64 time;
76     }
77     
78     mapping(uint8 => bool) trioChecker;
79     mapping(uint8 => bool) fundChecker;
80     mapping(uint256 => bool) priceChecker;
81     mapping(address => transferStruct[]) transferSt;
82     mapping(uint256 => uint256) coinPriceNow;
83 
84     // Ico contract address
85     address public owner;
86 
87     // Allows execution by the owner only
88     modifier onlyOwner {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     modifier onlyManager {
94         require(msg.sender == manager);
95         _;
96     }
97     
98     
99     
100     constructor (address _owner, address _teamCSN, address _teamFilmCompany, address _teamInvestors, address _fund, address _manager, address _reserveFund) public {
101         owner = _owner;
102         teamCSN = _teamCSN;
103         teamFilmCompany = _teamFilmCompany;
104         teamInvestors = _teamInvestors;
105         teamFund = _fund;
106         manager = _manager;
107         reserveFund = _reserveFund;
108 
109     }
110     
111     
112     function doTimeStamp(uint256 _value) external onlyOwner {
113         timeStamp = _value;
114     }
115     
116     
117 
118    /**
119     *   @dev Mint tokens
120     *   @param _investor     address the tokens will be issued to
121     *   @param _value        number of tokens
122     */
123     function mintTokens(address _investor, uint256 _value) external onlyOwner {
124         require(_value > 0);
125         require(minted.add(_value) <= totalSupply);
126         balances[_investor] = balances[_investor].add(_value);
127         minted = minted.add(_value);
128         transferSt[_investor].push(transferStruct(uint128(_value),uint64(now)));
129         emit Transfer(0x0, _investor, _value);
130     }
131     
132     
133     
134     function mintTrio() external onlyManager {
135         require(now > (timeStamp + 360 days));
136         if(now > (timeStamp + 360 days) && now <= (timeStamp + 720 days)){
137             require(trioChecker[1] != true);
138             partingTrio(1);
139         }
140         if(now > (timeStamp + 720 days) && now <= (timeStamp + 1080 days)){
141             require(trioChecker[2] != true);
142             partingTrio(2);
143         }
144         if(now > (timeStamp + 1080 days) && now <= (timeStamp + 1440 days)){
145             require(trioChecker[3] != true);
146             partingTrio(3);
147         }
148         if(now > (timeStamp + 1440 days) && now <= (timeStamp + 1800 days)){
149             require(trioChecker[4] != true);
150             partingTrio(4);
151         }
152         if(now > (timeStamp + 1800 days) && now <= (timeStamp + 2160 days)){
153             require(trioChecker[5] != true);
154             partingTrio(5);
155         }
156         if(now > (timeStamp + 2160 days) && now <= (timeStamp + 2520 days)){
157             require(trioChecker[6] != true);
158             partingTrio(6);
159         }
160     }
161     
162     
163     function mintFund() external onlyManager {
164         require(now > (timeStamp + 360 days));
165         if(now > (timeStamp + 360 days) && now <= (timeStamp + 720 days)){
166             require(fundChecker[1] != true);
167             partingFund(1);
168         }
169         if(now > (timeStamp + 720 days) && now <= (timeStamp + 1080 days)){
170             require(fundChecker[2] != true);
171             partingFund(2);
172         }
173         if(now > (timeStamp + 1080 days) && now <= (timeStamp + 1440 days)){
174             require(fundChecker[3] != true);
175             partingFund(3);
176         }
177         if(now > (timeStamp + 1440 days) && now <= (timeStamp + 1800 days)){
178             require(fundChecker[4] != true);
179             partingFund(4);
180         }
181         if(now > (timeStamp + 1800 days) && now <= (timeStamp + 2160 days)){
182             require(fundChecker[5] != true);
183             partingFund(5);
184         }
185         if(now > (timeStamp + 2160 days) && now <= (timeStamp + 2520 days)){
186             require(fundChecker[6] != true);
187             partingFund(6);
188         }
189         if(now > (timeStamp + 2520 days) && now <= (timeStamp + 2880 days)){
190             require(fundChecker[7] != true);
191             partingFund(7);
192         }
193     
194     }
195     
196     
197     function partingFund(uint8 _x) internal {
198         require(_x > 0 && _x <= 7);
199         balances[teamFund] = balances[teamFund].add(fundPartYear);
200         fundChecker[_x] = true;
201         minted = minted.add(fundPartYear);
202         transferSt[teamFund].push(transferStruct(uint128(fundPartYear),uint64(now)));
203             
204         emit Transfer(0x0, teamFund, fundPartYear);
205     }
206     
207     
208     function partingTrio(uint8 _x) internal {
209         require(_x > 0 && _x <= 6);
210         balances[teamCSN] = balances[teamCSN].add(trioPartYear);
211         balances[teamFilmCompany] = balances[teamFilmCompany].add(trioPartYear);
212         balances[teamInvestors] = balances[teamInvestors].add(trioPartYear);
213         trioChecker[_x] = true;
214         minted = minted.add(trioPartYear.mul(3));
215         transferSt[teamCSN].push(transferStruct(uint128(trioPartYear),uint64(now)));
216         transferSt[teamFilmCompany].push(transferStruct(uint128(trioPartYear),uint64(now)));
217         transferSt[teamInvestors].push(transferStruct(uint128(trioPartYear),uint64(now)));
218             
219         emit Transfer(0x0, teamCSN, trioPartYear);
220         emit Transfer(0x0, teamFilmCompany, trioPartYear);
221         emit Transfer(0x0, teamInvestors, trioPartYear);
222     }
223 
224 
225    /**
226     *   @dev Get balance of investor
227     *   @param _owner        investor's address
228     *   @return              balance of investor
229     */
230     function balanceOf(address _owner) public constant returns(uint256) {
231       return balances[_owner];
232     }
233 
234    /**
235     *   @return true if the transfer was successful
236     */
237     function transfer(address _to, uint256 _amount) public returns(bool) {
238         if(msg.sender == _to) {return POSMint();}
239         balances[msg.sender] = balances[msg.sender].sub(_amount);
240         balances[_to] = balances[_to].add(_amount);
241         emit Transfer(msg.sender, _to, _amount);
242         if(transferSt[msg.sender].length > 0) {delete transferSt[msg.sender];}
243         uint64 _now = uint64(now);
244         transferSt[msg.sender].push(transferStruct(uint128(balances[msg.sender]),_now));
245         transferSt[_to].push(transferStruct(uint128(_amount),_now));
246         return true;
247     }
248 
249    /**
250     *   @return true if the transfer was successful
251     */
252     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool) {
253         require(_amount <= allowed[_from][msg.sender]);
254         require(_amount <= balances[_from]);
255         balances[_from] = balances[_from].sub(_amount);
256         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
257         balances[_to] = balances[_to].add(_amount);
258         emit Transfer(_from, _to, _amount);
259         if(transferSt[_from].length > 0) {delete transferSt[_from];}
260         uint64 _now = uint64(now);
261         transferSt[_from].push(transferStruct(uint128(balances[_from]),_now));
262         transferSt[_to].push(transferStruct(uint128(_amount),_now));
263         return true;
264     }
265     
266     
267     function POSMint() internal returns (bool) {
268         require(now > (timeStamp + minimumAge));
269         if(balances[msg.sender] <= 0) {return false;}
270         if(transferSt[msg.sender].length <= 0) {return false;}
271 
272         uint256 _now = now;
273         uint256 _year = getYear();
274         uint256 _phase = getPhase(_year);
275         uint256 _coinsAmount = getCoinsAmount(msg.sender, _now);
276         if(_coinsAmount <= 0) {return false;}
277         uint256 _coinsPrice = getCoinPrice(_year, _phase);
278         if(_coinsPrice <= 0) {return false;}
279         uint256 reward = (_coinsAmount.mul(_coinsPrice)).div(100000);
280         if(reward <= 0) {return false;}
281         if(reward > 0) {require(minted.add(reward) <= totalSupply);}
282         minted = minted.add(reward);
283         balances[msg.sender] = balances[msg.sender].add(reward);
284         delete transferSt[msg.sender];
285         transferSt[msg.sender].push(transferStruct(uint128(balances[msg.sender]),uint64(now)));
286 
287         emit Transfer(0x0, msg.sender, reward);
288         return true;
289     }
290     
291     
292     function getCoinsAmount(address _address, uint _now) internal view returns (uint256) {
293         if(transferSt[_address].length <= 0) {return 0;}
294         uint256 Coins = 0;
295         for (uint256 i = 0; i < transferSt[_address].length; i++){
296             if( _now < uint(transferSt[_address][i].time).add(minimumAge) ) {return Coins;}
297             Coins = Coins.add(uint256(transferSt[_address][i].amount));
298         }
299         return Coins;
300     }
301     
302     
303     function getYear() internal view returns (uint256) {
304         require(timeStamp > 0);
305         for(uint256 i = 0; i <= 99; i++) {
306         if(now >= ((timeStamp + minimumAge).add((i.mul(oneYear)))) && now < ((timeStamp + minimumAge).add(((i+1).mul(oneYear))))) {
307             return (i);    // how many years gone
308             }
309         }
310         if(now >= ((timeStamp + minimumAge).add((oneYear.mul(100))))) {return (100);}
311     
312     }
313 
314 
315     function getPhase(uint256 _x) internal pure returns (uint256) {
316         require(_x >= 0);
317         if(_x >= 0 && _x < 3) {return 1;}
318         if(_x >= 3 && _x < 6) {return 2;}
319         if(_x >= 6 && _x < 9) {return 3;}
320         if(_x >= 9 && _x < 12) {return 4;}
321         if(_x >= 12) {return 5;}        // last phase which include 18*3 years
322     
323     }
324     
325     
326     function getMonthLimit(uint256 _x) internal pure returns (uint256) {
327         require(_x > 0 && _x <=5);
328         if(_x == 1) {return (2220000 * 1e18);} //limit in month in this phase for all
329         if(_x == 2) {return (1480000 * 1e18);}
330         if(_x == 3) {return (740000 * 1e18);}
331         if(_x == 4) {return (370000 * 1e18);}
332         if(_x == 5) {return (185000 * 1e18);}
333     }
334     
335  
336 
337     
338     function getCoinPrice(uint256 _year, uint256 _phase) internal returns (uint256) {
339     require(_year >= 0);
340     uint256 _monthLimit = getMonthLimit(_phase);
341     uint256 _sumToAdd = _year.mul(oneYear);
342     uint256 _monthInYear = _year.mul(12);
343 
344     for(uint256 i = 0; i <= 11; i++) {
345     if(now >= (timeStamp + minimumAge).add(_sumToAdd).add(minimumAge.mul(i)) && now < (timeStamp + minimumAge).add(_sumToAdd).add(minimumAge.mul(i+1))) {
346         uint256 _num = _monthInYear.add(i);
347         if(priceChecker[_num] != true) {
348             coinPriceNow[_num] = minted;
349             priceChecker[_num] = true;
350             return (_monthLimit.mul(100000)).div(minted);} 
351         if(priceChecker[_num] == true) {
352             return (_monthLimit.mul(100000)).div(coinPriceNow[_num]);}
353     }
354     }
355 }
356 
357    /**
358     *   @dev Allows another account/contract to spend some tokens on its behalf
359     * approve has to be called twice in 2 separate transactions - once to
360     *   change the allowance to 0 and secondly to change it to the new allowance value
361     *   @param _spender      approved address
362     *   @param _amount       allowance amount
363     *
364     *   @return true if the approval was successful
365     */
366     function approve(address _spender, uint256 _amount) public returns(bool) {
367         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
368         allowed[msg.sender][_spender] = _amount;
369         emit Approval(msg.sender, _spender, _amount);
370         return true;
371     }
372 
373    /**
374     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
375     *
376     *   @param _owner        the address which owns the funds
377     *   @param _spender      the address which will spend the funds
378     *
379     *   @return              the amount of tokens still avaible for the spender
380     */
381     function allowance(address _owner, address _spender) public constant returns(uint256) {
382         return allowed[_owner][_spender];
383     }
384 }
385 
386 
387 contract WbcICO {
388     using SafeMath for uint256;
389     
390     address public CSN; //
391     address public FilmCompany; //
392     address public Investors; //
393     address public Fund;
394     address public Manager; // Manager controls contract
395     address public Reserve;
396     address internal addressCompanion1;
397     address internal addressCompanion2;
398 
399     WbcToken public WBC;
400     
401     mapping(address => bool) public kyc;  // investor identification status
402     
403     // Possible ICO statuses
404     enum StatusICO {
405         Created,
406         Ico,
407         IcoFinished
408     }
409     
410     StatusICO statusICO;
411     
412     
413     /**
414     *   @dev Contract constructor function
415     */
416     constructor (
417         address _CSN,
418         address _FilmCompany,
419         address _Investors,
420         address _Fund,
421         address _Manager,
422         address _Reserve
423     )
424         public {
425         CSN = _CSN;
426         FilmCompany = _FilmCompany;
427         Investors = _Investors;
428         Fund = _Fund;
429         Manager = _Manager;
430         Reserve = _Reserve;
431         statusICO = StatusICO.Created;
432         WBC = new WbcToken(this, _CSN, _FilmCompany, _Investors, _Fund, _Manager, _Reserve);
433     }
434     
435  
436     
437 
438     // Token price parameters
439     uint256 public Rate_Eth = 700; // Rate USD per ETH
440     uint256 internal Tokens_Per_Dollar = 77; // WBC token per dollar multiplied on 10
441     uint256 internal Token_Price_For_Ten_Ether = Tokens_Per_Dollar.mul(Rate_Eth); // WBC token per ETH
442     uint256 constant trioPartIco = 5920000 * 1e18; //0.6% of tokens for CrowdSale, Film Comany and Investors
443     uint256 constant reservePart = 17760000 * 1e18; //2% or 17mln and 760k  for reserve fund
444     uint256 constant MAX_TO_SOLD = 88800000 * 1e18; // tokens for sale in ICO
445     uint256 public soldTotal;  // total sold
446 
447 
448 
449 
450     // Events Log
451 
452     event LogStartIco();
453     event LogFinishICO();
454     event LogBuyForInvestor(address investor, uint256 value);
455 
456 
457     // Modifiers
458     // Allows execution by the contract manager only
459     modifier managerOnly {
460         require(msg.sender == Manager);
461         _;
462     }
463     
464     // Allows execution by the companions only
465     modifier companionsOnly {
466         require(msg.sender == CSN || msg.sender == FilmCompany);
467         _;
468     }
469 
470     
471     
472     function currentStage() public view returns (string) {
473         if(statusICO == StatusICO.Created){return "Created";}
474         else if(statusICO == StatusICO.Ico){return "Ico";}
475         else if(statusICO == StatusICO.IcoFinished){return "IcoFinished";}
476     }
477 
478    /**
479     *   @dev Set rate of ETH and update token price
480     *   @param _RateEth       current ETH rate
481     */
482     function setRate(uint256 _RateEth) external managerOnly {
483         Rate_Eth = _RateEth;
484         Token_Price_For_Ten_Ether = Tokens_Per_Dollar.mul(_RateEth);
485     }
486     
487     
488     // passing KYC for investor
489     function passKYC(address _investor) external managerOnly {
490         kyc[_investor] = true;
491     }
492 
493 
494 
495    /**
496     *   @dev Start ICO
497     *   Set ICO status
498     */
499     
500     function startIco() external managerOnly {
501         require(statusICO == StatusICO.Created);
502         WBC.mintTokens(CSN, trioPartIco);
503         WBC.mintTokens(FilmCompany, trioPartIco);
504         WBC.mintTokens(Investors, trioPartIco);
505         WBC.mintTokens(Reserve, reservePart);
506         statusICO = StatusICO.Ico;
507         emit LogStartIco();
508     }
509 
510 
511    /**
512     *   @dev Finish ICO and emit tokens for bounty advisors and team
513     */
514     function finishIco() external managerOnly {
515         require(statusICO == StatusICO.Ico);
516         statusICO = StatusICO.IcoFinished;
517         WBC.doTimeStamp(now);
518         emit LogFinishICO();
519     }
520 
521 
522 
523 
524    /**
525     *   @dev Fallback function calls function to create tokens
526     *        when investor sends ETH to address of ICO contract
527     */
528     function() external payable {
529         require(msg.value > 0);
530         require(kyc[msg.sender]);
531         createTokens(msg.sender, (msg.value.mul(Token_Price_For_Ten_Ether)).div(10)); // divide by 10 because multiplied "Per Dollar" on 10
532     }
533     
534    
535     
536     function buyToken() external payable {
537         require(msg.value > 0);
538         require(kyc[msg.sender]);
539         createTokens(msg.sender, (msg.value.mul(Token_Price_For_Ten_Ether)).div(10)); // divide by 10 because multiplied "Per Dollar" on 10
540     }
541     
542     
543 
544 
545     function buyForInvestor(address _investor, uint256 _value) external managerOnly {
546         uint256 decvalue = _value.mul(1 ether);
547         require(_value > 0);
548         require(kyc[_investor]);
549         require(statusICO != StatusICO.IcoFinished);
550         require(statusICO != StatusICO.Created);
551         require(soldTotal.add(decvalue) <= MAX_TO_SOLD);
552         WBC.mintTokens(_investor, decvalue);
553         soldTotal = soldTotal.add(decvalue);
554         emit LogBuyForInvestor(_investor, _value);
555     }
556     
557 
558 
559     function createTokens(address _investor, uint256 _value) internal {
560         require(_value > 0);
561         require(soldTotal.add(_value) <= MAX_TO_SOLD);
562         require(statusICO != StatusICO.IcoFinished);
563         require(statusICO != StatusICO.Created);
564         WBC.mintTokens(_investor, _value);
565         soldTotal = soldTotal.add(_value);
566     }
567     
568     
569     /**
570     *   @dev Allows Companions to add consensus address
571     */
572     function consensusAddress(address _investor) external companionsOnly {
573         require(CSN != 0x0 && FilmCompany != 0x0);
574         if(msg.sender == CSN) {
575             addressCompanion1 = _investor;
576         } else {
577             addressCompanion2 = _investor;
578         }
579     }
580 
581 
582 
583    /**
584     *   @dev Allows Companions withdraw investments
585     */
586     function takeInvestments() external companionsOnly {
587         require(addressCompanion1 != 0x0 && addressCompanion2 != 0x0);
588         require(addressCompanion1 == addressCompanion2);
589 
590         addressCompanion1.transfer(address(this).balance);
591         
592         }
593         
594     }
595 
596 
597 // gexabyte.com