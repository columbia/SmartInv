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
204             getAddress(dailyWin).transfer(dailyPayAmount);
205         if (weeklyPayAmount > 0)
206             getAddress(weeklyWin).transfer(weeklyPayAmount);
207         if (monthlyPayAmount > 0)
208             getAddress(monthlyWin).transfer(monthlyPayAmount);
209         if (seasonalPayAmount > 0)
210             getAddress(seasonalWin).transfer(seasonalPayAmount);
211     }
212 
213     function paySuperPrize(address payable winner) external onlyLoto {
214         uint256 superPrizeAmount = dailyAmount + weeklyAmount + monthlyAmount + seasonalAmount;
215         dailyAmount = 0;
216         weeklyAmount = 0;
217         monthlyAmount = 0;
218         seasonalAmount = 0;
219         emit SuperPrize(superPrizeAmount, winner);
220         winner.transfer(superPrizeAmount);
221     }
222     
223     function setOldVersion(address payable oldAddress) external onlyOwner {
224         previousContract = EthexJackpot(oldAddress);
225         dailyStart = previousContract.dailyStart();
226         dailyEnd = previousContract.dailyEnd();
227         dailyProcessed = previousContract.dailyProcessed();
228         weeklyStart = previousContract.weeklyStart();
229         weeklyEnd = previousContract.weeklyEnd();
230         weeklyProcessed = previousContract.weeklyProcessed();
231         monthlyStart = previousContract.monthlyStart();
232         monthlyEnd = previousContract.monthlyEnd();
233         monthlyProcessed = previousContract.monthlyProcessed();
234         seasonalStart = previousContract.seasonalStart();
235         seasonalEnd = previousContract.seasonalEnd();
236         seasonalProcessed = previousContract.seasonalProcessed();
237         dailyNumberStartPrev = previousContract.dailyNumberStartPrev();
238         weeklyNumberStartPrev = previousContract.weeklyNumberStartPrev();
239         monthlyNumberStartPrev = previousContract.monthlyNumberStartPrev();
240         seasonalNumberStartPrev = previousContract.seasonalNumberStartPrev();
241         dailyNumberStart = previousContract.dailyNumberStart();
242         weeklyNumberStart = previousContract.weeklyNumberStart();
243         monthlyNumberStart = previousContract.monthlyNumberStart();
244         seasonalNumberStart = previousContract.seasonalNumberStart();
245         dailyNumberEndPrev = previousContract.dailyNumberEndPrev();
246         weeklyNumberEndPrev = previousContract.weeklyNumberEndPrev();
247         monthlyNumberEndPrev = previousContract.monthlyNumberEndPrev();
248         seasonalNumberEndPrev = previousContract.seasonalNumberEndPrev();
249         numberEnd = previousContract.numberEnd();
250         dailyAmount = previousContract.dailyAmount();
251         weeklyAmount = previousContract.weeklyAmount();
252         monthlyAmount = previousContract.monthlyAmount();
253         seasonalAmount = previousContract.seasonalAmount();
254         firstNumber = weeklyNumberStart;
255         for (uint256 i = firstNumber; i <= numberEnd; i++)
256             tickets[i] = previousContract.getAddress(i);
257         previousContract.migrate();
258     }
259     
260     function getAddress(uint256 number) public returns (address payable) {
261         if (number <= firstNumber)
262             return previousContract.getAddress(number);
263         return tickets[number];
264     }
265     
266     function setDaily() private {
267         dailyProcessed = dailyNumberEndPrev == numberEnd;
268         dailyStart = dailyEnd;
269         dailyEnd = dailyStart + DAILY;
270         dailyNumberStartPrev = dailyNumberStart;
271         dailyNumberEndPrev = numberEnd;
272     }
273     
274     function setWeekly() private {
275         weeklyProcessed = weeklyNumberEndPrev == numberEnd;
276         weeklyStart = weeklyEnd;
277         weeklyEnd = weeklyStart + WEEKLY;
278         weeklyNumberStartPrev = weeklyNumberStart;
279         weeklyNumberEndPrev = numberEnd;
280     }
281     
282     function setMonthly() private {
283         monthlyProcessed = monthlyNumberEndPrev == numberEnd;
284         monthlyStart = monthlyEnd;
285         monthlyEnd = monthlyStart + MONTHLY;
286         monthlyNumberStartPrev = monthlyNumberStart;
287         monthlyNumberEndPrev = numberEnd;
288     }
289     
290     function setSeasonal() private {
291         seasonalProcessed = seasonalNumberEndPrev == numberEnd;
292         seasonalStart = seasonalEnd;
293         seasonalEnd = seasonalStart + SEASONAL;
294         seasonalNumberStartPrev = seasonalNumberStart;
295         seasonalNumberEndPrev = numberEnd;
296     }
297     
298     function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) pure private returns (uint256) {
299         return startNumber + modulo % (endNumber - startNumber + 1);
300     }
301 }