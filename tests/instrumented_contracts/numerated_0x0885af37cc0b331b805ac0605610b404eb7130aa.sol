1 pragma solidity ^0.5.0;
2 
3 /**
4  * (E)t)h)e)x) Jackpot Contract 
5  *  This smart-contract is the part of Ethex Lottery fair game.
6  *  See latest version at https://github.com/ethex-bet/ethex-lottery 
7  *  http://ethex.bet
8  */
9 
10 contract EthexJackpot {
11     mapping(uint256 => address payable) tickets;
12     uint256 public numberEnd;
13     uint256 public dailyAmount;
14     uint256 public weeklyAmount;
15     uint256 public monthlyAmount;
16     uint256 public seasonalAmount;
17     bool private dailyProcessed;
18     bool private weeklyProcessed;
19     bool private monthlyProcessed;
20     bool private seasonalProcessed;
21     uint256 private dailyNumberStartPrev;
22     uint256 private weeklyNumberStartPrev;
23     uint256 private monthlyNumberStartPrev;
24     uint256 private seasonalNumberStartPrev;
25     uint256 private dailyStart;
26     uint256 private weeklyStart;
27     uint256 private monthlyStart;
28     uint256 private seasonalStart;
29     uint256 private dailyEnd;
30     uint256 private weeklyEnd;
31     uint256 private monthlyEnd;
32     uint256 private seasonalEnd;
33     uint256 private dailyNumberStart;
34     uint256 private weeklyNumberStart;
35     uint256 private monthlyNumberStart;
36     uint256 private seasonalNumberStart;
37     uint256 private dailyNumberEndPrev;
38     uint256 private weeklyNumberEndPrev;
39     uint256 private monthlyNumberEndPrev;
40     uint256 private seasonalNumberEndPrev;
41     address public lotoAddress;
42     address payable private owner;
43     
44     event Jackpot (
45         uint256 number,
46         uint256 count,
47         uint256 amount,
48         byte jackpotType
49     );
50     
51     event Ticket (
52         bytes16 indexed id,
53         uint256 number
54     );
55     
56     uint256 constant DAILY = 5000;
57     uint256 constant WEEKLY = 35000;
58     uint256 constant MONTHLY = 140000;
59     uint256 constant SEASONAL = 420000;
60     
61     constructor() public payable {
62         owner = msg.sender;
63         dailyStart = block.number / DAILY * DAILY;
64         dailyEnd = dailyStart + DAILY;
65         dailyProcessed = true;
66         weeklyStart = block.number / WEEKLY * WEEKLY;
67         weeklyEnd = weeklyStart + WEEKLY;
68         weeklyProcessed = true;
69         monthlyStart = block.number / MONTHLY * MONTHLY;
70         monthlyEnd = monthlyStart + MONTHLY;
71         monthlyProcessed = true;
72         seasonalStart = block.number / SEASONAL * SEASONAL;
73         seasonalEnd = seasonalStart + SEASONAL;
74         seasonalProcessed = true;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     modifier onlyLoto {
83         require(msg.sender == lotoAddress, "Loto only");
84         _;
85     }
86     
87     function migrate(address payable newContract) external onlyOwner {
88         newContract.transfer(address(this).balance);
89     }
90 
91     function registerTicket(bytes16 id, address payable gamer) external onlyLoto {
92         uint256 number = numberEnd + 1;
93         if (block.number >= dailyEnd) {
94             setDaily();
95             dailyNumberStart = number;
96         }
97         if (block.number >= weeklyEnd) {
98             setWeekly();
99             weeklyNumberStart = number;
100         }
101         if (block.number >= monthlyEnd) {
102             setMonthly();
103             monthlyNumberStart = number;
104         }
105         if (block.number >= seasonalEnd) {
106             setSeasonal();
107             seasonalNumberStart = number;
108         }
109         numberEnd = number;
110         tickets[number] = gamer;
111         emit Ticket(id, number);
112     }
113     
114     function setLoto(address loto) external onlyOwner {
115         lotoAddress = loto;
116     }
117     
118     function payIn() external payable {
119         uint256 amount = msg.value / 4;
120         dailyAmount += amount;
121         weeklyAmount += amount;
122         monthlyAmount += amount;
123         seasonalAmount += amount;
124     }
125     
126     function settleJackpot() external {
127         if (block.number >= dailyEnd) {
128             setDaily();
129         }
130         if (block.number >= weeklyEnd) {
131             setWeekly();
132         }
133         if (block.number >= monthlyEnd) {
134             setMonthly();
135         }
136         if (block.number >= seasonalEnd) {
137             setSeasonal();
138         }
139         
140         if (block.number == dailyStart)
141             return;
142         
143         uint48 modulo = uint48(bytes6(blockhash(dailyStart) << 29));
144         
145         uint256 dailyPayAmount;
146         uint256 weeklyPayAmount;
147         uint256 monthlyPayAmount;
148         uint256 seasonalPayAmount;
149         uint256 dailyWin;
150         uint256 weeklyWin;
151         uint256 monthlyWin;
152         uint256 seasonalWin;
153         if (dailyProcessed == false) {
154             dailyPayAmount = dailyAmount; 
155             dailyAmount = 0;
156             dailyProcessed = true;
157             dailyWin = getNumber(dailyNumberStartPrev, dailyNumberEndPrev, modulo);
158             emit Jackpot(dailyWin, dailyNumberEndPrev - dailyNumberStartPrev + 1, dailyPayAmount, 0x01);
159         }
160         if (weeklyProcessed == false) {
161             weeklyPayAmount = weeklyAmount;
162             weeklyAmount = 0;
163             weeklyProcessed = true;
164             weeklyWin = getNumber(weeklyNumberStartPrev, weeklyNumberEndPrev, modulo);
165             emit Jackpot(weeklyWin, weeklyNumberEndPrev - weeklyNumberStartPrev + 1, weeklyPayAmount, 0x02);
166         }
167         if (monthlyProcessed == false) {
168             monthlyPayAmount = monthlyAmount;
169             monthlyAmount = 0;
170             monthlyProcessed = true;
171             monthlyWin = getNumber(monthlyNumberStartPrev, monthlyNumberEndPrev, modulo);
172             emit Jackpot(monthlyWin, monthlyNumberEndPrev - monthlyNumberStartPrev + 1, monthlyPayAmount, 0x04);
173         }
174         if (seasonalProcessed == false) {
175             seasonalPayAmount = seasonalAmount;
176             seasonalAmount = 0;
177             seasonalProcessed = true;
178             seasonalWin = getNumber(seasonalNumberStartPrev, seasonalNumberEndPrev, modulo);
179             emit Jackpot(seasonalWin, seasonalNumberEndPrev - seasonalNumberStartPrev + 1, seasonalPayAmount, 0x08);
180         }
181         if (dailyPayAmount > 0)
182             tickets[dailyWin].transfer(dailyPayAmount);
183         if (weeklyPayAmount > 0)
184             tickets[weeklyWin].transfer(weeklyPayAmount);
185         if (monthlyPayAmount > 0)
186             tickets[monthlyWin].transfer(monthlyPayAmount);
187         if (seasonalPayAmount > 0)
188             tickets[seasonalWin].transfer(seasonalPayAmount);
189     }
190     
191     function setDaily() private {
192         dailyProcessed = dailyNumberEndPrev == numberEnd;
193         dailyStart = dailyEnd;
194         dailyEnd = dailyStart + DAILY;
195         dailyNumberStartPrev = dailyNumberStart;
196         dailyNumberEndPrev = numberEnd;
197     }
198     
199     function setWeekly() private {
200         weeklyProcessed = weeklyNumberEndPrev == numberEnd;
201         weeklyStart = weeklyEnd;
202         weeklyEnd = weeklyStart + WEEKLY;
203         weeklyNumberStartPrev = weeklyNumberStart;
204         weeklyNumberEndPrev = numberEnd;
205     }
206     
207     function setMonthly() private {
208         monthlyProcessed = monthlyNumberEndPrev == numberEnd;
209         monthlyStart = monthlyEnd;
210         monthlyEnd = monthlyStart + MONTHLY;
211         monthlyNumberStartPrev = monthlyNumberStart;
212         monthlyNumberEndPrev = numberEnd;
213     }
214     
215     function setSeasonal() private {
216         seasonalProcessed = seasonalNumberEndPrev == numberEnd;
217         seasonalStart = seasonalEnd;
218         seasonalEnd = seasonalStart + SEASONAL;
219         seasonalNumberStartPrev = seasonalNumberStart;
220         seasonalNumberEndPrev = numberEnd;
221     }
222     
223     function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) pure private returns (uint256) {
224         return startNumber + modulo % (endNumber - startNumber + 1);
225     }
226 }