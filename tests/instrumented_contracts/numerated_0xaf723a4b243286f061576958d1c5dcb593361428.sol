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
141   uint public LIMIT = 100;
142 
143   uint public RANGE = 1000000000;
144 
145   uint public PERCENT_RATE = 100;
146 
147   enum LotState { Accepting, Processing, Rewarding, Finished }
148 
149   uint public interval;
150 
151   uint public duration;
152 
153   uint public starts;
154 
155   uint public ticketPrice;
156 
157   uint public feePercent;
158 
159   uint public lotProcessIndex;
160 
161   uint public lastChangesIndex;
162 
163   address public feeWallet;
164 
165   mapping (address => uint) public summaryPayed;
166 
167   struct Ticket {
168     address owner;
169     uint number;
170     uint win;
171   }
172 
173   struct Lot {
174     LotState state;
175     uint processIndex;
176     uint summaryNumbers;
177     uint summaryInvested;
178     uint rewardBase;
179     uint ticketsCount;
180     uint playersCount;
181     mapping (uint => Ticket) tickets;
182     mapping (address => uint) invested;
183     address[] players;
184   }
185 
186   mapping(uint => Lot) public lots;
187 
188   modifier started() {
189     require(now >= starts, "Not started yet!");
190     _;
191   }
192 
193   modifier notContract(address to) {
194     uint codeLength;
195     assembly {
196       codeLength := extcodesize(to)
197     }
198     require(codeLength == 0, "Contracts not supported!");
199     _;
200   }
201 
202   function updateParameters(address newFeeWallet, uint newFeePercent, uint newStarts, uint newDuration, uint newInterval, uint newTicketPrice) public onlyOwner {
203     require(newStarts > now, "Lottery can only be started in the future!");
204     uint curLotIndex = getCurLotIndex();
205     Lot storage lot = lots[curLotIndex];
206     require(lot.state == LotState.Finished, "Contract parameters can only be changed if the current lottery is finished!");
207     lastChangesIndex = curLotIndex.add(1);
208     feeWallet = newFeeWallet;
209     feePercent = newFeePercent;
210     starts = newStarts;
211     duration = newDuration;
212     interval = newInterval;
213     ticketPrice = newTicketPrice;
214     emit ParametersUpdated(lastChangesIndex, newFeeWallet, newFeePercent, newStarts, newDuration, newInterval, newTicketPrice);
215   }
216 
217   function getLotInvested(uint lotNumber, address player) view public returns(uint) {
218     Lot storage lot = lots[lotNumber];
219     return lot.invested[player];
220   }
221 
222   function getTicketInfo(uint lotNumber, uint ticketNumber) view public returns(address, uint, uint) {
223     Ticket storage ticket = lots[lotNumber].tickets[ticketNumber];
224     return (ticket.owner, ticket.number, ticket.win);
225   }
226 
227   function getCurLotIndex() view public returns(uint) {
228     if (starts > now) {
229       return lastChangesIndex;
230     }
231     uint passed = now.sub(starts);
232     if(passed == 0)
233       return 0;
234     return passed.div(interval.add(duration)).add(lastChangesIndex);
235   }
236 
237   constructor() public {
238     starts = 1542922800;
239     ticketPrice = 10000000000000000;
240     feePercent = 30;
241     feeWallet = 0x0a6af11d0db7ac521719c216e4d18530da428b63;
242     interval = 3600;
243     uint fullDuration = 7200;
244     duration = fullDuration.sub(interval);
245     emit ParametersUpdated(1, feeWallet, feePercent, starts, duration, interval, ticketPrice);
246   }
247 
248   function setFeeWallet(address newFeeWallet) public onlyOwner {
249     feeWallet = newFeeWallet;
250   }
251 
252   function getNotPayableTime(uint lotIndex) view public returns(uint) {
253     return starts.add(interval.add(duration).mul(lotIndex.add(1).sub(lastChangesIndex))).sub(interval);
254   }
255 
256   function () public payable notContract(msg.sender) started {
257     require(RANGE.mul(RANGE).mul(address(this).balance.add(msg.value)) > 0, "Balance limit error!");
258     require(msg.value >= ticketPrice, "Not enough funds to buy ticket!");
259     uint curLotIndex = getCurLotIndex();
260     require(now < getNotPayableTime(curLotIndex), "Game finished!");
261     Lot storage lot = lots[curLotIndex];
262     require(RANGE.mul(RANGE) > lot.ticketsCount, "Ticket count limit exceeded!");
263 
264     uint numTicketsToBuy = msg.value.div(ticketPrice);
265 
266     uint toInvest = ticketPrice.mul(numTicketsToBuy);
267 
268     if(lot.invested[msg.sender] == 0) {
269       lot.players.push(msg.sender);
270       lot.playersCount = lot.playersCount.add(1);
271     }
272 
273     lot.invested[msg.sender] = lot.invested[msg.sender].add(toInvest);
274 
275     for(uint i = 0; i < numTicketsToBuy; i++) {
276       lot.tickets[lot.ticketsCount].owner = msg.sender;
277       emit TicketPurchased(address(this), curLotIndex, lot.ticketsCount, msg.sender, ticketPrice);
278       lot.ticketsCount = lot.ticketsCount.add(1);
279     }
280 
281     lot.summaryInvested = lot.summaryInvested.add(toInvest);
282 
283     uint refund = msg.value.sub(toInvest);
284     msg.sender.transfer(refund);
285   }
286 
287   function canUpdate() view public returns(bool) {
288     if (starts > now) {
289       return false;
290     }
291     uint curLotIndex = getCurLotIndex();
292     Lot storage lot = lots[curLotIndex];
293     return lot.state == LotState.Finished;
294   }
295 
296   function isProcessNeeds() view public returns(bool) {
297     if (starts > now) {
298       return false;
299     }
300     uint curLotIndex = getCurLotIndex();
301     Lot storage lot = lots[curLotIndex];
302     return lotProcessIndex < curLotIndex || (now >= getNotPayableTime(lotProcessIndex) && lot.state != LotState.Finished);
303   }
304 
305   function prepareToRewardProcess() public onlyOwner started {
306     Lot storage lot = lots[lotProcessIndex];
307 
308     if(lot.state == LotState.Accepting) {
309       require(now >= getNotPayableTime(lotProcessIndex), "Lottery stakes accepting time not finished!");
310       lot.state = LotState.Processing;
311     }
312 
313     require(lot.state == LotState.Processing || lot.state == LotState.Rewarding, "State should be Processing or Rewarding!");
314 
315     uint index = lot.processIndex;
316 
317     uint limit = lot.ticketsCount - index;
318     if(limit > LIMIT) {
319       limit = LIMIT;
320     }
321 
322     limit = limit.add(index);
323 
324     uint number;
325 
326     if(lot.state == LotState.Processing) {
327 
328       number = block.number;
329 
330       for(; index < limit; index++) {
331         number = uint(keccak256(abi.encodePacked(number)))%RANGE;
332         lot.tickets[index].number = number;
333         lot.summaryNumbers = lot.summaryNumbers.add(number);
334       }
335 
336       if(index == lot.ticketsCount) {
337         uint fee = lot.summaryInvested.mul(feePercent).div(PERCENT_RATE);
338         feeWallet.transfer(fee);
339         lot.rewardBase = lot.summaryInvested.sub(fee);
340         lot.state = LotState.Rewarding;
341         index = 0;
342       }
343 
344     } else {
345 
346       for(; index < limit; index++) {
347         Ticket storage ticket = lot.tickets[index];
348         number = ticket.number;
349         if(number > 0) {
350           ticket.win = lot.rewardBase.mul(number).div(lot.summaryNumbers);
351           if(ticket.win > 0) {
352             ticket.owner.transfer(ticket.win);
353             summaryPayed[ticket.owner] = summaryPayed[ticket.owner].add(ticket.win);
354             emit TicketWon(address(this), lotProcessIndex, index, ticket.owner, ticket.win);
355           }
356         }
357       }
358 
359       if(index == lot.ticketsCount) {
360         lot.state = LotState.Finished;
361         lotProcessIndex = lotProcessIndex.add(1);
362       }
363     }
364 
365     lot.processIndex = index;
366   }
367 
368   function retrieveTokens(address tokenAddr, address to) public onlyOwner {
369     ERC20Cutted token = ERC20Cutted(tokenAddr);
370     token.transfer(to, token.balanceOf(address(this)));
371   }
372 
373 }