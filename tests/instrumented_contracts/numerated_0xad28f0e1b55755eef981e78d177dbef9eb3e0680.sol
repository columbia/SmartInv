1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Restriction {
37     mapping (address => bool) internal accesses;
38 
39     function Restriction() public {
40         accesses[msg.sender] = true;
41     }
42 
43     function giveAccess(address _addr) public restricted {
44         accesses[_addr] = true;
45     }
46 
47     function removeAccess(address _addr) public restricted {
48         delete accesses[_addr];
49     }
50 
51     function hasAccess() public constant returns (bool) {
52         return accesses[msg.sender];
53     }
54 
55     modifier restricted() {
56         require(hasAccess());
57         _;
58     }
59 }
60 
61 contract DreamConstants {
62     uint constant MINIMAL_DREAM = 3 ether;
63     uint constant TICKET_PRICE = 0.1 ether;
64     uint constant MAX_TICKETS = 2**32;
65     uint constant MAX_AMOUNT = 2**32 * TICKET_PRICE;
66     uint constant DREAM_K = 2;
67     uint constant ACCURACY = 10**18;
68     uint constant REFUND_AFTER = 90 days;
69 }
70 
71 contract TicketHolder is Restriction, DreamConstants {
72     struct Ticket {
73         uint32 ticketAmount;
74         uint32 playerIndex;
75         uint dreamAmount;
76     }
77 
78     uint64 public totalTickets;
79     uint64 public maxTickets;
80 
81     mapping (address => Ticket) internal tickets;
82 
83     address[] internal players;
84 
85     function TicketHolder(uint _maxTickets) {
86         maxTickets = uint64(_maxTickets);
87     }
88 
89     /**
90      * @dev Issue tickets for the specified address.
91      * @param _addr Receiver address.
92      * @param _ticketAmount Amount of tickets to issue.
93      * @param _dreamAmount Amount of dream or zero, if use previous.
94      */
95     function issueTickets(address _addr, uint _ticketAmount, uint _dreamAmount) public restricted {
96         require(_ticketAmount <= MAX_TICKETS);
97         require(totalTickets <= maxTickets);
98         Ticket storage ticket = tickets[_addr];
99 
100         // if fist issue for this user
101         if (ticket.ticketAmount == 0) {
102             require(_dreamAmount >= MINIMAL_DREAM);
103             ticket.dreamAmount = _dreamAmount;
104             ticket.playerIndex = uint32(players.length);
105             players.push(_addr);
106         }
107 
108 
109         // add new ticket amount
110         ticket.ticketAmount += uint32(_ticketAmount);
111         // check to overflow
112         require(ticket.ticketAmount >= _ticketAmount);
113 
114         // cal total
115         totalTickets += uint64(_ticketAmount);
116         // check to overflow
117         require(totalTickets >= _ticketAmount);
118     }
119 
120     function setWinner(address _addr) public restricted {
121         Ticket storage ticket = tickets[_addr];
122         require(ticket.ticketAmount != 0);
123         ticket.ticketAmount = 0;
124     }
125 
126     function getTickets(uint index) public constant returns (address addr, uint ticketAmount, uint dreamAmount) {
127         if (players.length == 0) {
128             return;
129         }
130         if (index > players.length - 1) {
131             return;
132         }
133 
134         addr = players[index];
135         Ticket storage ticket = tickets[addr];
136         ticketAmount = ticket.ticketAmount;
137         dreamAmount = ticket.dreamAmount;
138     }
139 
140     function getTicketsByAddress(address _addr) public constant returns (uint playerIndex, uint ticketAmount, uint dreamAmount) {
141         Ticket storage ticket = tickets[_addr];
142         playerIndex = ticket.playerIndex;
143         ticketAmount = ticket.ticketAmount;
144         dreamAmount = ticket.dreamAmount;
145     }
146 
147     function getPlayersCount() public constant returns (uint) {
148         return players.length;
149     }
150 }
151 
152 contract Fund is Restriction, DreamConstants {
153     using SafeMath for uint256;
154 
155     mapping (address => uint) public balances;
156 
157     event Pay(address receiver, uint amount);
158     event Refund(address receiver, uint amount);
159 
160     // how many funds are collected
161     uint public totalAmount;
162     // how many funds are payed as prize
163     uint internal totalPrizeAmount;
164     // absolute refund date
165     uint32 internal refundDate;
166     // user who will receive all funds
167     address internal beneficiary;
168 
169     function Fund(uint _absoluteRefundDate, address _beneficiary) public {
170         refundDate = uint32(_absoluteRefundDate);
171         beneficiary = _beneficiary;
172     }
173 
174     function deposit(address _addr) public payable restricted {
175         uint balance = balances[_addr];
176 
177         balances[_addr] = balance.add(msg.value);
178         totalAmount = totalAmount.add(msg.value);
179     }
180 
181     function withdraw(uint amount) public restricted {
182         beneficiary.transfer(amount);
183     }
184 
185     /**
186      * @dev Pay from fund to the specified address only if not payed already.
187      * @param _addr Address to pay.
188      * @param _amountWei Amount to pay.
189      */
190     function pay(address _addr, uint _amountWei) public restricted {
191         // we have enough funds
192         require(this.balance >= _amountWei);
193         require(balances[_addr] != 0);
194         delete balances[_addr];
195         totalPrizeAmount = totalPrizeAmount.add(_amountWei);
196         // send funds
197         _addr.transfer(_amountWei);
198         Pay(_addr, _amountWei);
199     }
200 
201     /**
202      * @dev If funds already payed to the specified address.
203      * @param _addr Address to check.
204      */
205     function isPayed(address _addr) public constant returns (bool) {
206         return balances[_addr] == 0;
207     }
208 
209     function enableRefund() public restricted {
210         require(refundDate > uint32(block.timestamp));
211         refundDate = uint32(block.timestamp);
212     }
213 
214     function refund(address _addr) public restricted {
215         require(refundDate >= uint32(block.timestamp));
216         require(balances[_addr] != 0);
217         uint amount = refundAmount(_addr);
218         delete balances[_addr];
219         _addr.transfer(amount);
220         Refund(_addr, amount);
221     }
222 
223     function refundAmount(address _addr) public constant returns (uint) {
224         uint balance = balances[_addr];
225         uint restTotal = totalAmount.sub(totalPrizeAmount);
226         uint share = balance.mul(ACCURACY).div(totalAmount);
227         return restTotal.mul(share).div(ACCURACY);
228     }
229 }
230 
231 contract RandomOraclizeProxyI {
232     function requestRandom(function (bytes32) external callback, uint _gasLimit) public payable;
233     function getRandomPrice(uint _gasLimit) public constant returns (uint);
234 }
235 contract CompaniesManagerInterface {
236     function processing(address player, uint amount, uint ticketCount, uint totalTickets) public;
237 }
238 
239 
240 
241 contract TicketSale is Restriction, DreamConstants {
242     using SafeMath for uint256;
243     uint constant RANDOM_GAS = 1000000;
244 
245     TicketHolder public ticketHolder;
246     Fund public fund;
247     RandomOraclizeProxyI private proxy;
248     CompaniesManagerInterface public companiesManager;
249     bytes32[] public randomNumbers;
250 
251     uint32 public endDate;
252 
253     function TicketSale(uint _endDate, address _proxy, address _beneficiary, uint _maxTickets) public {
254         require(_endDate > block.timestamp);
255         require(_beneficiary != 0);
256         uint refundDate = block.timestamp + REFUND_AFTER;
257         // end date mist be less then refund
258         require(_endDate < refundDate);
259 
260         ticketHolder = new TicketHolder(_maxTickets);
261         ticketHolder.giveAccess(msg.sender);
262 
263         fund = new Fund(refundDate, _beneficiary);
264         fund.giveAccess(msg.sender);
265 
266         endDate = uint32(_endDate);
267         proxy = RandomOraclizeProxyI(_proxy);
268     }
269 
270     function buyTickets(uint _dreamAmount) public payable {
271         buyTicketsInternal(msg.sender, msg.value, _dreamAmount);
272     }
273 
274     function buyTicketsFor(address _addr, uint _dreamAmount) public payable {
275         buyTicketsInternal(_addr, msg.value, _dreamAmount);
276     }
277 
278     function buyTicketsInternal(address _addr, uint _valueWei, uint _dreamAmount) internal notEnded {
279         require(_valueWei >= TICKET_PRICE);
280         require(checkDream(_dreamAmount));
281 
282         uint change = _valueWei % TICKET_PRICE;
283         uint weiAmount = _valueWei - change;
284         uint ticketCount = weiAmount.div(TICKET_PRICE);
285 
286         if (address(companiesManager) != 0) {
287             uint totalTickets = ticketHolder.totalTickets();
288             companiesManager.processing(_addr, weiAmount, ticketCount, totalTickets);
289         }
290 
291         // issue right amount of tickets
292         ticketHolder.issueTickets(_addr, ticketCount, _dreamAmount);
293 
294         // transfer to fund
295         fund.deposit.value(weiAmount)(_addr);
296 
297         // return change
298         if (change != 0) {
299             msg.sender.transfer(change);
300         }
301     }
302 
303     // server integration methods
304 
305     function refund() public {
306         fund.refund(msg.sender);
307     }
308 
309     /**
310      * @dev Send funds to player by index. In case server calculate all.
311      * @param _playerIndex The winner player index.
312      * @param _amountWei Amount of prize in wei.
313      */
314     function payout(uint _playerIndex, uint _amountWei) public restricted ended {
315         address playerAddress;
316         uint ticketAmount;
317         uint dreamAmount;
318         (playerAddress, ticketAmount, dreamAmount) = ticketHolder.getTickets(_playerIndex);
319         require(playerAddress != 0);
320 
321         // pay the player's dream
322         fund.pay(playerAddress, _amountWei);
323     }
324 
325     /**
326      * @dev If funds already payed to the specified player by index.
327      * @param _playerIndex Player index.
328      */
329     function isPayed(uint _playerIndex) public constant returns (bool) {
330         address playerAddress;
331         uint ticketAmount;
332         uint dreamAmount;
333         (playerAddress, ticketAmount, dreamAmount) = ticketHolder.getTickets(_playerIndex);
334         require(playerAddress != 0);
335         return fund.isPayed(playerAddress);
336     }
337 
338     /**
339      * @dev Server method. Finish lottery (force finish if required), enable refund.
340      */
341     function finish() public restricted {
342         // force end
343         if (endDate > uint32(block.timestamp)) {
344             endDate = uint32(block.timestamp);
345         }
346     }
347 
348     // random integration
349     function requestRandom() public payable restricted {
350         uint price = proxy.getRandomPrice(RANDOM_GAS);
351         require(msg.value >= price);
352         uint change = msg.value - price;
353         proxy.requestRandom.value(price)(this.random_callback, RANDOM_GAS);
354         if (change > 0) {
355             msg.sender.transfer(change);
356         }
357     }
358 
359     function random_callback(bytes32 _randomNumbers) external {
360         require(msg.sender == address(proxy));
361         randomNumbers.push(_randomNumbers);
362     }
363 
364     // companies integration
365     function setCompanyManager(address _addr) public restricted {
366         companiesManager = CompaniesManagerInterface(_addr);
367     }
368 
369     // constant methods
370     function isEnded() public constant returns (bool) {
371         return block.timestamp > endDate;
372     }
373 
374     function checkDream(uint _dreamAmount) internal constant returns (bool) {
375         return
376             _dreamAmount == 0 ||
377             _dreamAmount == 3 ether ||
378             _dreamAmount == 5 ether ||
379             _dreamAmount == 7 ether ||
380             _dreamAmount == 10 ether ||
381             _dreamAmount == 15 ether ||
382             _dreamAmount == 20 ether ||
383             _dreamAmount == 30 ether ||
384             _dreamAmount == 40 ether ||
385             _dreamAmount == 50 ether ||
386             _dreamAmount == 75 ether ||
387             _dreamAmount == 100 ether ||
388             _dreamAmount == 150 ether ||
389             _dreamAmount == 200 ether ||
390             _dreamAmount == 300 ether ||
391             _dreamAmount == 400 ether ||
392             _dreamAmount == 500 ether ||
393             _dreamAmount == 750 ether ||
394             _dreamAmount == 1000 ether ||
395             _dreamAmount == 1500 ether ||
396             _dreamAmount == 2000 ether ||
397             _dreamAmount == 2500 ether;
398     }
399 
400     modifier notEnded() {
401         require(!isEnded());
402         _;
403     }
404 
405     modifier ended() {
406         require(isEnded());
407         _;
408     }
409 
410     function randomCount() public constant returns (uint) {
411         return randomNumbers.length;
412     }
413 
414     function getRandomPrice() public constant returns (uint) {
415         return proxy.getRandomPrice(RANDOM_GAS);
416     }
417 
418 }