1 pragma solidity ^0.5.0;
2 
3 /**
4  * (E)t)h)e)x) Jackpot Contract 
5  *  This smart-contract is the part of Ethex Lottery fair game.
6  *  See latest version at https://github.com/ethex-bet/ethex-contracts 
7  *  http://ethex.bet
8  */
9 
10 contract EthexJackpot {
11     mapping(uint256 => address payable) public tickets;
12     uint256 public numberEnd;
13     uint256 public firstNumber;
14     uint256 public dailyAmount;
15     uint256 public weeklyAmount;
16     uint256 public monthlyAmount;
17     uint256 public seasonalAmount;
18     bool public dailyProcessed;
19     bool public weeklyProcessed;
20     bool public monthlyProcessed;
21     bool public seasonalProcessed;
22     address payable private owner;
23     address public lotoAddress;
24     address payable public newVersionAddress;
25     EthexJackpot previousContract;
26     uint256 public dailyNumberStartPrev;
27     uint256 public weeklyNumberStartPrev;
28     uint256 public monthlyNumberStartPrev;
29     uint256 public seasonalNumberStartPrev;
30     uint256 public dailyStart;
31     uint256 public weeklyStart;
32     uint256 public monthlyStart;
33     uint256 public seasonalStart;
34     uint256 public dailyEnd;
35     uint256 public weeklyEnd;
36     uint256 public monthlyEnd;
37     uint256 public seasonalEnd;
38     uint256 public dailyNumberStart;
39     uint256 public weeklyNumberStart;
40     uint256 public monthlyNumberStart;
41     uint256 public seasonalNumberStart;
42     uint256 public dailyNumberEndPrev;
43     uint256 public weeklyNumberEndPrev;
44     uint256 public monthlyNumberEndPrev;
45     uint256 public seasonalNumberEndPrev;
46     
47     event Jackpot (
48         uint256 number,
49         uint256 count,
50         uint256 amount,
51         byte jackpotType
52     );
53     
54     event Ticket (
55         bytes16 indexed id,
56         uint256 number
57     );
58     
59     event SuperPrize (
60         uint256 amount,
61         address winner
62     );
63     
64     uint256 constant DAILY = 5000;
65     uint256 constant WEEKLY = 35000;
66     uint256 constant MONTHLY = 150000;
67     uint256 constant SEASONAL = 450000;
68     uint256 constant PRECISION = 1 ether;
69     uint256 constant DAILY_PART = 84;
70     uint256 constant WEEKLY_PART = 12;
71     uint256 constant MONTHLY_PART = 3;
72     
73     constructor() public payable {
74         owner = msg.sender;
75     }
76     
77     function() external payable { }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83     
84     modifier onlyOwnerOrNewVersion {
85         require(msg.sender == owner || msg.sender == newVersionAddress);
86         _;
87     }
88     
89     modifier onlyLoto {
90         require(msg.sender == lotoAddress, "Loto only");
91         _;
92     }
93     
94     function migrate() external onlyOwnerOrNewVersion {
95         newVersionAddress.transfer(address(this).balance);
96     }
97 
98     function registerTicket(bytes16 id, address payable gamer) external onlyLoto {
99         uint256 number = numberEnd + 1;
100         if (block.number >= dailyEnd) {
101             setDaily();
102             dailyNumberStart = number;
103         }
104         else
105             if (dailyNumberStart == dailyNumberStartPrev)
106                 dailyNumberStart = number;
107         if (block.number >= weeklyEnd) {
108             setWeekly();
109             weeklyNumberStart = number;
110         }
111         else
112             if (weeklyNumberStart == weeklyNumberStartPrev)
113                 weeklyNumberStart = number;
114         if (block.number >= monthlyEnd) {
115             setMonthly();
116             monthlyNumberStart = number;
117         }
118         else
119             if (monthlyNumberStart == monthlyNumberStartPrev)
120                 monthlyNumberStart = number;
121         if (block.number >= seasonalEnd) {
122             setSeasonal();
123             seasonalNumberStart = number;
124         }
125         else
126             if (seasonalNumberStart == seasonalNumberStartPrev)
127                 seasonalNumberStart = number;
128         numberEnd = number;
129         tickets[number] = gamer;
130         emit Ticket(id, number);
131     }
132     
133     function setLoto(address loto) external onlyOwner {
134         lotoAddress = loto;
135     }
136     
137     function setNewVersion(address payable newVersion) external onlyOwner {
138         newVersionAddress = newVersion;
139     }
140     
141     function payIn() external payable {
142         uint256 distributedAmount = dailyAmount + weeklyAmount + monthlyAmount + seasonalAmount;
143         if (distributedAmount < address(this).balance) {
144             uint256 amount = (address(this).balance - distributedAmount) / 4;
145             dailyAmount += amount;
146             weeklyAmount += amount;
147             monthlyAmount += amount;
148             seasonalAmount += amount;
149         }
150     }
151     
152     function settleJackpot() external {
153         if (block.number >= dailyEnd)
154             setDaily();
155         if (block.number >= weeklyEnd)
156             setWeekly();
157         if (block.number >= monthlyEnd)
158             setMonthly();
159         if (block.number >= seasonalEnd)
160             setSeasonal();
161         
162         if (block.number == dailyStart || (dailyStart < block.number - 256))
163             return;
164         
165         uint48 modulo = uint48(bytes6(blockhash(dailyStart) << 29));
166         
167         uint256 dailyPayAmount;
168         uint256 weeklyPayAmount;
169         uint256 monthlyPayAmount;
170         uint256 seasonalPayAmount;
171         uint256 dailyWin;
172         uint256 weeklyWin;
173         uint256 monthlyWin;
174         uint256 seasonalWin;
175         if (dailyProcessed == false) {
176             dailyPayAmount = dailyAmount * PRECISION / DAILY_PART / PRECISION;
177             dailyAmount -= dailyPayAmount;
178             dailyProcessed = true;
179             dailyWin = getNumber(dailyNumberStartPrev, dailyNumberEndPrev, modulo);
180             emit Jackpot(dailyWin, dailyNumberEndPrev - dailyNumberStartPrev + 1, dailyPayAmount, 0x01);
181         }
182         if (weeklyProcessed == false) {
183             weeklyPayAmount = weeklyAmount * PRECISION / WEEKLY_PART / PRECISION;
184             weeklyAmount -= weeklyPayAmount;
185             weeklyProcessed = true;
186             weeklyWin = getNumber(weeklyNumberStartPrev, weeklyNumberEndPrev, modulo);
187             emit Jackpot(weeklyWin, weeklyNumberEndPrev - weeklyNumberStartPrev + 1, weeklyPayAmount, 0x02);
188         }
189         if (monthlyProcessed == false) {
190             monthlyPayAmount = monthlyAmount * PRECISION / MONTHLY_PART / PRECISION;
191             monthlyAmount -= monthlyPayAmount;
192             monthlyProcessed = true;
193             monthlyWin = getNumber(monthlyNumberStartPrev, monthlyNumberEndPrev, modulo);
194             emit Jackpot(monthlyWin, monthlyNumberEndPrev - monthlyNumberStartPrev + 1, monthlyPayAmount, 0x04);
195         }
196         if (seasonalProcessed == false) {
197             seasonalPayAmount = seasonalAmount;
198             seasonalAmount -= seasonalPayAmount;
199             seasonalProcessed = true;
200             seasonalWin = getNumber(seasonalNumberStartPrev, seasonalNumberEndPrev, modulo);
201             emit Jackpot(seasonalWin, seasonalNumberEndPrev - seasonalNumberStartPrev + 1, seasonalPayAmount, 0x08);
202         }
203         if (dailyPayAmount > 0)
204             tickets[dailyWin].transfer(dailyPayAmount);
205         if (weeklyPayAmount > 0)
206             tickets[weeklyWin].transfer(weeklyPayAmount);
207         if (monthlyPayAmount > 0)
208             tickets[monthlyWin].transfer(monthlyPayAmount);
209         if (seasonalPayAmount > 0)
210             tickets[seasonalWin].transfer(seasonalPayAmount);
211     }
212     
213     function settleSuperPrize(address payable winner) external onlyLoto {
214         uint256 superPrizeAmount = dailyAmount + weeklyAmount + monthlyAmount + seasonalAmount;
215         emit SuperPrize(superPrizeAmount, winner);
216         winner.transfer(superPrizeAmount);
217     }
218     
219     function loadTickets(address payable[] calldata addresses, uint256[] calldata numbers) external {
220         for (uint i = 0; i < addresses.length; i++)
221             tickets[numbers[i]] = addresses[i];
222     }
223     
224     function setOldVersion(
225         address payable oldAddress,
226         uint256 dailyNumberStartPrevIn,
227         uint256 weeklyNumberStartPrevIn,
228         uint256 monthlyNumberStartPrevIn,
229         uint256 seasonalNumberStartPrevIn,
230         uint256 dailyNumberStartIn,
231         uint256 weeklyNumberStartIn,
232         uint256 monthlyNumberStartIn,
233         uint256 seasonalNumberStartIn,
234         uint256 dailyNumberEndPrevIn,
235         uint256 weeklyNumberEndPrevIn, 
236         uint256 monthlyNumberEndPrevIn,
237         uint256 seasonalNumberEndPrevIn
238     ) external onlyOwner {
239         previousContract = EthexJackpot(oldAddress);
240         firstNumber = 1;//previousContract.numberEnd;        
241         dailyStart = block.number / DAILY * DAILY;
242         dailyEnd = dailyStart + DAILY;
243         dailyProcessed = true;
244         weeklyStart = block.number / WEEKLY * WEEKLY;
245         weeklyEnd = weeklyStart + WEEKLY;
246         weeklyProcessed = true;
247         monthlyStart = block.number / MONTHLY * MONTHLY;
248         monthlyEnd = monthlyStart + MONTHLY;
249         monthlyProcessed = true;
250         seasonalStart = block.number / SEASONAL * SEASONAL;
251         seasonalEnd = seasonalStart + SEASONAL;
252         seasonalProcessed = true;
253         dailyNumberStartPrev = dailyNumberStartPrevIn;
254         weeklyNumberStartPrev = weeklyNumberStartPrevIn;
255         monthlyNumberStartPrev = monthlyNumberStartPrevIn;
256         seasonalNumberStartPrev = seasonalNumberStartPrevIn;
257         dailyNumberStart = dailyNumberStartIn;
258         weeklyNumberStart = weeklyNumberStartIn;
259         monthlyNumberStart = monthlyNumberStartIn;
260         seasonalNumberStart = seasonalNumberStartIn;
261         dailyNumberEndPrev = dailyNumberEndPrevIn;
262         weeklyNumberEndPrev = weeklyNumberEndPrevIn;
263         monthlyNumberEndPrev = monthlyNumberEndPrevIn;
264         seasonalNumberEndPrev = seasonalNumberEndPrevIn;
265         numberEnd = previousContract.numberEnd();
266         dailyAmount = previousContract.dailyAmount();
267         weeklyAmount = previousContract.weeklyAmount();
268         monthlyAmount = previousContract.monthlyAmount();
269         seasonalAmount = previousContract.seasonalAmount() + 19599522250000000000;
270     }
271     
272     function getAddress(uint256 number) public returns (address payable) {
273         if (number <= firstNumber)
274             return previousContract.getAddress(number);
275         return tickets[number];
276     }
277     
278     function setDaily() private {
279         dailyProcessed = dailyNumberEndPrev == numberEnd;
280         dailyStart = dailyEnd;
281         dailyEnd = dailyStart + DAILY;
282         dailyNumberStartPrev = dailyNumberStart;
283         dailyNumberEndPrev = numberEnd;
284     }
285     
286     function setWeekly() private {
287         weeklyProcessed = weeklyNumberEndPrev == numberEnd;
288         weeklyStart = weeklyEnd;
289         weeklyEnd = weeklyStart + WEEKLY;
290         weeklyNumberStartPrev = weeklyNumberStart;
291         weeklyNumberEndPrev = numberEnd;
292     }
293     
294     function setMonthly() private {
295         monthlyProcessed = monthlyNumberEndPrev == numberEnd;
296         monthlyStart = monthlyEnd;
297         monthlyEnd = monthlyStart + MONTHLY;
298         monthlyNumberStartPrev = monthlyNumberStart;
299         monthlyNumberEndPrev = numberEnd;
300     }
301     
302     function setSeasonal() private {
303         seasonalProcessed = seasonalNumberEndPrev == numberEnd;
304         seasonalStart = seasonalEnd;
305         seasonalEnd = seasonalStart + SEASONAL;
306         seasonalNumberStartPrev = seasonalNumberStart;
307         seasonalNumberEndPrev = numberEnd;
308     }
309     
310     function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) pure private returns (uint256) {
311         return startNumber + modulo % (endNumber - startNumber + 1);
312     }
313 }