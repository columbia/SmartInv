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
99 
100 
101 
102 
103 struct Ticket {
104     uint256 amount;
105     bool isClosed;
106 }
107 
108 contract Lottery is Ownable, HasRandom {
109     IERC20 public token;
110     uint256 public bidSize = 100000000;
111     uint256 public nextBidSize = 100000000;
112     uint256 public roundNumber = 1;
113     uint256 public bidsCount;
114     Ticket[] public tickets;
115     uint256 public ticketsRewards; // current round tickets summary reward
116     mapping(address => uint256[]) ticketsByAccounts;
117     mapping(address => uint256) roundNumberByAccount;
118     mapping(address => bool) hasTicket;
119     uint256 public playersCount;
120     bool _isWithdrawInterval;
121     uint256 _nextIntervalTime;
122     uint256 public intervalTimerMin = 360;
123     address public cAASBankAddress;
124     uint256 cAASBankAddressPercent = 50;
125     uint256 public jackpot;
126     uint256 public lotteryFeePercent = 5;
127     uint256 jackpotN = 1000;
128     uint256 nextJackpotN;
129     bool public isOpened;
130 
131     event OnJackpot(uint256 count, uint256 indexed roundNumber);
132 
133     constructor(address tokenAddress) {
134         token = IERC20(tokenAddress);
135         cAASBankAddress = address(this);
136         nextJackpotN = jackpotN;
137     }
138 
139     function setLotteryFeePercent(uint256 lotteryFeePercent_)
140         external
141         onlyOwner
142     {
143         require(lotteryFeePercent_ <= 90);
144         lotteryFeePercent = lotteryFeePercent_;
145     }
146 
147     function setOpenLottery(bool opened) external onlyOwner {
148         isOpened = opened;
149         _nextIntervalTime = block.timestamp + intervalTimerMin * 1 minutes;
150     }
151 
152     function setToken(address tokenAddress) external onlyOwner {
153         token = IERC20(tokenAddress);
154     }
155 
156     function setNextJackpotN(uint256 n) external onlyOwner {
157         nextJackpotN = n;
158     }
159 
160     function withdrawOwner() external onlyOwner {
161         token.transfer(_owner, token.balanceOf(address(this)));
162     }
163 
164     function setNextBidSize(uint256 nextBidSize_) external onlyOwner {
165         nextBidSize = nextBidSize_;
166         if (bidsCount == 0) bidSize = nextBidSize_;
167     }
168 
169     function setIntervalTimer(uint256 intervalTimerMin_) external onlyOwner {
170         intervalTimerMin = intervalTimerMin_;
171     }
172 
173     function setCAASBankAddress(address cAASBankAddress_) external onlyOwner {
174         cAASBankAddress = cAASBankAddress_;
175     }
176 
177     function setCAASBankAddressPercent(uint256 cAASBankAddressPercent_)
178         external
179         onlyOwner
180     {
181         require(cAASBankAddressPercent_ <= 100);
182         cAASBankAddressPercent = cAASBankAddressPercent_;
183     }
184 
185     function buyTicket() external {
186         _buyTickets(msg.sender, 1);
187     }
188 
189     function buyTickets(address account, uint256 count) external {
190         _buyTickets(account, count);
191     }
192 
193     function _buyTickets(address account, uint256 count) private {
194         require(count > 0, "count is zero");
195         require(isOpened, "lottery is not open");
196         tryNextInterval();
197         require(!_isWithdrawInterval, "only in game interval");
198         if (roundNumberByAccount[account] != roundNumber) clearData(account);
199 
200         token.transferFrom(account, address(this), bidSize * count);
201 
202         roundNumberByAccount[account] = roundNumber;
203         if (!hasTicket[account]) ++playersCount;
204         hasTicket[account] = true;
205         uint256 lastbTicketsCount = bidsCount;
206         bidsCount += count;
207         for (uint256 i = 0; i < count; ++i) {
208             tickets.push(Ticket(bidSize, false));
209             ticketsByAccounts[account].push(lastbTicketsCount + i);
210             arrangeRewards(lastbTicketsCount + i);
211         }
212     }
213 
214     function arrangeRewards(uint256 ticketA) private {
215         ticketsRewards += tickets[ticketA].amount;
216         tickets[ticketA].amount -=
217             (tickets[ticketA].amount * (lotteryFeePercent + 10)) /
218             100; // lottery fee + 10% token tax
219         uint256 random = _random();
220         uint256 currentTicketsCount = ticketA + 1;
221         uint256 ticketB = random % currentTicketsCount;
222         if (ticketB == ticketA) ticketB = (ticketB + 1) % currentTicketsCount;
223 
224         // jackpot
225         if (random % jackpotN == 0) {
226             emit OnJackpot(jackpot, roundNumber);
227             tickets[ticketB].amount += jackpot;
228             ticketsRewards += jackpot;
229             jackpot = 0;
230         }
231 
232         if (ticketB == ticketA) return;
233         uint256 percent = 1 + (random % 1000);
234         if (random % 2 == 0) {
235             uint256 delta = (tickets[ticketB].amount * percent) / 1000;
236             tickets[ticketA].amount += delta;
237             tickets[ticketB].amount -= delta;
238         } else {
239             uint256 delta = (tickets[ticketA].amount * percent) / 1000;
240             tickets[ticketA].amount -= delta;
241             tickets[ticketB].amount += delta;
242         }
243     }
244 
245     function clearData(address account) private {
246         delete ticketsByAccounts[account];
247         hasTicket[account] = false;
248     }
249 
250     function getTicketsCount(address account) public view returns (uint256) {
251         if (
252             roundNumberByAccount[account] != roundNumber ||
253             (_isWithdrawInterval &&
254                 intervalLapsedTime() == 0 &&
255                 playersCount > 1) ||
256             (
257                 (!_isWithdrawInterval &&
258                     block.timestamp >=
259                     _nextIntervalTime + intervalTimerMin * 1 minutes &&
260                     playersCount > 1)
261             )
262         ) return 0;
263 
264         return ticketsByAccounts[account].length;
265     }
266 
267     function getTicket(address account, uint256 index)
268         public
269         view
270         returns (Ticket memory)
271     {
272         require(index < getTicketsCount(account), "bad ticketIndex");
273         return tickets[ticketsByAccounts[account][index]];
274     }
275 
276     function getTickets(
277         address account,
278         uint256 startIndex,
279         uint256 count
280     ) external view returns (Ticket[] memory) {
281         Ticket[] memory ticketsList = new Ticket[](count);
282         require(
283             startIndex + count <= getTicketsCount(account),
284             "bad ticketIndex"
285         );
286         for (uint256 i = 0; i < count; ++i) {
287             ticketsList[i] = tickets[
288                 ticketsByAccounts[account][startIndex + i]
289             ];
290         }
291 
292         return ticketsList;
293     }
294 
295     function getAllTicketsListPage(uint256 startIndex, uint256 count)
296         external
297         view
298         returns (Ticket[] memory)
299     {
300         Ticket[] memory ticketsList = new Ticket[](count);
301         for (uint256 i = 0; i < count; ++i) {
302             ticketsList[i] = tickets[startIndex + i];
303         }
304 
305         return ticketsList;
306     }
307 
308     function closeTicket(address account, uint256 index) external {
309         _closeTickets(account, index, 1);
310     }
311 
312     function closeTickets(
313         address account,
314         uint256 startIndex,
315         uint256 count
316     ) external {
317         _closeTickets(account, startIndex, count);
318     }
319 
320     function _closeTickets(
321         address account,
322         uint256 startIndex,
323         uint256 count
324     ) private {
325         require(count > 0, "count is zero");
326         require(isOpened, "lottery is not open");
327         tryNextInterval();
328         require(_isWithdrawInterval, "only in withdraw interval");
329         uint256 toTransfer;
330         uint256 lastIndex = startIndex + count;
331         for (uint256 i = startIndex; i < lastIndex; ++i) {
332             Ticket storage ticket = tickets[ticketsByAccounts[account][i]];
333             if (ticket.isClosed) continue;
334             ticket.isClosed = true;
335             toTransfer += ticket.amount;
336         }
337         require(toTransfer > 0, "has no rewards");
338         token.transfer(account, toTransfer);
339     }
340 
341     function _newRound() private {
342         if (!isOpened) return;
343         _isWithdrawInterval = false;
344 
345         if (playersCount > 1 || (playersCount == 1 && tickets[0].isClosed)) {
346             ++roundNumber;
347             bidSize = nextBidSize;
348             bidsCount = 0;
349             playersCount = 0;
350             delete tickets;
351             ticketsRewards = 0;
352             uint256 balance = token.balanceOf(address(this));
353             if (balance > 0 && cAASBankAddress != address(this)) {
354                 uint256 toTransfer = ((token.balanceOf(address(this)) -
355                     jackpot) * cAASBankAddressPercent) / 100;
356                 token.transfer(cAASBankAddress, toTransfer);
357             }
358 
359             jackpot = token.balanceOf(address(this));
360             jackpotN = nextJackpotN;
361         }
362     }
363 
364     function tryNextInterval() public {
365         if (!isOpened) return;
366         // next interval
367         if (block.timestamp < _nextIntervalTime) return;
368 
369         // if skip reward interval
370         if (!_isWithdrawInterval) {
371             if (
372                 !_isWithdrawInterval &&
373                 block.timestamp >=
374                 _nextIntervalTime + intervalTimerMin * 1 minutes
375             ) {
376                 _nextIntervalTime =
377                     block.timestamp +
378                     intervalTimerMin *
379                     1 minutes;
380                 _newRound();
381                 return;
382             }
383             _nextIntervalTime = block.timestamp + intervalLapsedTime();
384         } else {
385             _nextIntervalTime = block.timestamp + intervalTimerMin * 1 minutes;
386         }
387 
388         // next interval
389         _isWithdrawInterval = !_isWithdrawInterval;
390         // next round
391         if (!_isWithdrawInterval) _newRound();
392     }
393 
394     /// @dev current intervallapsed time in seconds
395     function intervalLapsedTime() public view returns (uint256) {
396         // if timer
397         if (block.timestamp < _nextIntervalTime)
398             return _nextIntervalTime - block.timestamp;
399         // now withdraw interval (skipping withdraq interval)
400         if (
401             !_isWithdrawInterval &&
402             block.timestamp < _nextIntervalTime + intervalTimerMin * 1 minutes
403         )
404             return
405                 _nextIntervalTime +
406                 intervalTimerMin *
407                 1 minutes -
408                 block.timestamp;
409         // new interval
410         return 0;
411     }
412 
413     function isWithdrawInterval() external view returns (bool) {
414         // if timer
415         if (block.timestamp < _nextIntervalTime) return _isWithdrawInterval;
416         // now withdraw interval (skipping withdraq interval)
417         if (
418             !_isWithdrawInterval &&
419             block.timestamp >= _nextIntervalTime + intervalTimerMin * 1 minutes
420         ) return false;
421         // new interval
422         return !_isWithdrawInterval;
423     }
424 }