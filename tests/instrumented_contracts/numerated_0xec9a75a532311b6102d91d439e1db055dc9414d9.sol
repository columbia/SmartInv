1 pragma solidity ^0.4.0;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function Owned() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     
22     function acceptOwnership() public {
23         require(msg.sender == newOwner);
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26         newOwner = address(0);
27     }
28 }
29 
30 contract PD88 is Owned {
31     
32     modifier isHuman() {
33         address _addr = msg.sender;
34         require (_addr == tx.origin);
35         
36         uint256 _codeLength;
37         
38         assembly {_codeLength := extcodesize(_addr)}
39         require(_codeLength == 0, "sorry humans only");
40         _;
41     }
42     
43     //Round Global Info
44     uint public Round = 1;
45     mapping(uint => uint) public RoundDonation;
46     mapping(uint => uint) public RoundETH; // Pot
47     mapping(uint => uint) public RoundTime;
48     mapping(uint => uint) public RoundPayMask;
49     mapping(uint => address) public RoundLastDonationMan;
50     
51     //Globalinfo
52     uint256 public Luckybuy;
53     
54     //Round Personal Info
55     mapping(uint => mapping(address => uint)) public RoundMyDonation;
56     mapping(uint => mapping(address => uint)) public RoundMyPayMask;
57     mapping(address => uint) public MyreferredRevenue;
58     
59     //Product
60     uint public product1_pot;
61     uint public product2_pot;
62     uint public product3_pot;
63     uint public product4_pot;
64     
65     uint public product1_sell;
66     uint public product2_sell;
67     uint public product3_sell;
68     uint public product4_sell;
69     
70     uint public product1_luckybuyTracker;
71     uint public product2_luckybuyTracker;
72     uint public product3_luckybuyTracker;
73     uint public product4_luckybuyTracker;
74     
75     uint public product1 = 0.03 ether;
76     uint public product2 = 0.05 ether;
77     uint public product3 = 0.09 ether;
78     uint public product4 = 0.01 ether;
79     
80     uint256 private RoundIncrease = 11 seconds; 
81     uint256 constant private RoundMaxTime = 720 minutes; 
82     
83     uint public lasttimereduce = 0;
84     
85     //Owner fee
86     uint256 public onwerfee;
87     
88     using SafeMath for *;
89     using CalcLong for uint256;
90     
91     event winnerEvent(address winnerAddr, uint256 newPot, uint256 round);
92     event luckybuyEvent(address luckyAddr, uint256 amount, uint256 round, uint product);
93     event buydonationEvent(address Addr, uint256 Donationsamount, uint256 ethvalue, uint256 round, address ref);
94     event referredEvent(address Addr, address RefAddr, uint256 ethvalue);
95     
96     event withdrawEvent(address Addr, uint256 ethvalue, uint256 Round);
97     event withdrawRefEvent(address Addr, uint256 ethvalue);
98     event withdrawOwnerEvent(uint256 ethvalue);
99 
100 
101     function getDonationPrice() public view returns(uint256)
102     {  
103         return ( (RoundDonation[Round].add(1000000000000000000)).ethRec(1000000000000000000) );
104     }
105     
106     //Get My Revenue
107     function getMyRevenue(uint _round) public view returns(uint256)
108     {
109         return(  (((RoundPayMask[_round]).mul(RoundMyDonation[_round][msg.sender])) / (1000000000000000000)).sub(RoundMyPayMask[_round][msg.sender])  );
110     }
111     
112     //Get Time Left
113     function getTimeLeft() public view returns(uint256)
114     {
115         if(RoundTime[Round] == 0 || RoundTime[Round] < now) 
116             return 0;
117         else 
118             return( (RoundTime[Round]).sub(now) );
119     }
120 
121     function updateTimer(uint256 _donations) private
122     {
123         if(RoundTime[Round] == 0)
124             RoundTime[Round] = RoundMaxTime.add(now);
125         
126         uint _newTime = (((_donations) / (1000000000000000000)).mul(RoundIncrease)).add(RoundTime[Round]);
127         
128         // compare to max and set new end time
129         if (_newTime < (RoundMaxTime).add(now))
130             RoundTime[Round] = _newTime;
131         else
132             RoundTime[Round] = RoundMaxTime.add(now);
133     }
134 
135 
136     function buyDonation(address referred, uint8 product) public isHuman() payable {
137         
138         require(msg.value >= 1000000000, "pocket lint: not a valid currency");
139         require(msg.value <= 100000000000000000000000, "no vitalik, no");
140         
141         uint8 product_ = 1;
142         if(product == 1) {
143             require(msg.value >= product1 && msg.value % product1 == 0);
144             product1_sell += msg.value / product1;
145             product1_pot += msg.value.mul(20) / 100;
146             product1_luckybuyTracker++;
147             product_ = 1;
148         } else if(product == 2) {
149             require(msg.value >= product2 && msg.value % product2 == 0);
150             product2_sell += msg.value / product2;
151             product2_pot += msg.value.mul(20) / 100;
152             product2_luckybuyTracker++;
153             product_ = 2;
154         } else if(product == 3) {
155             require(msg.value >= product3 && msg.value % product3 == 0);
156             product3_sell += msg.value / product3;
157             product3_pot += msg.value.mul(20) / 100;
158             product3_luckybuyTracker++;
159             product_ = 3;
160         } else {
161             require(msg.value >= product4 && msg.value % product4 == 0);
162             product4_sell += msg.value / product4;
163             product4_pot += msg.value.mul(20) / 100;
164             product4_luckybuyTracker++;
165             product_ = 4;
166         }
167         
168 
169         //bought at least 1 whole key
170         uint256 _donations = (RoundETH[Round]).keysRec(msg.value);
171         uint256 _pearn;
172         require(_donations >= 1000000000000000000);
173         
174         require(RoundTime[Round] > now || RoundTime[Round] == 0);
175         
176         updateTimer(_donations);
177         
178         RoundDonation[Round] += _donations;
179         RoundMyDonation[Round][msg.sender] += _donations;
180 
181         if (referred != address(0) && referred != msg.sender)
182         {
183              _pearn = (((msg.value.mul(45) / 100).mul(1000000000000000000)) / (RoundDonation[Round])).mul(_donations)/ (1000000000000000000);
184 
185             onwerfee += (msg.value.mul(5) / 100);
186             RoundETH[Round] += msg.value.mul(20) / 100;
187             
188             MyreferredRevenue[referred] += (msg.value.mul(10) / 100);
189             
190             RoundPayMask[Round] += ((msg.value.mul(45) / 100).mul(1000000000000000000)) / (RoundDonation[Round]);
191             RoundMyPayMask[Round][msg.sender] = (((RoundPayMask[Round].mul(_donations)) / (1000000000000000000)).sub(_pearn)).add(RoundMyPayMask[Round][msg.sender]);
192 
193             emit referredEvent(msg.sender, referred, msg.value.mul(10) / 100);
194         } else {
195              _pearn = (((msg.value.mul(55) / 100).mul(1000000000000000000)) / (RoundDonation[Round])).mul(_donations)/ (1000000000000000000);
196 
197             RoundETH[Round] += msg.value.mul(20) / 100;
198 
199             onwerfee +=(msg.value.mul(5) / 100);
200             
201             RoundPayMask[Round] += ((msg.value.mul(55) / 100).mul(1000000000000000000)) / (RoundDonation[Round]);
202             RoundMyPayMask[Round][msg.sender] = (((RoundPayMask[Round].mul(_donations)) / (1000000000000000000)).sub(_pearn)).add(RoundMyPayMask[Round][msg.sender]);
203         }
204         
205         // airdrops
206 
207         if (luckyBuy(product_) == true)
208         {
209             
210             uint _temp = 0;
211             if(product_ == 1) {
212                 _temp = product1_pot;
213                 product1_pot = 0;
214                 product1_luckybuyTracker = 0;
215             } else if(product_ == 2) {
216                 _temp = product2_pot;
217                 product2_pot = 0;
218                 product2_luckybuyTracker = 0;
219             } else if(product_ == 3) {
220                 _temp = product3_pot;
221                 product3_pot = 0;
222                 product3_luckybuyTracker = 0;
223             } else {
224                 _temp = product4_pot;
225                 product4_pot = 0;
226                 product4_luckybuyTracker = 0;
227             }
228             
229             if(_temp != 0)
230                 msg.sender.transfer(_temp);
231                 
232             emit luckybuyEvent(msg.sender, _temp, Round,product_);
233         }
234         
235         
236         RoundLastDonationMan[Round] = msg.sender;
237         emit buydonationEvent(msg.sender, _donations, msg.value, Round, referred);
238     }
239     
240     function reducetime() isHuman() public {
241         require(now >= lasttimereduce + 12 hours);
242         lasttimereduce = now;
243         RoundIncrease -= 1 seconds;
244     }
245     
246     function win() isHuman() public {
247         require(now > RoundTime[Round] && RoundTime[Round] != 0);
248         
249         uint Round_ = Round;
250         Round++;
251         
252         //Round End 
253         RoundLastDonationMan[Round_].transfer(RoundETH[Round_].mul(80) / 100);
254         owner.transfer(RoundETH[Round_].mul(20) / 100);
255         
256         RoundIncrease = 11 seconds;
257         lasttimereduce = now;
258         emit winnerEvent(RoundLastDonationMan[Round_], RoundETH[Round_], Round_);
259     }
260     
261     //withdrawEarnings
262     function withdraw(uint _round) isHuman() public {
263         uint _revenue = getMyRevenue(_round);
264         uint _revenueRef = MyreferredRevenue[msg.sender];
265 
266         RoundMyPayMask[_round][msg.sender] += _revenue;
267         MyreferredRevenue[msg.sender] = 0;
268         
269         msg.sender.transfer(_revenue + _revenueRef); 
270         
271         emit withdrawRefEvent( msg.sender, _revenue);
272         emit withdrawEvent(msg.sender, _revenue, _round);
273     }
274     
275     function withdrawOwner()  public onlyOwner {
276         uint _revenue = onwerfee;
277         msg.sender.transfer(_revenue);    
278         onwerfee = 0;
279         emit withdrawOwnerEvent(_revenue);
280     }
281     
282     //LuckyBuy
283     function luckyBuy(uint8 product_) private view returns(bool)
284     {
285         uint256 seed = uint256(keccak256(abi.encodePacked(
286             
287             (block.timestamp).add
288             (block.difficulty).add
289             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
290             (block.gaslimit).add
291             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
292             (block.number)
293             
294         )));
295         
296         uint luckybuyTracker_;
297         
298         if(product_ == 1) {
299             luckybuyTracker_ = product1_luckybuyTracker;
300         } else if(product_ == 2) {
301             luckybuyTracker_ = product2_luckybuyTracker;
302         } else if(product_ == 3) {
303             luckybuyTracker_ = product3_luckybuyTracker;
304         } else {
305             luckybuyTracker_ = product4_luckybuyTracker;
306         }
307         
308         if((seed - ((seed / 1000) * 1000)) < luckybuyTracker_)
309             return(true);
310         else
311             return(false);
312     }
313     
314     function getFullround()public view returns(uint[] round,uint[] pot, address[] whowin,uint[] mymoney) {
315         uint[] memory whichRound = new uint[](Round);
316         uint[] memory totalPool = new uint[](Round);
317         address[] memory winner = new address[](Round);
318         uint[] memory myMoney = new uint[](Round);
319         uint counter = 0;
320 
321         for (uint i = 1; i <= Round; i++) {
322             whichRound[counter] = i;
323             totalPool[counter] = RoundETH[i];
324             winner[counter] = RoundLastDonationMan[i];
325             myMoney[counter] = getMyRevenue(i);
326             counter++;
327         }
328    
329         return (whichRound,totalPool,winner,myMoney);
330     }
331 }
332 
333 library CalcLong {
334     using SafeMath for *;
335     /**
336      * @dev calculates number of keys received given X eth 
337      * @param _curEth current amount of eth in contract 
338      * @param _newEth eth being spent
339      * @return amount of ticket purchased
340      */
341     function keysRec(uint256 _curEth, uint256 _newEth)
342         internal
343         pure
344         returns (uint256)
345     {
346         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
347     }
348     
349     /**
350      * @dev calculates amount of eth received if you sold X keys 
351      * @param _curKeys current amount of keys that exist 
352      * @param _sellKeys amount of keys you wish to sell
353      * @return amount of eth received
354      */
355     function ethRec(uint256 _curKeys, uint256 _sellKeys)
356         internal
357         pure
358         returns (uint256)
359     {
360         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
361     }
362 
363     /**
364      * @dev calculates how many keys would exist with given an amount of eth
365      * @param _eth eth "in contract"
366      * @return number of keys that would exist
367      */
368     function keys(uint256 _eth) 
369         internal
370         pure
371         returns(uint256)
372     {
373         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
374     }
375     
376     /**
377      * @dev calculates how much eth would be in contract given a number of keys
378      * @param _keys number of keys "in contract" 
379      * @return eth that would exists
380      */
381     function eth(uint256 _keys) 
382         internal
383         pure
384         returns(uint256)  
385     {
386         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
387     }
388 }
389 
390 /**
391  * @title SafeMath v0.1.9
392  * @dev Math operations with safety checks that throw on error
393  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
394  * - added sqrt
395  * - added sq
396  * - added pwr 
397  * - changed asserts to requires with error log outputs
398  * - removed div, its useless
399  */
400 library SafeMath {
401     
402     /**
403     * @dev Multiplies two numbers, throws on overflow.
404     */
405     function mul(uint256 a, uint256 b) 
406         internal 
407         pure 
408         returns (uint256 c) 
409     {
410         if (a == 0) {
411             return 0;
412         }
413         c = a * b;
414         require(c / a == b, "SafeMath mul failed");
415         return c;
416     }
417 
418     /**
419     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
420     */
421     function sub(uint256 a, uint256 b)
422         internal
423         pure
424         returns (uint256) 
425     {
426         require(b <= a, "SafeMath sub failed");
427         return a - b;
428     }
429 
430     /**
431     * @dev Adds two numbers, throws on overflow.
432     */
433     function add(uint256 a, uint256 b)
434         internal
435         pure
436         returns (uint256 c) 
437     {
438         c = a + b;
439         require(c >= a, "SafeMath add failed");
440         return c;
441     }
442     
443     /**
444      * @dev gives square root of given x.
445      */
446     function sqrt(uint256 x)
447         internal
448         pure
449         returns (uint256 y) 
450     {
451         uint256 z = ((add(x,1)) / 2);
452         y = x;
453         while (z < y) 
454         {
455             y = z;
456             z = ((add((x / z),z)) / 2);
457         }
458     }
459     
460     /**
461      * @dev gives square. multiplies x by x
462      */
463     function sq(uint256 x)
464         internal
465         pure
466         returns (uint256)
467     {
468         return (mul(x,x));
469     }
470     
471     /**
472      * @dev x to the power of y 
473      */
474     function pwr(uint256 x, uint256 y)
475         internal 
476         pure 
477         returns (uint256)
478     {
479         if (x==0)
480             return (0);
481         else if (y==0)
482             return (1);
483         else 
484         {
485             uint256 z = x;
486             for (uint256 i=1; i < y; i++)
487                 z = mul(z,x);
488             return (z);
489         }
490     }
491     
492 }