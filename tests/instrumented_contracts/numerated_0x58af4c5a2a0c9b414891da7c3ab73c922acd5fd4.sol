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
53 contract BasicToken is ERC20Basic {
54   
55   using SafeMath for uint;
56   
57   mapping(address => uint) balances;
58 
59   function transfer(address _to, uint _value) public{
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63   }
64 
65   function balanceOf(address _owner) public constant returns (uint balance) {
66     return balances[_owner];
67   }
68 }
69 
70 
71 contract StandardToken is BasicToken, ERC20 {
72   mapping (address => mapping (address => uint)) allowed;
73 
74   function transferFrom(address _from, address _to, uint _value) public {
75     balances[_to] = balances[_to].add(_value);
76     balances[_from] = balances[_from].sub(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79   }
80 
81   function approve(address _spender, uint _value) public{
82     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85   }
86 
87   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
88     return allowed[_owner][_spender];
89   }
90 }
91 
92 
93 contract Ownable {
94     address public owner;
95 
96     function Ownable() public{
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner {
101         require(msg.sender == owner);
102         _;
103     }
104     function transferOwnership(address newOwner) onlyOwner public{
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109 }
110 
111 
112 contract TTC is StandardToken, Ownable {
113   string public constant name = "TTC";
114   string public constant symbol = "TTC";
115   uint public constant decimals = 18;
116 
117 
118   function TTC() public {
119       totalSupply = 1000000000000000000000000000;
120       balances[msg.sender] = totalSupply; // Send all tokens to owner
121   }
122 
123 
124   function burn(uint _value) onlyOwner public returns (bool) {
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     totalSupply = totalSupply.sub(_value);
127     Transfer(msg.sender, 0x0, _value);
128     return true;
129   }
130 
131 }
132 
133 
134 contract CrowdsaleMain is Ownable{
135     
136     using SafeMath for uint;
137 
138     struct Backer {
139     uint weiReceived; 
140     uint coinSent;
141     uint coinReadyToSend;
142   }
143 
144   /*
145   * Constants
146   */
147 
148   /**
149     * ICO Phases.
150     *
151     * - PreStart:   tokens are not yet sold/issued
152     * - MainIco     new tokens sold/issued at the regular price
153     * - AfterIco:   tokens are not sold/issued
154     */
155     enum Phases {PreStart,  MainIco, AfterIco}
156 
157   /* Maximum number of TTC to main ico sell */
158   uint public constant MAIN_MAX_CAP = 100000000000000000000000000; // 100,000,000 TTC
159 
160   /* Minimum amount to invest */
161   uint public constant MIN_INVEST_ETHER = 100 finney;
162 
163   /* Number of TTC per Ether */
164   uint public constant MAIN_COIN_PER_ETHER_ICO = 4000000000000000000000; // 4,000 TTC
165 
166   /*
167   * Variables
168   */
169 
170   /* Crowdsale period */
171   uint private mainStartTime = 1524052800;  // 2018-04-18 20:00 AM (UTC + 08:00)
172   uint private mainEndTime = 1526644800;    // 2018-05-18 20:00 AM (UTC + 08:00)
173 
174   /* TTC contract reference */
175   TTC public coin;
176 
177   /*Maximum Ether for one address during pre ico or main ico */
178   uint public maximumCoinsPerAddress = 50 ether;
179     
180   /* Multisig contract that will receive the Ether during main ico*/
181   address public mainMultisigEther;
182   /* Number of Ether received during main ico */
183   uint public mainEtherReceived;
184   /* Number of TTC sent to Ether contributors during main ico */
185   uint public mainCoinSentToEther;
186 
187   /* Backers Ether indexed by their Ethereum address */
188   mapping(address => Backer) public mainBackers;
189   address[] internal mainReadyToSendAddress;
190 
191   /* White List */
192   mapping(address => bool) public whiteList;
193   address private whiteListOwner;
194 
195     /* Current Phase */
196     Phases public phase = Phases.PreStart;
197 
198   /*
199   * Modifiers
200   */
201 
202   modifier respectTimeFrame() {
203     require((now >= mainStartTime) && (now < mainEndTime ));
204     _;
205   }
206 
207   /*
208    * Event
209   */
210   event LogReceivedETH(address addr, uint value);
211   event LogCoinsEmited(address indexed from, uint amount);
212 
213   /*
214    * Constructor
215   */
216   function CrowdsaleMain() public{
217     whiteListOwner = msg.sender;
218   }
219 
220   /**
221   * Allow to set TTC address
222   */
223   function setTTCAddress(address _addr) onlyOwner public {
224     require(_addr != address(0));
225     coin = TTC(_addr);
226   }
227 
228   /**
229   * Allow owner to set whiteListOwner
230   */
231   function setWhiteListOwner(address _addr) onlyOwner public {
232     whiteListOwner = _addr;
233 
234   }
235 
236   /**
237   * Check addressExistInWhiteList
238   */ 
239   function isExistInWhiteList(address _addr) public view returns (bool) {
240     return whiteList[_addr];
241   }
242 
243   /**
244   * change main start time by owner
245   */
246   function changeMainStartTime(uint _timestamp) onlyOwner public {
247 
248     mainStartTime = _timestamp;
249   }
250 
251   /**
252   * change main stop time by owner
253   */
254   function changeMainEndTime(uint _timestamp) onlyOwner public {
255     mainEndTime = _timestamp;
256 
257   }
258 
259   /**
260    * Allow to change the team multisig address in the case of emergency.
261    */
262   function setMultisigMain(address _addr) onlyOwner public {
263     require(_addr != address(0));
264     mainMultisigEther = _addr;
265   }
266 
267   /**
268   * Allow to change the maximum Coin one address can buy during the ico
269   */
270   function setMaximumCoinsPerAddress(uint _cnt) onlyOwner public{
271     maximumCoinsPerAddress = _cnt;
272   }
273 
274   /* 
275    * The fallback function corresponds to a donation in ETH
276    */
277   function() respectTimeFrame  payable public{
278     require(whiteList[msg.sender]);
279     receiveETH(msg.sender);
280   }
281 
282   /*
283    *  Receives a donation in Ether
284   */
285   function receiveETH(address _beneficiary) internal {
286     require(msg.value >= MIN_INVEST_ETHER) ; 
287     adjustPhaseBasedOnTime();
288     uint coinToSend ;
289 
290     if (phase == Phases.MainIco){
291       Backer storage mainBacker = mainBackers[_beneficiary];
292       require(mainBacker.weiReceived.add(msg.value) <= maximumCoinsPerAddress);
293 
294       coinToSend = msg.value.mul(MAIN_COIN_PER_ETHER_ICO).div(1 ether);   
295       require(coinToSend.add(mainCoinSentToEther) <= MAIN_MAX_CAP) ;
296 
297       mainBacker.coinSent = mainBacker.coinSent.add(coinToSend);
298       mainBacker.weiReceived = mainBacker.weiReceived.add(msg.value);   
299       mainBacker.coinReadyToSend = mainBacker.coinReadyToSend.add(coinToSend);
300       mainReadyToSendAddress.push(_beneficiary);
301 
302       // Update the total wei collected during the crowdfunding
303       mainEtherReceived = mainEtherReceived.add(msg.value); 
304       mainCoinSentToEther = mainCoinSentToEther.add(coinToSend);
305 
306       // Send events
307       LogReceivedETH(_beneficiary, mainEtherReceived); 
308     }
309   }
310 
311   /*
312   * Adjust phase base on time
313   */
314     function adjustPhaseBasedOnTime() internal {
315 
316         if (now < mainStartTime ) {
317             if (phase != Phases.PreStart) {
318                 phase = Phases.PreStart;
319             }
320         } else if (now >= mainStartTime && now < mainEndTime) {
321             if (phase != Phases.MainIco) {
322                 phase = Phases.MainIco;
323             }
324         }else {
325           if (phase != Phases.AfterIco){
326             phase = Phases.AfterIco;
327           }
328         }
329     }
330   
331 
332   /*
333   * Durign the main ico, should be called by owner to send TTC to beneficiary address
334   */
335   function mainSendTTC() onlyOwner public{
336     for(uint i=0; i < mainReadyToSendAddress.length ; i++){
337       address backerAddress = mainReadyToSendAddress[i];
338       uint coinReadyToSend = mainBackers[backerAddress].coinReadyToSend;
339       if ( coinReadyToSend > 0) {
340         mainBackers[backerAddress].coinReadyToSend = 0;
341         coin.transfer(backerAddress, coinReadyToSend);
342         LogCoinsEmited(backerAddress, coinReadyToSend);
343       }
344     }
345     delete mainReadyToSendAddress;
346     require(mainMultisigEther.send(this.balance)) ; 
347 
348   }
349 
350   /*
351   *  White list, only address in white list can buy TTC
352   */
353   function addWhiteList(address[] _whiteList) public {
354     require(msg.sender == whiteListOwner);
355     for (uint i =0;i<_whiteList.length;i++){
356       whiteList[_whiteList[i]] = true;
357     } 
358   }
359   /**
360   * Remove address from whiteList by whiteListOwner
361   */
362   function removeWhiteList(address[] _whiteList) public {
363     require(msg.sender == whiteListOwner);
364     for (uint i =0;i<_whiteList.length;i++){
365       whiteList[_whiteList[i]] = false;
366     }
367   }
368 
369   /*  
370    * Finalize the crowdsale, should be called after the refund period
371   */
372   function finalize() onlyOwner public {
373     adjustPhaseBasedOnTime();
374     require(phase == Phases.AfterIco);
375     require(this.balance > 0);
376     require(mainMultisigEther.send(this.balance)) ; 
377     uint remains = coin.balanceOf(this);
378     if (remains > 0) { 
379       coin.transfer(owner,remains);
380     }
381   }
382 
383   /**
384    * Manually back TTC owner address.
385    */
386   function backTTCOwner() onlyOwner public {
387     coin.transferOwnership(owner);
388   }
389 
390   /**
391    * Transfer remains to owner in case if impossible to do min invest
392    */
393   function getMainRemainCoins() onlyOwner public {
394     uint mainRemains = MAIN_MAX_CAP - mainCoinSentToEther;
395     Backer storage backer = mainBackers[owner];
396     coin.transfer(owner, mainRemains); 
397     backer.coinSent = backer.coinSent.add(mainRemains);
398     mainCoinSentToEther = mainCoinSentToEther.add(mainRemains);
399 
400     LogCoinsEmited(this ,mainRemains);
401     LogReceivedETH(owner, mainEtherReceived); 
402   }
403 
404   /**
405   * Refund to specific address 
406   */
407   function refund(address _beneficiary) onlyOwner public {
408     uint valueToSend = 0;
409     Backer storage mainBacker = mainBackers[_beneficiary];
410     if (mainBacker.coinReadyToSend > 0){ 
411       uint mainValueToSend = mainBacker.coinReadyToSend.mul(1 ether).div(MAIN_COIN_PER_ETHER_ICO);
412       mainBacker.coinSent = mainBacker.coinSent.sub(mainBacker.coinReadyToSend);
413       mainBacker.weiReceived = mainBacker.weiReceived.sub(mainValueToSend);   
414       mainEtherReceived = mainEtherReceived.sub(mainValueToSend); 
415       mainCoinSentToEther = mainCoinSentToEther.sub(mainBacker.coinReadyToSend);
416       mainBacker.coinReadyToSend = 0;
417       valueToSend = valueToSend + mainValueToSend;
418 
419     }
420     if (valueToSend > 0){
421       require(_beneficiary.send(valueToSend));
422     }
423     
424   }
425 
426 
427   /**
428   * Refund to all address
429   */  
430   function refundAll() onlyOwner public {
431     
432     for(uint j=0; j < mainReadyToSendAddress.length ; j++){
433       refund(mainReadyToSendAddress[j]);
434 
435     }
436 
437     delete mainReadyToSendAddress;
438 
439   }
440   
441 
442 }