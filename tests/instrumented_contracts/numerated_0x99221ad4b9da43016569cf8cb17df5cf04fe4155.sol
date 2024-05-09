1 pragma solidity ^0.4.24;
2 
3 /*
4 
5   /$$$$$$                                      /$$           /$$$$$$                                           /$$                                         /$$
6  /$$__  $$                                    | $$          |_  $$_/                                          | $$                                        | $$
7 | $$  \__/ /$$$$$$/$$$$   /$$$$$$   /$$$$$$  /$$$$$$          | $$   /$$$$$$$  /$$    /$$ /$$$$$$   /$$$$$$$ /$$$$$$   /$$$$$$/$$$$   /$$$$$$  /$$$$$$$  /$$$$$$   /$$$$$$$
8 |  $$$$$$ | $$_  $$_  $$ |____  $$ /$$__  $$|_  $$_/          | $$  | $$__  $$|  $$  /$$//$$__  $$ /$$_____/|_  $$_/  | $$_  $$_  $$ /$$__  $$| $$__  $$|_  $$_/  /$$_____/
9  \____  $$| $$ \ $$ \ $$  /$$$$$$$| $$  \__/  | $$            | $$  | $$  \ $$ \  $$/$$/| $$$$$$$$|  $$$$$$   | $$    | $$ \ $$ \ $$| $$$$$$$$| $$  \ $$  | $$   |  $$$$$$
10  /$$  \ $$| $$ | $$ | $$ /$$__  $$| $$        | $$ /$$        | $$  | $$  | $$  \  $$$/ | $$_____/ \____  $$  | $$ /$$| $$ | $$ | $$| $$_____/| $$  | $$  | $$ /$$\____  $$
11 |  $$$$$$/| $$ | $$ | $$|  $$$$$$$| $$        |  $$$$/       /$$$$$$| $$  | $$   \  $/  |  $$$$$$$ /$$$$$$$/  |  $$$$/| $$ | $$ | $$|  $$$$$$$| $$  | $$  |  $$$$//$$$$$$$/
12  \______/ |__/ |__/ |__/ \_______/|__/         \___/        |______/|__/  |__/    \_/    \_______/|_______/    \___/  |__/ |__/ |__/ \_______/|__/  |__/   \___/ |_______/
13 
14 */
15 
16 contract Ownable {
17     address public owner;
18 
19     address public marketers = 0xccdbFb142F4444D31dd52F719CA78b6AD3459F90;
20     uint256 public constant marketersPercent = 14;
21 
22     address public developers = 0x7E2EdCD2D7073286caeC46111dbE205A3523Eec5;
23     uint256 public constant developersPercent = 1;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26     event DevelopersChanged(address indexed previousDevelopers, address indexed newDevelopers);
27     event MarketersChanged(address indexed previousMarketers, address indexed newMarketers);
28 
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     modifier onlyThisOwner(address _owner) {
39         require(owner == _owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 
49     function setDevelopers(address newDevelopers) public onlyOwner {
50         require(newDevelopers != address(0));
51         emit DevelopersChanged(developers, newDevelopers);
52         developers = newDevelopers;
53     }
54 
55     function setMarketers(address newMarketers) public onlyOwner {
56         require(newMarketers != address(0));
57         emit MarketersChanged(marketers, newMarketers);
58         marketers = newMarketers;
59     }
60 
61 }
62 
63 contract Investments {
64 
65     struct InvestProgram {
66         uint256 minSum;     // min sum for program
67         uint256 income;     // income for one year
68     }
69 
70     struct ReferralGroup {
71         uint256 minSum;
72         uint256 maxSum;
73         uint16[] percents;
74     }
75 
76     uint256 public constant minSumRef = 0.01 ether;
77     uint256 public constant refLevelsTables = 3;
78     uint256 public constant refLevelsCount = 5;
79     ReferralGroup[] public refGroups;
80     uint256 public constant programsCount = 21;
81     InvestProgram[] public programs;
82 
83     constructor() public {
84         ReferralGroup memory refGroupFirsty = ReferralGroup(minSumRef, 10 ether - 1 wei, new uint16[](refLevelsCount));
85         refGroupFirsty.percents[0] = 300;   // 3%
86         refGroupFirsty.percents[1] = 75;    // 0.75%
87         refGroupFirsty.percents[2] = 60;    // 0.6%
88         refGroupFirsty.percents[3] = 40;    // 0.4%
89         refGroupFirsty.percents[4] = 25;    // 0.25%
90         refGroups.push(refGroupFirsty);
91 
92         ReferralGroup memory refGroupLoyalty = ReferralGroup(10 ether, 100 ether - 1 wei, new uint16[](refLevelsCount));
93         refGroupLoyalty.percents[0] = 500;  // 5%
94         refGroupLoyalty.percents[1] = 200;  // 2%
95         refGroupLoyalty.percents[2] = 150;  // 1.5%
96         refGroupLoyalty.percents[3] = 100;  // 1%
97         refGroupLoyalty.percents[4] = 50;   // 0.5%
98         refGroups.push(refGroupLoyalty);
99 
100         ReferralGroup memory refGroupUltraPremium = ReferralGroup(100 ether, 2**256 - 1, new uint16[](refLevelsCount));
101         refGroupUltraPremium.percents[0] = 700; // 7%
102         refGroupUltraPremium.percents[1] = 300; // 3%
103         refGroupUltraPremium.percents[2] = 250; // 2.5%
104         refGroupUltraPremium.percents[3] = 150; // 1.5%
105         refGroupUltraPremium.percents[4] = 100; // 1%
106         refGroups.push(refGroupUltraPremium);
107 
108         programs.push(InvestProgram(0.01    ether, 180));   // 180%
109         programs.push(InvestProgram(0.26    ether, 192));   // 192%
110         programs.push(InvestProgram(0.76    ether, 204));   // 204%
111         programs.push(InvestProgram(1.51    ether, 216));   // 216%
112         programs.push(InvestProgram(2.51    ether, 228));   // 228%
113         programs.push(InvestProgram(4.51    ether, 240));   // 240%
114         programs.push(InvestProgram(7.01    ether, 252));   // 252%
115         programs.push(InvestProgram(10.01   ether, 264));   // 264%
116         programs.push(InvestProgram(14.01   ether, 276));   // 276%
117         programs.push(InvestProgram(18.01   ether, 288));   // 288%
118         programs.push(InvestProgram(23.01   ether, 300));   // 300%
119         programs.push(InvestProgram(28.01   ether, 312));   // 312%
120         programs.push(InvestProgram(34.01   ether, 324));   // 324%
121         programs.push(InvestProgram(41.01   ether, 336));   // 336%
122         programs.push(InvestProgram(50      ether, 348));   // 348%
123         programs.push(InvestProgram(60      ether, 360));   // 360%
124         programs.push(InvestProgram(75      ether, 372));   // 372%
125         programs.push(InvestProgram(95      ether, 384));   // 384%
126         programs.push(InvestProgram(120     ether, 396));   // 396%
127         programs.push(InvestProgram(150     ether, 408));   // 408%
128         programs.push(InvestProgram(200     ether, 420));   // 420%
129     }
130 
131     function getRefPercents(uint256 _sum) public view returns(uint16[] memory) {
132         for (uint i = 0; i < refLevelsTables; i++) {
133             ReferralGroup memory group = refGroups[i];
134             if (_sum >= group.minSum && _sum <= group.maxSum) return group.percents;
135         }
136     }
137 
138     function getRefPercentsByIndex(uint256 _index) public view returns(uint16[] memory) {
139         return refGroups[_index].percents;
140     }
141 
142     function getProgramInfo(uint256 _index) public view returns(uint256, uint256) {
143         return (programs[_index].minSum, programs[_index].income);
144     }
145 
146     function getProgramPercent(uint256 _totalSum) public view returns(uint256) {
147         bool exist = false;
148         uint256 i = 0;
149         for (; i < programsCount; i++) {
150             if (_totalSum >= programs[i].minSum) exist = true;
151             else break;
152         }
153 
154         if (exist) return programs[i - 1].income;
155 
156         return 0;
157     }
158 
159 }
160 
161 contract SmartInvestments is Ownable, Investments {
162     event InvestorRegister(address _addr, uint256 _id);
163     event ReferralRegister(address _addr, address _refferal);
164     event Deposit(address _addr, uint256 _value);
165     event ReferrerDistribute(uint256 _referrerId, uint256 _sum);
166     event Withdraw(address _addr, uint256 _sum);
167 
168     struct Investor {
169         // public
170         uint256 lastWithdraw;
171         uint256 totalSum;                               // total deposits sum
172         uint256 totalWithdraw;
173         uint256 totalReferralIncome;
174         uint256[] referrersByLevel;                     // referrers ids
175         mapping (uint8 => uint256[]) referralsByLevel;  // all referrals ids
176 
177         // private
178         uint256 witharawBuffer;
179     }
180 
181     uint256 public globalDeposit;
182     uint256 public globalWithdraw;
183 
184     Investor[] public investors;
185     mapping (address => uint256) addressToInvestorId;
186     mapping (uint256 => address) investorIdToAddress;
187 
188     modifier onlyForExisting() {
189         require(addressToInvestorId[msg.sender] != 0);
190         _;
191     }
192 
193     constructor() public payable {
194         globalDeposit = 0;
195         globalWithdraw = 0;
196         investors.push(Investor(0, 0, 0, 0, new uint256[](refLevelsCount), 0));
197     }
198 
199     function() external payable {
200         if (msg.value > 0) {
201             deposit(0);
202         } else {
203             withdraw();
204         }
205     }
206 
207     function getInvestorInfo(uint256 _id) public view returns(uint256, uint256, uint256, uint256, uint256[] memory, uint256[] memory) {
208         Investor memory investor = investors[_id];
209         return (investor.lastWithdraw, investor.totalSum, investor.totalWithdraw, investor.totalReferralIncome, investor.referrersByLevel, investors[_id].referralsByLevel[uint8(0)]);
210     }
211 
212     function getInvestorId(address _address) public view returns(uint256) {
213         return addressToInvestorId[_address];
214     }
215 
216     function getInvestorAddress(uint256 _id) public view returns(address) {
217         return investorIdToAddress[_id];
218     }
219 
220     function investorsCount() public view returns(uint256) {
221         return investors.length;
222     }
223 
224     /// @notice update referrersByLevel and referralsByLevel of new investor
225     /// @param _newInvestorId the ID of the new investor
226     /// @param _refId the ID of the investor who gets the affiliate fee
227     function _updateReferrals(uint256 _newInvestorId, uint256 _refId) private {
228         if (_newInvestorId == _refId) return;
229         investors[_newInvestorId].referrersByLevel[0] = _refId;
230 
231         for (uint i = 1; i < refLevelsCount; i++) {
232             uint256 refId = investors[_refId].referrersByLevel[i - 1];
233             investors[_newInvestorId].referrersByLevel[i] = refId;
234             investors[refId].referralsByLevel[uint8(i)].push(_newInvestorId);
235         }
236 
237         investors[_refId].referralsByLevel[0].push(_newInvestorId);
238         emit ReferralRegister(investorIdToAddress[_newInvestorId], investorIdToAddress[_refId]);
239     }
240 
241     /// @notice distribute value of tx to referrers of investor
242     /// @param _investor the investor object who gets the affiliate fee
243     /// @param _sum value of ethereum for distribute to referrers of investor
244     function _distributeReferrers(Investor memory _investor, uint256 _sum) private {
245         uint256[] memory referrers = _investor.referrersByLevel;
246 
247         for (uint i = 0; i < refLevelsCount; i++)  {
248             uint256 referrerId = referrers[i];
249 
250             if (referrers[i] == 0) break;
251             // if (investors[referrerId].totalSum < minSumReferral) continue;
252 
253             uint16[] memory percents = getRefPercents(investors[referrerId].totalSum);
254             uint256 value = _sum * percents[i] / 10000;
255             if (investorIdToAddress[referrerId] != 0x0) {
256                 investorIdToAddress[referrerId].transfer(value);
257                 investors[referrerId].totalReferralIncome = investors[referrerId].totalReferralIncome + value;
258                 globalWithdraw = globalWithdraw + value;
259             }
260         }
261     }
262 
263     function _distribute(Investor storage _investor, uint256 _sum) private {
264         _distributeReferrers(_investor, _sum);
265         developers.transfer(_sum * developersPercent / 100);
266         marketers.transfer(_sum * marketersPercent / 100);
267     }
268 
269     function _registerIfNeeded(uint256 _refId) private returns(uint256) {
270         if (addressToInvestorId[msg.sender] != 0) return 0;
271 
272         uint256 id = investors.push(Investor(now, 0, 0, 0, new uint256[](refLevelsCount), 0)) - 1;
273         addressToInvestorId[msg.sender] = id;
274         investorIdToAddress[id] = msg.sender;
275 
276         if (_refId != 0)
277             _updateReferrals(id, _refId);
278 
279         emit InvestorRegister(msg.sender, id);
280     }
281 
282     function deposit(uint256 _refId) public payable returns(uint256) {
283         if (addressToInvestorId[msg.sender] == 0)
284             _registerIfNeeded(_refId);
285 
286         Investor storage investor = investors[addressToInvestorId[msg.sender]];
287         uint256 amount = withdrawAmount();
288         investor.lastWithdraw = now;
289         investor.witharawBuffer = amount;
290         investor.totalSum = investor.totalSum + msg.value;
291 
292         globalDeposit = globalDeposit + msg.value;
293 
294         _distribute(investor, msg.value);
295 
296         emit Deposit(msg.sender, msg.value);
297         return investor.totalSum;
298     }
299 
300     function withdrawAmount() public view returns(uint256) {
301         Investor memory investor = investors[addressToInvestorId[msg.sender]];
302         return investor.totalSum * getProgramPercent(investor.totalSum) / 8760 * ((now - investor.lastWithdraw) / 3600) / 100 + investor.witharawBuffer;
303     }
304 
305     function withdraw() public onlyForExisting returns(uint256) {
306         uint256 amount = withdrawAmount();
307 
308         require(amount > 0);
309         require(amount < address(this).balance);
310 
311         Investor storage investor = investors[addressToInvestorId[msg.sender]];
312         investor.totalWithdraw = investor.totalWithdraw + amount;
313         investor.lastWithdraw = now;
314         investor.witharawBuffer = 0;
315 
316         globalWithdraw = globalWithdraw + amount;
317         msg.sender.transfer(amount);
318 
319         emit Withdraw(msg.sender, amount);
320     }
321 
322 }