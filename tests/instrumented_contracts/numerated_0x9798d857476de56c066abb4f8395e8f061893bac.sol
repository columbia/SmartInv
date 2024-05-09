1 pragma solidity ^0.4.25;
2 
3 /*
4     Trust based betting system, affiliated with NeutrinoTokenStandard contract.
5     Rules:
6         Welcome Fee                      -  25%, including:
7             Boss                         -  10%
8             Yearly jackpot               -   2%
9             Referral bonus               -   8%
10             NTS funding                  -   5%
11         Exit Fee                         - FREE
12 
13     Everything's ready, right BOSSes accounts
14 */
15 
16 contract NeutrinoTokenStandard {
17     function fund() external payable;
18 }
19 
20 contract ReferralPayStation {
21     event OnGotRef (
22         address indexed ref,
23         uint256 value,
24         uint256 timestamp,
25         address indexed player
26     );
27     
28     event OnWithdraw (
29         address indexed ref,
30         uint256 value,
31         uint256 timestamp
32     );
33     
34     event OnRob (
35         address indexed ref,
36         uint256 value,
37         uint256 timestamp
38     );
39     
40     event OnRobAll (
41         uint256 value,
42         uint256 timestamp  
43     );
44     
45     address owner;
46     mapping(address => uint256) public refBalance;
47     
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52     
53     constructor() public {
54         owner = msg.sender;
55     }
56     
57     function put(address ref, address player) public payable {
58         require(msg.value > 0);
59         refBalance[ref] += msg.value;
60         
61         emit OnGotRef(ref, msg.value, now, player);
62     }
63     
64     function withdraw() public {
65         require(refBalance[msg.sender] > 0);
66         uint256 value = refBalance[msg.sender];
67         refBalance[msg.sender] = 0;
68         msg.sender.transfer(value);
69         emit OnWithdraw(msg.sender, value, now);
70     }
71     
72     /* admin */
73     function rob(address ref) onlyOwner public {
74         require(refBalance[ref] > 0);
75         uint256 value = refBalance[ref];
76         refBalance[ref] = 0;
77         owner.transfer(value);
78         emit OnRob(ref, value, now);
79     }
80     
81     function robAll() onlyOwner public {
82         uint256 balance = address(this).balance;
83         owner.transfer(balance);
84         emit OnRobAll(balance, now);
85     }
86 }
87 
88 contract BitcoinPriceBetM {
89     event OnBet (
90         address indexed player,
91         address indexed ref,
92         uint256 indexed timestamp,
93         uint256 value,
94         uint256 betPrice,
95         uint256 extra,
96         uint256 refBonus,
97         uint256 amount
98     );
99     
100     event OnWithdraw (
101         address indexed referrer,
102         uint256 value
103     );
104     
105     event OnWithdrawWin (
106         address indexed player,
107         uint256 value
108     );
109     
110     event OnPrizePayed (
111         address indexed player,
112         uint256 value,
113         uint8 place,
114         uint256 betPrice,
115         uint256 amount,
116         uint256 betValue
117     );
118     
119     event OnNTSCharged (
120         uint256 value
121     );
122     
123     event OnYJPCharged (
124         uint256 value  
125     );
126     
127     event OnGotMoney (
128         address indexed source,
129         uint256 value
130     );
131     
132     event OnCorrect (
133         uint256 value
134     );
135     
136     event OnPrizeFunded (
137         uint256 value
138     );
139     
140     event OnSendRef (
141         address indexed ref,
142         uint256 value,
143         uint256 timestamp,
144         address indexed player,
145         address indexed payStation
146     );
147     
148     event OnNewRefPayStation (
149         address newAddress,
150         uint256 timestamp
151     );
152 
153     event OnBossPayed (
154         address indexed boss,
155         uint256 value,
156         uint256 timestamp
157     );
158     
159     string constant public name = "BitcoinPrice.Bet Monthly";
160     string constant public symbol = "BPBM";
161     address public owner;
162     address constant internal boss1 = 0x42cF5e102dECCf8d89E525151c5D5bbEAc54200d;
163     address constant internal boss2 = 0x8D86E611ef0c054FdF04E1c744A8cEFc37F00F81;
164     NeutrinoTokenStandard constant internal neutrino = NeutrinoTokenStandard(0xad0a61589f3559026F00888027beAc31A5Ac4625); 
165     ReferralPayStation public refPayStation = ReferralPayStation(0x4100dAdA0D80931008a5f7F5711FFEb60A8071BA);
166     
167     uint256 constant public betStep = 0.1 ether;
168     uint256 public betStart;
169     uint256 public betFinish;
170     
171     uint8 constant bossFee = 10;
172     uint8 constant yjpFee = 2;
173     uint8 constant refFee = 8;
174     uint8 constant ntsFee = 5;
175     
176     mapping(address => uint256) public winBalance;
177     uint256 public winBalanceTotal = 0;
178     uint256 public bossBalance = 0;
179     uint256 public jackpotBalance = 0;
180     uint256 public ntsBalance = 0;
181     uint256 public prizeBalance = 0;
182     
183     modifier onlyOwner {
184         require(msg.sender == owner);
185         _;
186     }
187     
188     constructor(uint256 _betStart, uint256 _betFinish) public payable {
189         owner = msg.sender;
190         prizeBalance = msg.value;
191         betStart = _betStart;   // 1546290000 == 1 Jan 2019 GMT 00:00:00
192         betFinish = _betFinish; // 1548968400 == 31 Jan 2019 GMT 21:00:00 
193     }
194     
195     function() public payable {
196         emit OnGotMoney(msg.sender, msg.value);
197     }
198     
199     function canMakeBet() public view returns (bool) {
200         return now >= betStart && now <= betFinish;
201     }
202     
203     function makeBet(uint256 betPrice, address ref) public payable {
204         require(now >= betStart && now <= betFinish);
205         
206         uint256 value = (msg.value / betStep) * betStep;
207         uint256 extra = msg.value - value;
208         
209         require(value > 0);
210         jackpotBalance += extra;
211         
212         uint8 welcomeFee = bossFee + yjpFee + ntsFee;
213         uint256 refBonus = 0;
214         if (ref != 0x0) {
215             welcomeFee += refFee;
216             refBonus = value * refFee / 100;
217 
218             refPayStation.put.value(refBonus)(ref, msg.sender);
219             emit OnSendRef(ref, refBonus, now, msg.sender, address(refPayStation));
220         }
221         
222         uint256 taxedValue = value - value * welcomeFee / 100;
223         prizeBalance += taxedValue;
224     
225         bossBalance += value * bossFee / 100;
226         jackpotBalance += value * yjpFee / 100;
227         ntsBalance += value * ntsFee / 100;
228             
229         emit OnBet(msg.sender, ref, block.timestamp, value, betPrice, extra, refBonus, value / betStep);
230     }
231     
232     function withdrawWin() public {
233         require(winBalance[msg.sender] > 0);
234         uint256 value = winBalance[msg.sender];
235         winBalance[msg.sender] = 0;
236         winBalanceTotal -= value;
237         msg.sender.transfer(value);
238         emit OnWithdrawWin(msg.sender, value);
239     }
240     
241     /* Admin */
242     function payPrize(address player, uint256 value, uint8 place, uint256 betPrice, uint256 amount, uint256 betValue) onlyOwner public {
243         require(value <= prizeBalance);
244         
245         winBalance[player] += value;
246         winBalanceTotal += value;
247         prizeBalance -= value;
248         emit OnPrizePayed(player, value, place, betPrice, amount, betValue);   
249     }
250     
251     function payPostDrawRef(address ref, address player, uint256 value) onlyOwner public {
252         require(value <= prizeBalance);
253         
254         prizeBalance -= value;
255         
256         refPayStation.put.value(value)(ref, player);
257         emit OnSendRef(ref, value, now, player, address(refPayStation));
258     }
259     
260     function payBoss(uint256 value) onlyOwner public {
261         require(value <= bossBalance);
262         if (value == 0) value = bossBalance;
263         uint256 value1 = value * 90 / 100;
264         uint256 value2 = value * 10 / 100;
265         
266         if (boss1.send(value1)) {
267             bossBalance -= value1;
268             emit OnBossPayed(boss1, value1, now);
269         }
270         
271         if (boss2.send(value2)) {
272             bossBalance -= value2;
273             emit OnBossPayed(boss2, value2, now);
274         }
275     }
276     
277     function payNTS() onlyOwner public {
278         require(ntsBalance > 0);
279         uint256 _ntsBalance = ntsBalance;
280         
281         neutrino.fund.value(ntsBalance)();
282         ntsBalance = 0;
283         emit OnNTSCharged(_ntsBalance);
284     }
285     
286     function payYearlyJackpot(address yearlyContract) onlyOwner public {
287         require(jackpotBalance > 0);
288 
289         if (yearlyContract.call.value(jackpotBalance).gas(50000)()) {
290             jackpotBalance = 0;
291             emit OnYJPCharged(jackpotBalance);
292         }
293     }
294     
295     function correct() onlyOwner public {
296         uint256 counted = winBalanceTotal + bossBalance + jackpotBalance + ntsBalance + prizeBalance;
297         uint256 uncounted = address(this).balance - counted;
298         
299         require(uncounted > 0);
300         
301         bossBalance += uncounted;
302         emit OnCorrect(uncounted);
303     }
304     
305     function fundPrize() onlyOwner public {
306         uint256 counted = winBalanceTotal + bossBalance + jackpotBalance + ntsBalance + prizeBalance;
307         uint256 uncounted = address(this).balance - counted;
308         
309         require(uncounted > 0);
310         
311         prizeBalance += uncounted;
312         emit OnPrizeFunded(uncounted);
313     }
314     
315     function newRefPayStation(address newAddress) onlyOwner public {
316         refPayStation = ReferralPayStation(newAddress);
317         
318         emit OnNewRefPayStation(newAddress, now);
319     }
320 }