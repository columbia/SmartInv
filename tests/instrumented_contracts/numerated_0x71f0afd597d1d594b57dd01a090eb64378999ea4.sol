1 /*
2 https://www.stiltonmusk.com
3 https://t.me/stiltonmusk
4 */
5 
6 
7 
8 
9 
10 // File: contracts/HasRandom.sol
11 
12 pragma solidity ^0.8.7;
13 
14 abstract contract HasRandom {
15     uint256 _randomNonce = 1;
16 
17     function _random() internal returns (uint256) {
18         return
19             uint256(
20                 keccak256(
21                     abi.encodePacked(
22                         msg.sender,
23                         _randomNonce++,
24                         block.timestamp
25                     )
26                 )
27             );
28     }
29 }
30 
31 // File: contracts/Ownable.sol
32 
33 abstract contract Ownable {
34     address _owner;
35 
36     modifier onlyOwner() {
37         require(msg.sender == _owner);
38         _;
39     }
40 
41     constructor() {
42         _owner = msg.sender;
43     }
44 
45     function transferOwnership(address newOwner) external onlyOwner {
46         _owner = newOwner;
47     }
48 }
49 
50 // File: contracts/IERC20.sol
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54 
55     function balanceOf(address account) external view returns (uint256);
56 
57     function transfer(address recipient, uint256 amount)
58         external
59         returns (bool);
60 
61     function allowance(address owner, address spender)
62         external
63         view
64         returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(
76         address indexed owner,
77         address indexed spender,
78         uint256 value
79     );
80 }
81 // File: contracts/IRouter.sol
82 
83 
84 
85 interface IRouter {
86     function roundNumber() external view returns (uint256);
87 
88     function token() external view returns (IERC20);
89 
90     function isWithdrawInterval() external view returns (bool);
91 
92     function interwalLapsedTime() external view returns (uint256);
93 
94     function poolAddress() external view returns (address);
95 }
96 
97 // File: contracts/Lottery.sol
98 
99 //import "hardhat/console.sol";
100 
101 
102 
103 
104 struct Ticket {
105     uint256 amount;
106     bool isClosed;
107 }
108 
109 contract Lottery is Ownable, HasRandom {
110     IERC20 public token;
111     uint256 public bidSize = 100000000;
112     uint256 public nextBidSize = 100000000;
113     uint256 public roundNumber = 1;
114     uint256 public bidsCount;
115     mapping(uint256 => Ticket[]) public tickets;
116     uint256 public ticketsRewards; // current round tickets summary reward
117     mapping(uint256 => mapping(address => uint256[])) ticketsByAccounts;
118     mapping(address => uint256) roundNumberByAccount;
119     mapping(address => bool) hasTicket;
120     uint256 public playersCount;
121     bool _isWithdrawInterval;
122     uint256 _nextIntervalTime;
123     uint256 public intervalTimerMin = 360;
124     address public cAASBankAddress;
125     uint256 cAASBankAddressPercent = 50;
126     uint256 public jackpot;
127     uint256 public lotteryFeePercent = 5;
128     uint256 jackpotN = 1000;
129     uint256 nextJackpotN;
130     bool public isOpened;    
131 
132     event OnJackpot(uint256 count, uint256 indexed roundNumber);
133 
134     constructor(address tokenAddress) {
135         token = IERC20(tokenAddress);
136         cAASBankAddress = address(this);
137         nextJackpotN = jackpotN;
138     }
139 
140     function setLotteryFeePercent(uint256 lotteryFeePercent_)
141         external
142         onlyOwner
143     {
144         require(lotteryFeePercent_ <= 90);
145         lotteryFeePercent = lotteryFeePercent_;
146     }
147 
148     function setOpenLottery(bool opened) external onlyOwner {
149         isOpened = opened;
150         _nextIntervalTime = block.timestamp + intervalTimerMin * 1 minutes;
151     }
152 
153     function setToken(address tokenAddress) external onlyOwner {
154         token = IERC20(tokenAddress);
155     }
156 
157     function setNextJackpotN(uint256 n) external onlyOwner {
158         nextJackpotN = n;
159     }
160 
161     function withdrawOwner() external onlyOwner {
162         token.transfer(_owner, token.balanceOf(address(this)));
163     }
164 
165     function setNextBidSize(uint256 nextBidSize_) external onlyOwner {
166         nextBidSize = nextBidSize_;
167         if (bidsCount == 0) bidSize = nextBidSize_;
168     }
169 
170     function setIntervalTimer(uint256 intervalTimerMin_) external onlyOwner {
171         intervalTimerMin = intervalTimerMin_;
172     }
173 
174     function setCAASBankAddress(address cAASBankAddress_) external onlyOwner {
175         cAASBankAddress = cAASBankAddress_;
176     }
177 
178     function setCAASBankAddressPercent(uint256 cAASBankAddressPercent_)
179         external
180         onlyOwner
181     {
182         require(cAASBankAddressPercent_ <= 100);
183         cAASBankAddressPercent = cAASBankAddressPercent_;
184     }
185 
186     function buyTicket() external {
187         _buyTickets(msg.sender, 1);
188     }
189 
190     function buyTickets(address account, uint256 count) external {
191         _buyTickets(account, count);
192     }
193 
194     function _buyTickets(address account, uint256 count) private {
195         require(count > 0, "count is zero");
196         require(isOpened, "lottery is not open");
197         tryNextInterval();
198         require(!_isWithdrawInterval, "only in game interval");
199         if (roundNumberByAccount[account] != roundNumber) clearData(account);
200 
201         token.transferFrom(account, address(this), bidSize * count);
202 
203         roundNumberByAccount[account] = roundNumber;
204         if (!hasTicket[account]) ++playersCount;
205         hasTicket[account] = true;
206         uint256 lastbTicketsCount = bidsCount;
207         bidsCount += count;
208         for (uint256 i = 0; i < count; ++i) {
209             tickets[roundNumber].push(Ticket(bidSize, false));
210             ticketsByAccounts[roundNumber][account].push(lastbTicketsCount + i);
211             arrangeRewards(lastbTicketsCount + i);
212         }
213     }
214 
215     function arrangeRewards(uint256 ticketA) private {
216         ticketsRewards += tickets[roundNumber][ticketA].amount;
217         tickets[roundNumber][ticketA].amount -=
218             (tickets[roundNumber][ticketA].amount * (lotteryFeePercent + 10)) /
219             100; // lottery fee + 10% token tax
220         uint256 random = _random();
221         uint256 currentTicketsCount = ticketA + 1;
222         uint256 ticketB = random % currentTicketsCount;
223         if (ticketB == ticketA) ticketB = (ticketB + 1) % currentTicketsCount;
224 
225         // jackpot
226         if (random % jackpotN == 0) {
227             emit OnJackpot(jackpot, roundNumber);
228             tickets[roundNumber][ticketB].amount += jackpot;
229             ticketsRewards += jackpot;
230             jackpot = 0;
231         }
232 
233         if (ticketB == ticketA) return;
234         uint256 percent = 1 + (random % 1000);
235         if (random % 2 == 0) {
236             uint256 delta = (tickets[roundNumber][ticketB].amount * percent) /
237                 1000;
238             tickets[roundNumber][ticketA].amount += delta;
239             tickets[roundNumber][ticketB].amount -= delta;
240         } else {
241             uint256 delta = (tickets[roundNumber][ticketA].amount * percent) /
242                 1000;
243             tickets[roundNumber][ticketA].amount -= delta;
244             tickets[roundNumber][ticketB].amount += delta;
245         }
246     }
247 
248     function clearData(address account) private {
249         hasTicket[account] = false;
250     }
251 
252     function getTicketsCount(address account) public view returns (uint256) {
253         if (
254             roundNumberByAccount[account] != roundNumber ||
255             (_isWithdrawInterval &&
256                 intervalLapsedTime() == 0 &&
257                 playersCount > 1) ||
258             (
259                 (!_isWithdrawInterval &&
260                     block.timestamp >=
261                     _nextIntervalTime + intervalTimerMin * 1 minutes &&
262                     playersCount > 1)
263             )
264         ) return 0;
265 
266         return ticketsByAccounts[roundNumber][account].length;
267     }
268 
269     function getTicket(address account, uint256 index)
270         public
271         view
272         returns (Ticket memory)
273     {
274         require(index < getTicketsCount(account), "bad ticketIndex");
275         return
276             tickets[roundNumber][
277                 ticketsByAccounts[roundNumber][account][index]
278             ];
279     }
280 
281     function getTickets(
282         address account,
283         uint256 startIndex,
284         uint256 count
285     ) external view returns (Ticket[] memory) {
286         Ticket[] memory ticketsList = new Ticket[](count);
287         require(
288             startIndex + count <= getTicketsCount(account),
289             "bad ticketIndex"
290         );
291         for (uint256 i = 0; i < count; ++i) {
292             ticketsList[i] = tickets[roundNumber][
293                 ticketsByAccounts[roundNumber][account][startIndex + i]
294             ];
295         }
296 
297         return ticketsList;
298     }
299 
300     function getAllTicketsListPage(uint256 startIndex, uint256 count)
301         external
302         view
303         returns (Ticket[] memory)
304     {
305         Ticket[] memory ticketsList = new Ticket[](count);
306         for (uint256 i = 0; i < count; ++i) {
307             ticketsList[i] = tickets[roundNumber][startIndex + i];
308         }
309 
310         return ticketsList;
311     }
312 
313     function closeTicket(address account, uint256 index) external {
314         _closeTickets(account, index, 1);
315     }
316 
317     function closeTickets(
318         address account,
319         uint256 startIndex,
320         uint256 count
321     ) external {
322         _closeTickets(account, startIndex, count);
323     }
324 
325     function _closeTickets(
326         address account,
327         uint256 startIndex,
328         uint256 count
329     ) private {
330         require(count > 0, "count is zero");
331         require(isOpened, "lottery is not open");
332         tryNextInterval();
333         require(_isWithdrawInterval, "only in withdraw interval");
334         uint256 toTransfer;
335         uint256 lastIndex = startIndex + count;
336         for (uint256 i = startIndex; i < lastIndex; ++i) {
337             Ticket storage ticket = tickets[roundNumber][
338                 ticketsByAccounts[roundNumber][account][i]
339             ];
340             if (ticket.isClosed) continue;
341             ticket.isClosed = true;
342             toTransfer += ticket.amount;
343         }
344         require(toTransfer > 0, "has no rewards");
345         token.transfer(account, toTransfer);
346     }
347 
348     function _newRound() private {
349         if (!isOpened) return;
350         _isWithdrawInterval = false;
351 
352         if (
353             playersCount > 1 ||
354             (playersCount == 1 && tickets[roundNumber][0].isClosed)
355         ) {
356             ++roundNumber;
357             bidSize = nextBidSize;
358             bidsCount = 0;
359             playersCount = 0;
360             ticketsRewards = 0;
361             uint256 balance = token.balanceOf(address(this));
362             if (balance > 0 && cAASBankAddress != address(this)) {
363                 uint256 toTransfer = ((token.balanceOf(address(this)) -
364                     jackpot) * cAASBankAddressPercent) / 100;
365                 token.transfer(cAASBankAddress, toTransfer);
366             }
367 
368             jackpot = token.balanceOf(address(this));
369             jackpotN = nextJackpotN;
370         }
371     }
372 
373     function tryNextInterval() public {
374         if (!isOpened) return;
375         // next interval
376         if (block.timestamp < _nextIntervalTime) return;
377 
378         // if skip reward interval
379         if (!_isWithdrawInterval) {
380             if (
381                 !_isWithdrawInterval &&
382                 block.timestamp >=
383                 _nextIntervalTime + intervalTimerMin * 1 minutes
384             ) {
385                 _nextIntervalTime =
386                     block.timestamp +
387                     intervalTimerMin *
388                     1 minutes;
389                 _newRound();
390                 return;
391             }
392             _nextIntervalTime = block.timestamp + intervalLapsedTime();
393         } else {
394             _nextIntervalTime = block.timestamp + intervalTimerMin * 1 minutes;
395         }
396 
397         // next interval
398         _isWithdrawInterval = !_isWithdrawInterval;
399         // next round
400         if (!_isWithdrawInterval) _newRound();
401     }
402 
403     /// @dev current intervallapsed time in seconds
404     function intervalLapsedTime() public view returns (uint256) {
405         // if timer
406         if (block.timestamp < _nextIntervalTime)
407             return _nextIntervalTime - block.timestamp;
408         // now withdraw interval (skipping withdraq interval)
409         if (
410             !_isWithdrawInterval &&
411             block.timestamp < _nextIntervalTime + intervalTimerMin * 1 minutes
412         )
413             return
414                 _nextIntervalTime +
415                 intervalTimerMin *
416                 1 minutes -
417                 block.timestamp;
418         // new interval
419         return 0;
420     }
421 
422     function isWithdrawInterval() external view returns (bool) {
423         // if timer
424         if (block.timestamp < _nextIntervalTime) return _isWithdrawInterval;
425         // now withdraw interval (skipping withdraq interval)
426         if (
427             !_isWithdrawInterval &&
428             block.timestamp >= _nextIntervalTime + intervalTimerMin * 1 minutes
429         ) return false;
430         // new interval
431         return !_isWithdrawInterval;
432     }
433 }