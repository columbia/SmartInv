1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // File: contracts/token/ERC20Cutted.sol
120 
121 contract ERC20Cutted {
122 
123   function balanceOf(address who) public view returns (uint256);
124 
125   function transfer(address to, uint256 value) public returns (bool);
126 
127 }
128 
129 // File: contracts/Room1.sol
130 
131 contract Room1 is Ownable {
132 
133   event TicketPurchased(address lotAddr, uint lotIndex, uint ticketNumber, address player, uint ticketPrice);
134 
135   event TicketWon(address lotAddr, uint lotIndex, uint ticketNumber, address player, uint win);
136 
137   event ParametersUpdated(uint lotIndex, address feeWallet, uint feePercent, uint starts, uint duration, uint interval, uint ticketPrice);
138 
139   using SafeMath for uint;
140 
141   uint diffRangeCounter = 0;
142 
143   uint public LIMIT = 100;
144 
145   uint public RANGE = 100000;
146 
147   uint public PERCENT_RATE = 100;
148 
149   enum LotState { Accepting, Processing, Rewarding, Finished }
150 
151   uint public interval;
152 
153   uint public duration;
154 
155   uint public starts;
156 
157   uint public ticketPrice;
158 
159   uint public feePercent;
160 
161   uint public lotProcessIndex;
162 
163   uint public lastChangesIndex;
164 
165   uint public MIN_DISPERSION_K = 10;
166 
167   address public feeWallet;
168 
169   mapping (address => uint) public summaryPayed;
170 
171   struct Ticket {
172     address owner;
173     uint number;
174     uint win;
175   }
176 
177   struct Lot {
178     LotState state;
179     uint processIndex;
180     uint summaryNumbers;
181     uint summaryInvested;
182     uint rewardBase;
183     uint ticketsCount;
184     uint playersCount;
185     mapping (uint => Ticket) tickets;
186     mapping (address => uint) invested;
187     address[] players;
188   }
189 
190   mapping(uint => Lot) public lots;
191 
192   modifier started() {
193     require(now >= starts, "Not started yet!");
194     _;
195   }
196 
197   modifier notContract(address to) {
198     uint codeLength;
199     assembly {
200       codeLength := extcodesize(to)
201     }
202     require(codeLength == 0, "Contracts not supported!");
203     _;
204   }
205 
206   function updateParameters(address newFeeWallet, uint newFeePercent, uint newStarts, uint newDuration, uint newInterval, uint newTicketPrice) public onlyOwner {
207     require(newStarts > now, "Lottery can only be started in the future!");
208     uint curLotIndex = getCurLotIndex();
209     Lot storage lot = lots[curLotIndex];
210     require(lot.state == LotState.Finished, "Contract parameters can only be changed if the current lottery is finished!");
211     lastChangesIndex = curLotIndex.add(1);
212     feeWallet = newFeeWallet;
213     feePercent = newFeePercent;
214     starts = newStarts;
215     duration = newDuration;
216     interval = newInterval;
217     ticketPrice = newTicketPrice;
218     emit ParametersUpdated(lastChangesIndex, newFeeWallet, newFeePercent, newStarts, newDuration, newInterval, newTicketPrice);
219   }
220 
221   function getLotInvested(uint lotNumber, address player) view public returns(uint) {
222     Lot storage lot = lots[lotNumber];
223     return lot.invested[player];
224   }
225 
226   function getTicketInfo(uint lotNumber, uint ticketNumber) view public returns(address, uint, uint) {
227     Ticket storage ticket = lots[lotNumber].tickets[ticketNumber];
228     return (ticket.owner, ticket.number, ticket.win);
229   }
230 
231   function getCurLotIndex() view public returns(uint) {
232     if (starts > now) {
233       return lastChangesIndex;
234     }
235     uint passed = now.sub(starts);
236     if(passed == 0)
237       return 0;
238     return passed.div(interval.add(duration)).add(lastChangesIndex);
239   }
240 
241   constructor() public {
242     starts = 1554026400;
243     ticketPrice = 10000000000000000;
244     feePercent = 10;
245     feeWallet = 0x53f22b8f420317e7cdcbf2a180a12534286cb578;
246     interval = 1800;
247     uint fullDuration = 3600;
248     duration = fullDuration.sub(interval);
249     emit ParametersUpdated(0, feeWallet, feePercent, starts, duration, interval, ticketPrice);
250   }
251 
252   function setFeeWallet(address newFeeWallet) public onlyOwner {
253     feeWallet = newFeeWallet;
254   }
255 
256   function getNotPayableTime(uint lotIndex) view public returns(uint) {
257     return starts.add(interval.add(duration).mul(lotIndex.add(1).sub(lastChangesIndex))).sub(interval);
258   }
259 
260   function () public payable notContract(msg.sender) started {
261     require(RANGE.mul(RANGE).mul(address(this).balance.add(msg.value)) > 0, "Balance limit error!");
262     require(msg.value >= ticketPrice, "Not enough funds to buy ticket!");
263     uint curLotIndex = getCurLotIndex();
264     require(now < getNotPayableTime(curLotIndex), "Game finished!");
265     Lot storage lot = lots[curLotIndex];
266     require(RANGE.mul(RANGE) > lot.ticketsCount, "Ticket count limit exceeded!");
267 
268     uint numTicketsToBuy = msg.value.div(ticketPrice);
269 
270     uint toInvest = ticketPrice.mul(numTicketsToBuy);
271 
272     if(lot.invested[msg.sender] == 0) {
273       lot.players.push(msg.sender);
274       lot.playersCount = lot.playersCount.add(1);
275     }
276 
277     lot.invested[msg.sender] = lot.invested[msg.sender].add(toInvest);
278 
279     for(uint i = 0; i < numTicketsToBuy; i++) {
280       lot.tickets[lot.ticketsCount].owner = msg.sender;
281       emit TicketPurchased(address(this), curLotIndex, lot.ticketsCount, msg.sender, ticketPrice);
282       lot.ticketsCount = lot.ticketsCount.add(1);
283     }
284 
285     lot.summaryInvested = lot.summaryInvested.add(toInvest);
286 
287     uint refund = msg.value.sub(toInvest);
288     msg.sender.transfer(refund);
289   }
290 
291   function canUpdate() view public returns(bool) {
292     if (starts > now) {
293       return false;
294     }
295     uint curLotIndex = getCurLotIndex();
296     Lot storage lot = lots[curLotIndex];
297     return lot.state == LotState.Finished;
298   }
299 
300   function isProcessNeeds() view public returns(bool) {
301     if (starts > now) {
302       return false;
303     }
304     uint curLotIndex = getCurLotIndex();
305     Lot storage lot = lots[curLotIndex];
306     return lotProcessIndex < curLotIndex || (now >= getNotPayableTime(lotProcessIndex) && lot.state != LotState.Finished);
307   }
308 
309   function pow(uint number, uint count) private returns(uint) {
310     uint result = number;
311     if (count == 0) return 1;
312     for (uint i = 1; i < count; i++) {
313       result = result.mul(number);
314     }
315     return result;
316   }
317 
318   function prepareToRewardProcess() public onlyOwner started {
319     Lot storage lot = lots[lotProcessIndex];
320 
321     if(lot.state == LotState.Accepting) {
322       require(now >= getNotPayableTime(lotProcessIndex), "Lottery stakes accepting time not finished!");
323       lot.state = LotState.Processing;
324     }
325 
326     require(lot.state == LotState.Processing || lot.state == LotState.Rewarding, "State should be Processing or Rewarding!");
327 
328     uint index = lot.processIndex;
329 
330     uint limit = lot.ticketsCount - index;
331     if(limit > LIMIT) {
332       limit = LIMIT;
333     }
334 
335     limit = limit.add(index);
336 
337     uint number;
338 
339     if(lot.state == LotState.Processing) {
340 
341       number = block.number;
342 
343       uint dispersionK = MIN_DISPERSION_K;
344 
345       uint diffRangeLimit = 0;
346 
347       if(limit > 0) {
348         diffRangeLimit = limit.div(dispersionK);
349         if(diffRangeLimit == 0) {
350           diffRangeLimit = 1;
351         }
352       }
353 
354       diffRangeCounter = 0;
355 
356       uint enlargedRange = RANGE.mul(dispersionK);
357 
358       bool enlargedWinnerGenerated = false;
359 
360       bool enlargedWinnerPrepared = false;
361 
362       uint enlargedWinnerIndex = 0;
363 
364       for(; index < limit; index++) {
365 
366         number = pow(uint(keccak256(abi.encodePacked(number)))%RANGE, 5);
367         lot.tickets[index].number = number;
368         lot.summaryNumbers = lot.summaryNumbers.add(number);
369 
370         if(!enlargedWinnerGenerated) {
371           enlargedWinnerIndex = uint(keccak256(abi.encodePacked(number)))%enlargedRange;
372           enlargedWinnerGenerated = true;
373         } if(!enlargedWinnerPrepared && diffRangeCounter == enlargedWinnerIndex) {
374           number = pow(uint(keccak256(abi.encodePacked(number)))%enlargedRange, 5);
375           lot.tickets[index].number = lot.tickets[index].number.add(number);
376           lot.summaryNumbers = lot.summaryNumbers.add(number);
377           enlargedWinnerGenerated = true;
378         }
379 
380         if(diffRangeCounter == diffRangeLimit) {
381           diffRangeCounter = 0;
382           enlargedWinnerPrepared = false;
383           enlargedWinnerGenerated = false;
384         }
385 
386         diffRangeCounter++;
387       }
388 
389       if(index == lot.ticketsCount) {
390         uint fee = lot.summaryInvested.mul(feePercent).div(PERCENT_RATE);
391         feeWallet.transfer(fee);
392         lot.rewardBase = lot.summaryInvested.sub(fee);
393         lot.state = LotState.Rewarding;
394         index = 0;
395       }
396 
397     } else {
398 
399       for(; index < limit; index++) {
400         Ticket storage ticket = lot.tickets[index];
401         number = ticket.number;
402         if(number > 0) {
403           ticket.win = lot.rewardBase.mul(number).div(lot.summaryNumbers);
404           if(ticket.win > 0) {
405             ticket.owner.transfer(ticket.win);
406             summaryPayed[ticket.owner] = summaryPayed[ticket.owner].add(ticket.win);
407             emit TicketWon(address(this), lotProcessIndex, index, ticket.owner, ticket.win);
408           }
409         }
410       }
411 
412       if(index == lot.ticketsCount) {
413         lot.state = LotState.Finished;
414         lotProcessIndex = lotProcessIndex.add(1);
415       }
416     }
417 
418     lot.processIndex = index;
419   }
420 
421   function retrieveTokens(address tokenAddr, address to) public onlyOwner {
422     ERC20Cutted token = ERC20Cutted(tokenAddr);
423     token.transfer(to, token.balanceOf(address(this)));
424   }
425 
426 }