1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal pure  returns (uint) {
6     uint c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10   function div(uint a, uint b) internal pure returns (uint) {
11     require(b > 0);
12     uint c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16   function sub(uint a, uint b) internal pure returns (uint) {
17     require(b <= a);
18     return a - b;
19   }
20   function add(uint a, uint b) internal pure returns (uint) {
21     uint c = a + b;
22     require(c >= a);
23     return c;
24   }
25   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
26     return a >= b ? a : b;
27   }
28   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
29     return a < b ? a : b;
30   }
31   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 
39 contract ERC20Basic {
40   uint public totalSupply;
41   function balanceOf(address who) public constant returns (uint);
42   function transfer(address to, uint value) public;
43   event Transfer(address indexed from, address indexed to, uint value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public constant returns (uint);
48   function transferFrom(address from, address to, uint value) public;
49   function approve(address spender, uint value) public;
50   event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 
54 
55 contract BasicToken is ERC20Basic {
56   
57   using SafeMath for uint;
58   
59   mapping(address => uint) balances;
60 
61   function transfer(address _to, uint _value) public{
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65   }
66 
67   function balanceOf(address _owner) public constant returns (uint balance) {
68     return balances[_owner];
69   }
70 }
71 
72 
73 contract StandardToken is BasicToken, ERC20 {
74   mapping (address => mapping (address => uint)) allowed;
75 
76   function transferFrom(address _from, address _to, uint _value) public {
77     balances[_to] = balances[_to].add(_value);
78     balances[_from] = balances[_from].sub(_value);
79     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
80     Transfer(_from, _to, _value);
81   }
82 
83   function approve(address _spender, uint _value) public{
84     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
85     allowed[msg.sender][_spender] = _value;
86     Approval(msg.sender, _spender, _value);
87   }
88 
89   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
90     return allowed[_owner][_spender];
91   }
92 }
93 
94 contract Ownable {
95     address public owner;
96 
97     function Ownable() public{
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner {
102         require(msg.sender == owner);
103         _;
104     }
105     function transferOwnership(address newOwner) onlyOwner public{
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110 }
111 
112 
113 /**
114  *  TTC token contract. Implements
115  */
116 contract TTC is StandardToken, Ownable {
117   string public constant name = "TTC";
118   string public constant symbol = "TTC";
119   uint public constant decimals = 18;
120 
121 
122   // Constructor
123   function TTC() public {
124       totalSupply = 1000000000000000000000000000;
125       balances[msg.sender] = totalSupply; // Send all tokens to owner
126   }
127 
128   /**
129    *  Burn away the specified amount of SkinCoin tokens
130    */
131   function burn(uint _value) onlyOwner public returns (bool) {
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     totalSupply = totalSupply.sub(_value);
134     Transfer(msg.sender, 0x0, _value);
135     return true;
136   }
137 
138 }
139 
140 contract Crowdsale is Ownable{
141     
142     using SafeMath for uint;
143 
144     struct Backer {
145         uint weiReceived; 
146         uint coinSent;
147         uint coinReadyToSend;
148     }
149 
150     /*
151     * Constants
152     */
153 
154     /**
155     * ICO Phases.
156     *
157     * - PreStart:   tokens are not yet sold/issued
158     * - PreIco:     new tokens sold/issued at the discounted price
159     * - PauseIco:   tokens are not sold/issued
160     * - MainIco     new tokens sold/issued at the regular price
161     * - AfterIco:   tokens are not sold/issued
162     */
163     enum Phases {PreStart, PreIco, PauseIco, MainIco, AfterIco}
164 
165     /* Maximum number of TTC to pre ico sell */
166     uint public constant PRE_MAX_CAP = 25000000000000000000000000; // 25,000,000 TTC
167 
168     /* Maximum number of TTC to main ico sell */
169     uint public constant MAIN_MAX_CAP = 125000000000000000000000000; // 125,000,000 TTC
170 
171     /* Minimum amount to invest */
172     uint public constant MIN_INVEST_ETHER = 100 finney;
173 
174     /* Crowdsale period */
175     uint private constant PRE_START_TIME = 1520820000;  // 2018-03-12 10:00 AM (UTC + 08:00)
176     uint private constant PRE_END_TIME = 1521079200;    // 2018-03-15 10:00 AM (UTC + 08:00)
177     uint private constant MAIN_START_TIME = 1522029600; // 2018-03-26 10:00 AM (UTC + 08:00)
178     uint private constant MAIN_END_TIME = 1524189600;   // 2018-04-20 10:00 AM (UTC + 08:00)
179 
180     /* Number of TTC per Ether */
181     uint public constant PRE_COIN_PER_ETHER_ICO = 5000000000000000000000; // 5,000 TTC
182     uint public constant MAIN_COIN_PER_ETHER_ICO = 4000000000000000000000; // 4,000 TTC
183 
184     /*
185     * Variables
186     */
187     /* TTC contract reference */
188     TTC public coin;
189 
190     /*Maximum Ether for one address during pre ico or main ico */
191     uint public maximumCoinsPerAddress = 10 ether;
192     
193     /* Multisig contract that will receive the Ether during pre ico*/
194     address public preMultisigEther;
195     /* Number of Ether received during pre ico */
196     uint public preEtherReceived;
197     /* Number of TTC sent to Ether contributors during pre ico */
198     uint public preCoinSentToEther;
199 
200     /* Multisig contract that will receive the Ether during main ico*/
201     address public mainMultisigEther;
202     /* Number of Ether received during main ico */
203     uint public mainEtherReceived;
204     /* Number of TTC sent to Ether contributors during main ico */
205     uint public mainCoinSentToEther;
206 
207     /* Backers Ether indexed by their Ethereum address */
208     mapping(address => Backer) public preBackers;
209     address[] internal preReadyToSendAddress;
210     mapping(address => Backer) public mainBackers;
211     address[] internal mainReadyToSendAddress;
212 
213     /* White List */
214     mapping(address => bool) public whiteList;
215 
216     /* Current Phase */
217     Phases public phase = Phases.PreStart;
218 
219     /*
220     * Modifiers
221     */
222 
223     modifier respectTimeFrame() {
224         require((now >= PRE_START_TIME) && (now < PRE_END_TIME ) || (now >= MAIN_START_TIME) && (now < MAIN_END_TIME ));
225         _;
226     }
227 
228     /*
229      * Event
230     */
231     event LogReceivedETH(address addr, uint value);
232     event LogCoinsEmited(address indexed from, uint amount);
233 
234     /*
235      * Constructor
236     */
237     function Crowdsale() public{
238         
239     }
240 
241     /**
242     *   Allow to set TTC address
243     */
244     function setTTCAddress(address _addr) onlyOwner public {
245         require(_addr != address(0));
246         coin = TTC(_addr);
247     }
248 
249     /**
250      * Allow to change the team multisig address in the case of emergency.
251      */
252     function setMultisigPre(address _addr) onlyOwner public {
253         require(_addr != address(0));
254         preMultisigEther = _addr;
255     }
256 
257     /**
258      * Allow to change the team multisig address in the case of emergency.
259      */
260     function setMultisigMain(address _addr) onlyOwner public {
261         require(_addr != address(0));
262         mainMultisigEther = _addr;
263     }
264 
265     /**
266     *   Allow to change the maximum Coin one address can buy during the ico
267     */
268     function setMaximumCoinsPerAddress(uint _cnt) onlyOwner public{
269         maximumCoinsPerAddress = _cnt;
270     }
271 
272     /* 
273      * The fallback function corresponds to a donation in ETH
274      */
275     function() respectTimeFrame  payable public{
276         require(whiteList[msg.sender]);
277         receiveETH(msg.sender);
278     }
279 
280     /*
281      *  Receives a donation in Ether
282     */
283     function receiveETH(address _beneficiary) internal {
284         require(msg.value >= MIN_INVEST_ETHER) ; 
285         adjustPhaseBasedOnTime();
286         uint coinToSend ;
287 
288         if(phase == Phases.PreIco) {
289             Backer storage preBacker = preBackers[_beneficiary];
290             require(preBacker.weiReceived.add(msg.value) <= maximumCoinsPerAddress);
291 
292             coinToSend = msg.value.mul(PRE_COIN_PER_ETHER_ICO).div(1 ether); 
293             require(coinToSend.add(preCoinSentToEther) <= PRE_MAX_CAP) ;
294 
295             preBacker.coinSent = preBacker.coinSent.add(coinToSend);
296             preBacker.weiReceived = preBacker.weiReceived.add(msg.value);   
297             preBacker.coinReadyToSend = preBacker.coinReadyToSend.add(coinToSend);
298             preReadyToSendAddress.push(_beneficiary);
299 
300             // Update the total wei collected during the crowdfunding
301             preEtherReceived = preEtherReceived.add(msg.value); 
302             preCoinSentToEther = preCoinSentToEther.add(coinToSend);
303 
304             // Send events
305             LogReceivedETH(_beneficiary, preEtherReceived); 
306 
307         }else if (phase == Phases.MainIco){
308             Backer storage mainBacker = mainBackers[_beneficiary];
309             require(mainBacker.weiReceived.add(msg.value) <= maximumCoinsPerAddress);
310 
311             coinToSend = msg.value.mul(MAIN_COIN_PER_ETHER_ICO).div(1 ether);   
312             require(coinToSend.add(mainCoinSentToEther) <= MAIN_MAX_CAP) ;
313 
314             mainBacker.coinSent = mainBacker.coinSent.add(coinToSend);
315             mainBacker.weiReceived = mainBacker.weiReceived.add(msg.value);   
316             mainBacker.coinReadyToSend = mainBacker.coinReadyToSend.add(coinToSend);
317             mainReadyToSendAddress.push(_beneficiary);
318 
319             // Update the total wei collected during the crowdfunding
320             mainEtherReceived = mainEtherReceived.add(msg.value); 
321             mainCoinSentToEther = mainCoinSentToEther.add(coinToSend);
322 
323             // Send events
324             LogReceivedETH(_beneficiary, mainEtherReceived); 
325         }
326     }
327 
328     /*
329     *   Adjust phase base on time
330     */
331     function adjustPhaseBasedOnTime() internal {
332 
333         if (now < PRE_START_TIME) {
334             if (phase != Phases.PreStart) {
335                 phase = Phases.PreStart;
336             }
337         } else if (now >= PRE_START_TIME && now < PRE_END_TIME) {
338             if (phase != Phases.PreIco) {
339                 phase = Phases.PreIco;
340             }
341         } else if (now >= PRE_END_TIME && now < MAIN_START_TIME) {
342             if (phase != Phases.PauseIco) {
343                 phase = Phases.PauseIco;
344             }
345         }else if (now >= MAIN_START_TIME && now < MAIN_END_TIME) {
346             if (phase != Phases.MainIco) {
347                 phase = Phases.MainIco;
348             }
349         }else {
350             if (phase != Phases.AfterIco){
351                 phase = Phases.AfterIco;
352             }
353         }
354     }
355     
356 
357     /*
358     *   Durign the pre ico, should be called by owner to send TTC to beneficiary address
359     */
360     function preSendTTC() onlyOwner public {
361         for(uint i=0; i < preReadyToSendAddress.length ; i++){
362             address backerAddress = preReadyToSendAddress[i];
363             uint coinReadyToSend = preBackers[backerAddress].coinReadyToSend;
364             if ( coinReadyToSend > 0) {
365                 preBackers[backerAddress].coinReadyToSend = 0;
366                 coin.transfer(backerAddress, coinReadyToSend);
367                 LogCoinsEmited(backerAddress, coinReadyToSend);
368             }
369         }
370         delete preReadyToSendAddress;
371         require(preMultisigEther.send(this.balance)) ; 
372     }
373 
374     /*
375     *   Durign the main ico, should be called by owner to send TTC to beneficiary address
376     */
377     function mainSendTTC() onlyOwner public{
378         for(uint i=0; i < mainReadyToSendAddress.length ; i++){
379             address backerAddress = mainReadyToSendAddress[i];
380             uint coinReadyToSend = mainBackers[backerAddress].coinReadyToSend;
381             if ( coinReadyToSend > 0) {
382                 mainBackers[backerAddress].coinReadyToSend = 0;
383                 coin.transfer(backerAddress, coinReadyToSend);
384                 LogCoinsEmited(backerAddress, coinReadyToSend);
385             }
386         }
387         delete mainReadyToSendAddress;
388         require(mainMultisigEther.send(this.balance)) ; 
389 
390     }
391 
392     /*
393     *  White list, only address in white list can buy TTC
394     */
395     function addWhiteList(address[] _whiteList) onlyOwner public{
396         for (uint i =0;i<_whiteList.length;i++){
397             whiteList[_whiteList[i]] = true;
398         }   
399     }
400 
401     /*  
402      * Finalize the crowdsale, should be called after the refund period
403     */
404     function finalize() onlyOwner public {
405         adjustPhaseBasedOnTime();
406         require(phase == Phases.AfterIco);
407         require(this.balance > 0);
408         require(mainMultisigEther.send(this.balance)) ; 
409         uint remains = coin.balanceOf(this);
410         if (remains > 0) { 
411             coin.transfer(owner,remains);
412         }
413     }
414 
415 
416     /**
417      * Manually back TTC owner address.
418      */
419     function backTTCOwner() onlyOwner public {
420         coin.transferOwnership(owner);
421     }
422 
423 
424     /**
425      * Transfer remains to owner in case if impossible to do min invest
426      */
427     function getPreRemainCoins() onlyOwner public {
428         uint preRemains = PRE_MAX_CAP - preCoinSentToEther;
429         Backer storage backer = preBackers[owner];
430         coin.transfer(owner, preRemains); 
431         backer.coinSent = backer.coinSent.add(preRemains);
432         preCoinSentToEther = preCoinSentToEther.add(preRemains);
433         
434         LogCoinsEmited(this ,preRemains);
435         LogReceivedETH(owner, preEtherReceived); 
436     }
437 
438 
439     /**
440      * Transfer remains to owner in case if impossible to do min invest
441      */
442     function getMainRemainCoins() onlyOwner public {
443         uint mainRemains = MAIN_MAX_CAP - mainCoinSentToEther;
444         Backer storage backer = mainBackers[owner];
445         coin.transfer(owner, mainRemains); 
446         backer.coinSent = backer.coinSent.add(mainRemains);
447         mainCoinSentToEther = mainCoinSentToEther.add(mainRemains);
448 
449         LogCoinsEmited(this ,mainRemains);
450         LogReceivedETH(owner, mainEtherReceived); 
451     }
452 
453     /**
454     *   Refund to specific address 
455     */
456     function refund(address _beneficiary) onlyOwner public {
457 
458         uint valueToSend = 0;
459         Backer storage preBacker = preBackers[_beneficiary];
460         if (preBacker.coinReadyToSend > 0){ 
461             uint preValueToSend = preBacker.coinReadyToSend.mul(1 ether).div(PRE_COIN_PER_ETHER_ICO);
462             preBacker.coinSent = preBacker.coinSent.sub(preBacker.coinReadyToSend);
463             preBacker.weiReceived = preBacker.weiReceived.sub(preValueToSend);   
464             preEtherReceived = preEtherReceived.sub(preValueToSend); 
465             preCoinSentToEther = preCoinSentToEther.sub(preBacker.coinReadyToSend);
466             preBacker.coinReadyToSend = 0;
467             valueToSend = valueToSend + preValueToSend;
468 
469         }
470 
471         Backer storage mainBacker = mainBackers[_beneficiary];
472         if (mainBacker.coinReadyToSend > 0){ 
473             uint mainValueToSend = mainBacker.coinReadyToSend.mul(1 ether).div(MAIN_COIN_PER_ETHER_ICO);
474             mainBacker.coinSent = mainBacker.coinSent.sub(mainBacker.coinReadyToSend);
475             mainBacker.weiReceived = mainBacker.weiReceived.sub(mainValueToSend);   
476             mainEtherReceived = mainEtherReceived.sub(mainValueToSend); 
477             mainCoinSentToEther = mainCoinSentToEther.sub(mainBacker.coinReadyToSend);
478             mainBacker.coinReadyToSend = 0;
479             valueToSend = valueToSend + mainValueToSend;
480 
481         }
482         if (valueToSend > 0){
483             require(_beneficiary.send(valueToSend));
484         }
485         
486     }
487 
488 
489     /**
490     *   Refund to all address
491     */  
492     function refundAll() onlyOwner public {
493 
494         for(uint i=0; i < preReadyToSendAddress.length ; i++){
495             refund(preReadyToSendAddress[i]);
496 
497         }
498         
499         for(uint j=0; j < mainReadyToSendAddress.length ; j++){
500             refund(mainReadyToSendAddress[j]);
501 
502         }
503 
504         delete preReadyToSendAddress;
505         delete mainReadyToSendAddress;
506 
507     }
508     
509 
510 }