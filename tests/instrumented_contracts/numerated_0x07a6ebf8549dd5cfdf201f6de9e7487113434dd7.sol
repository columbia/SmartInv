1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6         if (_a == 0) {
7             return 0;
8         }
9 
10         uint256 c = _a * _b;
11         require(c / _a == _b);
12 
13         return c;
14     }
15 
16     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
17         require(_b > 0);
18         uint256 c = _a / _b;
19 
20         return c;
21     }
22 
23     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24         require(_b <= _a);
25         uint256 c = _a - _b;
26 
27         return c;
28     }
29 
30     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
31         uint256 c = _a + _b;
32         require(c >= _a);
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
41 }
42 
43 contract Ownable {
44   address private _owner;
45 
46   event OwnershipTransferred(
47     address indexed previousOwner,
48     address indexed newOwner
49   );
50 
51 
52   constructor() internal {
53     _owner = msg.sender;
54     emit OwnershipTransferred(address(0), _owner);
55   }
56 
57 
58   function owner() public view returns(address) {
59     return _owner;
60   }
61 
62 
63   modifier onlyOwner() {
64     require(isOwner());
65     _;
66   }
67 
68 
69   function isOwner() public view returns(bool) {
70     return msg.sender == _owner;
71   }
72 
73 
74   function renounceOwnership() public onlyOwner {
75     emit OwnershipTransferred(_owner, address(0));
76     _owner = address(0);
77   }
78 
79   function transferOwnership(address newOwner) public onlyOwner {
80     _transferOwnership(newOwner);
81   }
82 
83   function _transferOwnership(address newOwner) internal {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(_owner, newOwner);
86     _owner = newOwner;
87   }
88 }
89 
90 contract Multiplier is Ownable {
91     using SafeMath for uint;
92 
93     //Address for promo expences
94     address constant private support = 0x8Fa6E56c844be9B96C30B72cC2a8ccF6465a99F9;
95     //Percent for promo expences
96     uint constant public supportPercent = 3;
97 
98     uint public reserved;
99     uint public delayed;
100 
101     uint minCycle  = 5 minutes;
102     uint initCycle = 2 hours;
103     uint maxCycle  = 1 days;
104 
105     uint public cycleStart;
106     uint public actualCycle;
107     uint public lastCycle;
108     uint public cycles;
109 
110     uint minPercent = 1;
111     uint maxPercent = 33;
112 
113     uint frontier = 50;
114 
115     mapping (address => address) referrer;
116     mapping (address => bool) verified;
117 
118     uint refBonus = 5;
119 
120     uint verificationPrice = 0.0303 ether;
121 
122     event NewCycle(uint start, uint duration, uint indexed cycle);
123     event NewDeposit(address indexed addr, uint idx, uint amount, uint profit, uint indexed cycle);
124     event Payed(address indexed addr, uint amount, uint indexed cycle);
125     event Refunded(address indexed addr, uint amount, uint indexed cycle);
126     event RefundCompleted(uint indexed cycle);
127     event RefVerified(address indexed addr);
128     event RefBonusPayed(address indexed investor, address referrer, uint amount, uint level);
129     event VerPriceChanged(uint oldPrice, uint newPrice);
130 
131 
132     constructor() public {
133         verified[owner()] = true;
134         actualCycle = initCycle * 2;
135         queue.length += 1;
136     }
137 
138     //The deposit structure holds all the info about the deposit made
139     struct Deposit {
140         address depositor; //The depositor address
141         uint128 deposit;   //The deposit amount
142         uint128 expect;    //How much we should pay out
143     }
144 
145     Deposit[] public queue;  //The queue
146     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
147     uint public currentRefundIndex = 0;
148 
149     function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
150         assembly {
151             parsedreferrer := mload(add(_source,0x14))
152         }
153         return parsedreferrer;
154     }
155 
156     function setRef() internal returns(bool) {
157         address _referrer = bytesToAddress(bytes(msg.data));
158         if (_referrer != msg.sender && msg.data.length == 20 && verified[_referrer]) {
159             referrer[msg.sender] = _referrer;
160             return true;
161         }
162     }
163 
164     function setVerificationPrice(uint newPrice) external onlyOwner {
165         emit VerPriceChanged(verificationPrice, newPrice);
166         verificationPrice = newPrice;
167     }
168 
169     function verify(address addr) public payable {
170         if (msg.sender != owner()) {
171             require(msg.value == verificationPrice);
172             support.send(verificationPrice);
173         }
174         verified[addr] = true;
175         emit RefVerified(addr);
176     }
177 
178     //This function receives all the deposits
179     //stores them and make immediate payouts
180     function () public payable {
181         //check if sender is not a smart contract
182         require(!isContract(msg.sender));
183 
184         if(msg.value == verificationPrice) {
185             verify(msg.sender);
186             return;
187         }
188 
189         if (msg.value == 0 && msg.sender == owner()) {
190             address a = bytesToAddress(bytes(msg.data));
191             verify(a);
192             return;
193         }
194 
195         if (referrer[msg.sender] == address(0)) {
196             require(setRef());
197         }
198 
199         if(msg.value > 0){
200             require(gasleft() >= 300000, "We require more gas!"); //We need gas to process queue
201             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
202 
203             if (block.timestamp >= cycleStart + actualCycle) {
204                 if (queue.length.sub(lastCycle) >= frontier) {
205                     actualCycle = actualCycle * 2;
206                     if (actualCycle > maxCycle) {
207                         actualCycle = maxCycle;
208                     }
209                 } else {
210                     actualCycle = actualCycle / 2;
211 
212                     if (actualCycle < minCycle) {
213                         actualCycle = minCycle;
214                     }
215                 }
216 
217                 uint amountOfPlayers = queue.length - lastCycle;
218                 lastCycle = queue.length;
219                 cycleStart = block.timestamp;
220                 currentReceiverIndex = lastCycle;
221                 cycles++;
222 
223                 if (amountOfPlayers != 1) {
224                     currentRefundIndex = lastCycle.sub(1);
225                     refunding();
226                 } else {
227                     singleRefunding();
228                 }
229 
230                 emit NewCycle(cycleStart, actualCycle, cycles);
231             }
232 
233             if (currentRefundIndex != 0) {
234                 refunding();
235             }
236 
237             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
238             uint percent = queue.length.sub(lastCycle).add(1);
239             if (percent >= 33) {
240                 percent = 33;
241             }
242 
243             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * (100 + percent) / 100)));
244 
245             //Send fee
246             uint _support = msg.value * supportPercent / 100;
247             support.send(_support);
248             uint _refBonus = msg.value * refBonus / 1000;
249             referrer[msg.sender].send(_refBonus);
250             emit RefBonusPayed(msg.sender, referrer[msg.sender], _refBonus, 1);
251             if (referrer[referrer[msg.sender]] != address(0)) {
252                 referrer[referrer[msg.sender]].send(_refBonus);
253                 emit RefBonusPayed(msg.sender, referrer[referrer[msg.sender]], _refBonus, 2);
254             }
255 
256             emit NewDeposit(msg.sender, queue.length - 1, msg.value, msg.value * (100 + percent) / 100, cycles);
257 
258             if (currentRefundIndex == 0) {
259                 reserved += msg.value * 96 / 100 / 2;
260                 if (delayed != 0) {
261                     reserved != delayed;
262                     delayed = 0;
263                 }
264                 //Pay to first investors in line
265                 pay();
266             } else {
267                 delayed += msg.value * 96 / 100 / 2;
268             }
269 
270         }
271     }
272 
273     //Used to pay to current investors
274     //Each new transaction processes 1 - 4+ investors in the head of queue
275     //depending on balance and gas left
276     function pay() private {
277         //Try to send all the money on contract to the first investors in line
278         uint128 money = uint128(address(this).balance - reserved);
279 
280         //We will do cycle on the queue
281         for(uint i=0; i<queue.length; i++){
282 
283             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
284 
285             Deposit storage dep = queue[idx]; //get the info of the first investor
286 
287             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
288                 dep.depositor.send(dep.expect); //Send money to him
289                 money -= dep.expect;            //update money left
290 
291                 emit Payed(dep.depositor, dep.expect, cycles);
292 
293                 //this investor is fully paid, so remove him
294                 delete queue[idx];
295             }else{
296                 //Here we don't have enough money so partially pay to investor
297                 dep.depositor.send(money); //Send to him everything we have
298                 dep.expect -= money;       //Update the expected amount
299 
300                 emit Payed(dep.depositor, money, cycles);
301 
302                 break;                     //Exit cycle
303             }
304 
305             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
306                 break;                     //The next investor will process the line further
307         }
308 
309         currentReceiverIndex += i; //Update the index of the current first investor
310     }
311 
312     function refunding() private {
313 
314         uint128 refund = uint128(reserved);
315         if (refund >= 1 ether) {
316             refund -= 1 ether;
317         }
318 
319         for(uint i=0; i<=currentRefundIndex; i++){
320 
321             uint idx = currentRefundIndex.sub(i);
322 
323             Deposit storage dep = queue[idx];
324 
325             if (lastCycle.sub(idx) <= 33) {
326                 uint percent = lastCycle - idx;
327             } else {
328                 percent = 33;
329             }
330 
331             uint128 amount = uint128(dep.deposit + (dep.deposit * percent / 100));
332 
333             if(refund > amount){
334                 dep.depositor.send(amount);
335                 refund -= amount;
336                 reserved -= amount;
337 
338                 emit Refunded(dep.depositor, amount, cycles - 1);
339                 delete queue[idx];
340             }else{
341                 dep.depositor.send(refund);
342                 reserved -= refund;
343                 currentRefundIndex = 0;
344 
345                 emit Refunded(dep.depositor, refund, cycles - 1);
346                 emit RefundCompleted(cycles - 1);
347                 break;
348             }
349 
350             if(gasleft() <= 100000)
351                 break;
352         }
353 
354         if (currentRefundIndex != 0) {
355             currentRefundIndex -= i;
356         }
357     }
358 
359     function singleRefunding() private {
360         Deposit storage dep = queue[queue.length - 1];
361         uint amount = dep.deposit * 2 / 100 + dep.expect;
362         if (reserved < amount) {
363             amount = reserved;
364         }
365         dep.depositor.send(amount);
366         reserved -= amount;
367         emit Refunded(dep.depositor, amount, cycles - 1);
368         delete queue[queue.length - 1];
369         emit RefundCompleted(cycles - 1);
370     }
371 
372     //Get the deposit info by its index
373     //You can get deposit index from
374     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
375         Deposit storage dep = queue[idx];
376         return (dep.depositor, dep.deposit, dep.expect);
377     }
378 
379     //Get the count of deposits of specific investor
380     function getDepositsCount(address depositor) public view returns (uint) {
381         uint c = 0;
382         for(uint i=currentReceiverIndex; i<queue.length; ++i){
383             if(queue[i].depositor == depositor)
384                 c++;
385         }
386         return c;
387     }
388 
389     //Get all deposits (index, deposit, expect) of a specific investor
390     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
391         uint c = getDepositsCount(depositor);
392 
393         idxs = new uint[](c);
394         deposits = new uint128[](c);
395         expects = new uint128[](c);
396 
397         if(c > 0) {
398             uint j = 0;
399             for(uint i=currentReceiverIndex; i<queue.length; ++i){
400                 Deposit storage dep = queue[i];
401                 if(dep.depositor == depositor){
402                     idxs[j] = i;
403                     deposits[j] = dep.deposit;
404                     expects[j] = dep.expect;
405                     j++;
406                 }
407             }
408         }
409     }
410 
411     //Get current queue size
412     function getQueueLength() public view returns (uint) {
413         return queue.length - currentReceiverIndex;
414     }
415 
416     function isContract(address addr) private view returns (bool) {
417         uint size;
418         assembly { size := extcodesize(addr) }
419         return size > 0;
420     }
421 
422     function contractBalance() external view returns(uint) {
423         return address(this).balance;
424     }
425 
426 }