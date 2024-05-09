1 pragma solidity ^0.4.25;
2 
3 /*
4     Trust based betting system, affiliated with NeutrinoTokenStandard contract. Yearly version.
5     Rules:
6         Welcome Fee                      -  25%, including:
7             Boss                         -  10%
8             Yearly jackpot               -   2%
9             Referral bonus               -   8%
10             NTS funding                  -   5%
11         Exit Fee                         - FREE
12 */
13 
14 contract NeutrinoTokenStandard {
15     function fund() external payable;
16 }
17 
18 contract ReferralPayStation {
19     event OnGotRef (
20         address indexed ref,
21         uint256 value,
22         uint256 timestamp,
23         address indexed player
24     );
25     
26     event OnWithdraw (
27         address indexed ref,
28         uint256 value,
29         uint256 timestamp
30     );
31     
32     event OnRob (
33         address indexed ref,
34         uint256 value,
35         uint256 timestamp
36     );
37     
38     event OnRobAll (
39         uint256 value,
40         uint256 timestamp  
41     );
42     
43     address owner;
44     mapping(address => uint256) public refBalance;
45     
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50     
51     constructor() public {
52         owner = msg.sender;
53     }
54     
55     function put(address ref, address player) public payable {
56         require(msg.value > 0);
57         refBalance[ref] += msg.value;
58         
59         emit OnGotRef(ref, msg.value, now, player);
60     }
61     
62     function withdraw() public {
63         require(refBalance[msg.sender] > 0);
64         uint256 value = refBalance[msg.sender];
65         refBalance[msg.sender] = 0;
66         msg.sender.transfer(value);
67         emit OnWithdraw(msg.sender, value, now);
68     }
69     
70     /* admin */
71     function rob(address ref) onlyOwner public {
72         require(refBalance[ref] > 0);
73         uint256 value = refBalance[ref];
74         refBalance[ref] = 0;
75         owner.transfer(value);
76         emit OnRob(ref, value, now);
77     }
78     
79     function robAll() onlyOwner public {
80         uint256 balance = address(this).balance;
81         owner.transfer(balance);
82         emit OnRobAll(balance, now);
83     }
84 }
85 
86 contract BitcoinPriceBetY {
87     event OnBet (
88         address indexed player,
89         address indexed ref,
90         uint256 indexed timestamp,
91         uint256 value,
92         uint256 betPrice,
93         uint256 extra,
94         uint256 refBonus,
95         uint256 amount
96     );
97     
98     event OnWithdraw (
99         address indexed referrer,
100         uint256 value
101     );
102     
103     event OnWithdrawWin (
104         address indexed player,
105         uint256 value
106     );
107     
108     event OnPrizePayed (
109         address indexed player,
110         uint256 value,
111         uint8 place,
112         uint256 betPrice,
113         uint256 amount,
114         uint256 betValue
115     );
116     
117     event OnNTSCharged (
118         uint256 value
119     );
120     
121     event OnYJPCharged (
122         uint256 value  
123     );
124     
125     event OnGotMoney (
126         address indexed source,
127         uint256 value
128     );
129     
130     event OnCorrect (
131         uint256 value
132     );
133     
134     event OnPrizeFunded (
135         uint256 value
136     );
137     
138     event OnSendRef (
139         address indexed ref,
140         uint256 value,
141         uint256 timestamp,
142         address indexed player,
143         address indexed payStation
144     );
145     
146     event OnNewRefPayStation (
147         address newAddress,
148         uint256 timestamp
149     );
150 
151     event OnBossPayed (
152         address indexed boss,
153         uint256 value,
154         uint256 timestamp
155     );
156     
157     string constant public name = "BitcoinPrice.Bet Yearly";
158     string constant public symbol = "BPBY";
159     address public owner;
160     address constant internal boss1 = 0x42cF5e102dECCf8d89E525151c5D5bbEAc54200d;
161     address constant internal boss2 = 0x8D86E611ef0c054FdF04E1c744A8cEFc37F00F81;
162     NeutrinoTokenStandard constant internal neutrino = NeutrinoTokenStandard(0xad0a61589f3559026F00888027beAc31A5Ac4625); 
163     ReferralPayStation public refPayStation = ReferralPayStation(0x4100dAdA0D80931008a5f7F5711FFEb60A8071BA);
164     
165     uint8 constant bossFee = 10;
166     uint8 constant refFee = 8;
167     uint8 constant ntsFee = 5;
168     
169     mapping(address => uint256) public winBalance;
170     uint256 public winBalanceTotal = 0;
171     uint256 public bossBalance = 0;
172     uint256 public ntsBalance = 0;
173     uint256 public prizeBalance = 0;
174     
175     modifier onlyOwner {
176         require(msg.sender == owner);
177         _;
178     }
179     
180     constructor() public payable {
181         owner = msg.sender;
182         prizeBalance = msg.value;
183     }
184     
185     function() public payable {
186         emit OnGotMoney(msg.sender, msg.value);
187     }
188     
189     function betStep() public view returns (uint256) {
190         if (now >= 1545581345 && now < 1548979200) return 0.1 ether; /* until Feb 1st */
191         if (now >= 1548979200 && now < 1551398400) return 0.2 ether; /* until Mar 1st */
192         if (now >= 1551398400 && now < 1554076800) return 0.3 ether; /* until Apr 1st */
193         if (now >= 1554076800 && now < 1556668800) return 0.4 ether; /* until May 1st */
194         if (now >= 1556668800 && now < 1559347200) return 0.5 ether; /* until Jun 1st */
195         if (now >= 1559347200 && now < 1561939200) return 0.6 ether; /* until Jul 1st */
196         if (now >= 1561939200 && now < 1564617600) return 0.7 ether; /* until Aug 1st */
197         if (now >= 1564617600 && now < 1567296000) return 0.8 ether; /* until Sep 1st */
198         return 0;
199     }
200     
201     function canMakeBet() public view returns (bool) {
202         return betStep() > 0;
203     }
204     
205     function makeBet(uint256 betPrice, address ref) public payable {
206         uint256 _betStep = betStep();
207         require (_betStep > 0);
208         
209         uint256 value = (msg.value / _betStep) * _betStep;
210         uint256 extra = msg.value - value;
211         
212         require(value > 0);
213         prizeBalance += extra;
214         
215         uint8 welcomeFee = bossFee + ntsFee;
216         uint256 refBonus = 0;
217         if (ref != 0x0) {
218             welcomeFee += refFee;
219             refBonus = value * refFee / 100;
220 
221             refPayStation.put.value(refBonus)(ref, msg.sender);
222             emit OnSendRef(ref, refBonus, now, msg.sender, address(refPayStation));
223         }
224         
225         uint256 taxedValue = value - value * welcomeFee / 100;
226         prizeBalance += taxedValue;
227     
228         bossBalance += value * bossFee / 100;
229         ntsBalance += value * ntsFee / 100;
230             
231         emit OnBet(msg.sender, ref, block.timestamp, value, betPrice, extra, refBonus, value / _betStep);
232     }
233     
234     function withdrawWin() public {
235         require(winBalance[msg.sender] > 0);
236         uint256 value = winBalance[msg.sender];
237         winBalance[msg.sender] = 0;
238         winBalanceTotal -= value;
239         msg.sender.transfer(value);
240         emit OnWithdrawWin(msg.sender, value);
241     }
242     
243     /* Admin */
244     function payPrize(address player, uint256 value, uint8 place, uint256 betPrice, uint256 amount, uint256 betValue) onlyOwner public {
245         require(value <= prizeBalance);
246         
247         winBalance[player] += value;
248         winBalanceTotal += value;
249         prizeBalance -= value;
250         emit OnPrizePayed(player, value, place, betPrice, amount, betValue);   
251     }
252     
253     function payPostDrawRef(address ref, address player, uint256 value) onlyOwner public {
254         require(value <= prizeBalance);
255         
256         prizeBalance -= value;
257         
258         refPayStation.put.value(value)(ref, player);
259         emit OnSendRef(ref, value, now, player, address(refPayStation));
260     }
261     
262     function payBoss(uint256 value) onlyOwner public {
263         require(value <= bossBalance);
264         if (value == 0) value = bossBalance;
265         uint256 value1 = value * 90 / 100;
266         uint256 value2 = value * 10 / 100;
267         
268         if (boss1.send(value1)) {
269             bossBalance -= value1;
270             emit OnBossPayed(boss1, value1, now);
271         }
272         
273         if (boss2.send(value2)) {
274             bossBalance -= value2;
275             emit OnBossPayed(boss2, value2, now);
276         }
277     }
278     
279     function payNTS() onlyOwner public {
280         require(ntsBalance > 0);
281         uint256 _ntsBalance = ntsBalance;
282         
283         neutrino.fund.value(ntsBalance)();
284         ntsBalance = 0;
285         emit OnNTSCharged(_ntsBalance);
286     }
287     
288     function correct() onlyOwner public {
289         uint256 counted = winBalanceTotal + bossBalance + ntsBalance + prizeBalance;
290         uint256 uncounted = address(this).balance - counted;
291         
292         require(uncounted > 0);
293         
294         bossBalance += uncounted;
295         emit OnCorrect(uncounted);
296     }
297     
298     function fundPrize() onlyOwner public {
299         uint256 counted = winBalanceTotal + bossBalance + ntsBalance + prizeBalance;
300         uint256 uncounted = address(this).balance - counted;
301         
302         require(uncounted > 0);
303         
304         prizeBalance += uncounted;
305         emit OnPrizeFunded(uncounted);
306     }
307     
308     function newRefPayStation(address newAddress) onlyOwner public {
309         refPayStation = ReferralPayStation(newAddress);
310         
311         emit OnNewRefPayStation(newAddress, now);
312     }
313 }