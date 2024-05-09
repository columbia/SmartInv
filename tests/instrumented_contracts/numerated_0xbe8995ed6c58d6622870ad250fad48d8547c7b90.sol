1 pragma solidity >0.4.99 <0.6.0;
2 
3 library Zero {
4     function requireNotZero(address addr) internal pure {
5         require(addr != address(0), "require not zero address");
6     }
7 
8     function requireNotZero(uint val) internal pure {
9         require(val != 0, "require not zero value");
10     }
11 
12     function notZero(address addr) internal pure returns(bool) {
13         return !(addr == address(0));
14     }
15 
16     function isZero(address addr) internal pure returns(bool) {
17         return addr == address(0);
18     }
19 
20     function isZero(uint a) internal pure returns(bool) {
21         return a == 0;
22     }
23 
24     function notZero(uint a) internal pure returns(bool) {
25         return a != 0;
26     }
27 }
28 
29 library Address {
30     function toAddress(bytes memory source) internal pure returns(address addr) {
31         assembly { addr := mload(add(source,0x14)) }
32         return addr;
33     }
34 
35     function isNotContract(address addr) internal view returns(bool) {
36         uint length;
37         assembly { length := extcodesize(addr) }
38         return length == 0;
39     }
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48 
49     /**
50     * @dev Multiplies two numbers, reverts on overflow.
51     */
52     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         if (_a == 0) {
54             return 0;
55         }
56 
57         uint256 c = _a * _b;
58         require(c / _a == _b);
59 
60         return c;
61     }
62 
63     /**
64     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65     */
66     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
67         require(_b > 0); // Solidity only automatically asserts when dividing by 0
68         uint256 c = _a / _b;
69         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76     */
77     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
78         require(_b <= _a);
79         uint256 c = _a - _b;
80 
81         return c;
82     }
83 
84     /**
85     * @dev Adds two numbers, reverts on overflow.
86     */
87     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
88         uint256 c = _a + _b;
89         require(c >= _a);
90 
91         return c;
92     }
93 
94 }
95 
96 contract Accessibility {
97     address private owner;
98     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
99 
100     modifier onlyOwner() {
101         require(msg.sender == owner, "access denied");
102         _;
103     }
104 
105     constructor() public {
106         owner = msg.sender;
107     }
108 
109     function changeOwner(address _newOwner) onlyOwner public {
110         require(_newOwner != address(0));
111         emit OwnerChanged(owner, _newOwner);
112         owner = _newOwner;
113     }
114 }
115 
116 
117 contract TicketsStorage is Accessibility  {
118     using SafeMath for uint;
119 
120     struct Ticket {
121         address payable wallet;
122         bool isWinner;
123         uint numberTicket;
124     }
125 
126     uint private entropyNumber = 121;
127 
128     mapping (uint => uint) private countTickets;
129     // currentRound -> number ticket
130 
131     mapping (uint => mapping (uint => Ticket)) private tickets;
132     // currentRound -> number ticket -> Ticket
133 
134     mapping (uint => mapping (address => uint)) private balancePlayer;
135     // currentRound -> wallet -> balance player
136 
137     mapping (address => mapping (uint => uint)) private balanceWinner;
138     // wallet -> balance winner
139 
140     event LogHappyTicket(uint roundLottery, uint happyTicket);
141 
142     function checkWinner(uint round, uint numberTicket) public view returns (bool) {
143         return tickets[round][numberTicket].isWinner;
144     }
145 
146     function getBalancePlayer(uint round, address wallet) public view returns (uint) {
147         return balancePlayer[round][wallet];
148     }
149 
150     function ticketInfo(uint round, uint index) public view returns(address payable wallet, bool isWinner, uint numberTicket) {
151         Ticket memory ticket = tickets[round][index];
152         wallet = ticket.wallet;
153         isWinner = ticket.isWinner;
154         numberTicket = ticket.numberTicket;
155     }
156 
157     function newTicket(uint round, address payable wallet, uint priceOfToken) public onlyOwner {
158         countTickets[round]++;
159         Ticket storage ticket = tickets[round][countTickets[round]];
160         ticket.wallet = wallet;
161         ticket.numberTicket = countTickets[round];
162         balancePlayer[round][wallet] = balancePlayer[round][wallet].add(priceOfToken);
163     }
164 
165     function clearRound(uint round) public {
166         countTickets[round] = 0;
167         if (entropyNumber == 330) {
168             entropyNumber = 121;
169         }
170     }
171 
172     function getCountTickets(uint round) public view returns (uint) {
173         return countTickets[round];
174     }
175 
176     function addBalanceWinner(uint round, uint amountPrize, uint happyNumber) public onlyOwner {
177         address walletTicket = tickets[round][happyNumber].wallet;
178         balanceWinner[walletTicket][round] = balanceWinner[walletTicket][round].add(amountPrize);
179         tickets[round][happyNumber].isWinner = true;
180     }
181 
182     function getBalanceWinner(address wallet, uint round) public view returns (uint) {
183         return balanceWinner[wallet][round];
184     }
185 
186     function findHappyNumber(uint round, uint typeStep) public onlyOwner returns(uint) {
187         require(countTickets[round] > 0, "number of tickets must be greater than 0");
188         uint happyNumber = 0;
189         if (typeStep == 3) {
190             happyNumber = getRandomNumber(11);
191         } else if (typeStep == 1) {
192             happyNumber = getRandomNumber(3);
193         } else if (typeStep == 2) {
194             happyNumber = getRandomNumber(6);
195         } else {
196             happyNumber = getRandomNumber(2);
197         }
198         emit LogHappyTicket(round, happyNumber);
199         return happyNumber;
200     }
201 
202     function getRandomNumber(uint step) internal returns(uint) {
203         entropyNumber = entropyNumber.add(1);
204         uint randomFirst = maxRandom(block.number, msg.sender).div(now);
205         uint randomNumber = randomFirst.mul(entropyNumber) % (66);
206         randomNumber = randomNumber % step;
207         return randomNumber + 1;
208     }
209 
210     function maxRandom(uint blockn, address entropyAddress) internal view returns (uint randomNumber) {
211         return uint(keccak256(
212                 abi.encodePacked(
213                     blockhash(blockn),
214                     entropyAddress)
215             ));
216     }
217 
218 }
219 
220 contract SundayLottery is Accessibility {
221     using SafeMath for uint;
222 
223     using Address for *;
224     using Zero for *;
225 
226     TicketsStorage private m_tickets;
227     mapping (address => bool) private notUnigue;
228 
229     enum StepLottery {TWO, THREE, SIX, ELEVEN}
230     StepLottery stepLottery;
231     uint[] private step = [2, 3, 6, 11];
232     uint[] private priceTicket = [0.05 ether, 0.02 ether, 0.01 ether, 0.01 ether];
233     uint[] private prizePool = [0.09 ether, 0.05 ether, 0.05 ether, 0.1 ether];
234 
235     address payable public administrationWallet;
236 
237     uint private canBuyTickets = 0;
238 
239     uint public priceOfToken = 0.01 ether;
240 
241     uint private amountPrize;
242 
243     uint public currentRound;
244     uint public totalEthRaised;
245     uint public totalTicketBuyed;
246 
247     uint public uniquePlayer;
248 
249     // more events for easy read from blockchain
250     event LogNewTicket(address indexed addr, uint when, uint round, uint price);
251     event LogBalanceChanged(uint when, uint balance);
252     event LogChangeTime(uint newDate, uint oldDate);
253     event LogRefundEth(address indexed player, uint value);
254     event LogWinnerDefine(uint roundLottery, address indexed wallet, uint happyNumber);
255     event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);
256     event SendToAdministrationWallet(uint balanceContract);
257 
258     modifier balanceChanged {
259         _;
260         emit LogBalanceChanged(getCurrentDate(), address(this).balance);
261     }
262 
263     modifier notFromContract() {
264         require(msg.sender.isNotContract(), "only externally accounts");
265         _;
266     }
267 
268     constructor(address payable _administrationWallet, uint _step) public {
269         require(_administrationWallet != address(0));
270         administrationWallet = _administrationWallet;
271         m_tickets = new TicketsStorage();
272         currentRound = 1;
273         m_tickets.clearRound(currentRound);
274         setStepLottery(_step);
275     }
276 
277     function() external payable {
278         if (msg.value >= priceOfToken) {
279             buyTicket(msg.sender);
280         } else {
281             refundEth(msg.sender, msg.value);
282         }
283     }
284 
285     function buyTicket(address payable _addressPlayer) public payable notFromContract balanceChanged returns (uint buyTickets) {
286         uint investment = msg.value;
287         require(investment >= priceOfToken, "investment must be >= PRICE OF TOKEN");
288 
289         uint tickets = investment.div(priceOfToken);
290         if (tickets > canBuyTickets) {
291             tickets = canBuyTickets;
292             canBuyTickets = 0;
293         } else {
294             canBuyTickets = canBuyTickets.sub(tickets);
295         }
296 
297         uint requireEth = tickets.mul(priceOfToken);
298         if (investment > requireEth) {
299             refundEth(msg.sender, investment.sub(requireEth));
300         }
301 
302         buyTickets = tickets;
303         if (tickets > 0) {
304             uint currentDate = now;
305             while (tickets != 0) {
306                 m_tickets.newTicket(currentRound, _addressPlayer, priceOfToken);
307                 emit LogNewTicket(_addressPlayer, currentDate, currentRound, priceOfToken);
308                 totalTicketBuyed++;
309                 tickets--;
310             }
311         }
312 
313         if (!notUnigue[_addressPlayer]) {
314             notUnigue[_addressPlayer] = true;
315             uniquePlayer++;
316         }
317         totalEthRaised = totalEthRaised.add(requireEth);
318 
319         if (canBuyTickets.isZero()) {
320             makeTwists();
321         }
322     }
323 
324     function makeTwists() internal notFromContract {
325         play(currentRound);
326         sendToAdministration();
327         canBuyTickets = step[getStepLottery()];
328         currentRound++;
329         m_tickets.clearRound(currentRound);
330     }
331 
332     function play(uint round) internal {
333         if (address(this).balance >= amountPrize) {
334             uint happyNumber = m_tickets.findHappyNumber(round, getStepLottery());
335             m_tickets.addBalanceWinner(currentRound, amountPrize, happyNumber);
336             (address payable wallet,,) =  m_tickets.ticketInfo(round, happyNumber);
337             wallet.transfer(amountPrize);
338             emit LogWinnerDefine(round, wallet, happyNumber);
339         }
340     }
341 
342     function setStepLottery(uint newStep) public onlyOwner {
343         require(uint(StepLottery.ELEVEN) >= newStep);
344         require(getCountTickets(currentRound) == 0);
345         stepLottery = StepLottery(newStep);
346         initCanBuyTicket();
347     }
348 
349     function getStepLottery() public view returns (uint currentStep) {
350         currentStep = uint(stepLottery);
351     }
352 
353     function initCanBuyTicket() internal {
354         uint currentStepLottery = getStepLottery();
355         canBuyTickets = step[currentStepLottery];
356         priceOfToken = priceTicket[currentStepLottery];
357         amountPrize = prizePool[currentStepLottery];
358     }
359 
360     function getTicketInfo(uint round, uint index) public view returns (address payable wallet, bool isWinner, uint numberTicket) {
361         (wallet, isWinner, numberTicket) =  m_tickets.ticketInfo(round, index);
362     }
363 
364     function balanceETH() external view returns(uint) {
365         return address(this).balance;
366     }
367 
368     function refundEth(address payable _player, uint _value) internal returns (bool) {
369         require(_player.notZero());
370         _player.transfer(_value);
371         emit LogRefundEth(_player, _value);
372     }
373 
374     function getBalancePlayer(uint round, address wallet) external view returns (uint) {
375         return m_tickets.getBalancePlayer(round, wallet);
376     }
377 
378     function getBalanceWinner(address wallet, uint round) external view returns (uint) {
379         return m_tickets.getBalanceWinner(wallet, round);
380     }
381 
382     function checkWinner(uint round, uint numberTicket) public view returns (bool) {
383         return m_tickets.checkWinner(round, numberTicket);
384     }
385 
386     function getCurrentDate() public view returns (uint) {
387         return now;
388     }
389 
390     function getCountTickets(uint round) public view returns (uint countTickets) {
391         countTickets = m_tickets.getCountTickets(round);
392     }
393 
394     function setAdministrationWallet(address payable _newWallet) external onlyOwner {
395         require(_newWallet != address(0));
396         address payable _oldWallet = administrationWallet;
397         administrationWallet = _newWallet;
398         emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);
399     }
400 
401     function sendToAdministration() internal {
402         require(administrationWallet != address(0), "address of wallet is 0x0");
403         uint amount = address(this).balance;
404 
405         if (amount > 0) {
406             if (administrationWallet.send(amount)) {
407                 emit SendToAdministrationWallet(amount);
408             }
409         }
410     }
411 
412 }