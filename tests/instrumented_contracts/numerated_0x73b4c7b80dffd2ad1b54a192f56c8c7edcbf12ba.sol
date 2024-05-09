1 pragma solidity ^0.4.24;
2 
3 /* - https://eth-invest.com/      version: 1.0.1
4 *  - Ref bonuses 8% per day, 0.33% every hour
5 *  - Invest dividends 8%
6 *  - Invest and get 120% But u can't get more than 120%
7 *  - Dont snooze, you can earn ETH only the first fifteen days!!!
8 *  - Invite your friends, you will get 4% for each other, they will get +2% to their deposit. Also, if u already got 120% u can get invite bonuses
9 *  - Have a nice day :)
10 */
11 contract MainContract {
12     address owner;
13     address advertisingAddress;
14 
15     uint private constant minInvest = 10 finney; // 0.01 eth
16     
17     uint constant maxPayment = 360; // maxPayment value every hour your payment + 1; 24 hours * 15 days = 360 :)
18     using Calc for uint;
19     using PercentCalc for PercentCalc.percent;
20     using Zero for *;
21     using compileLibrary for *;
22 
23     struct User {
24         uint idx;
25         uint value;
26         uint bonus;
27         uint payValue;
28         uint payTime;
29     }
30 
31     mapping(address => User) investorsStorage;
32 
33     address[] users;
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner, "access denied");
37         _;
38     }
39 
40     event logsDataPayable(uint value, uint time, address indexed addr);
41     event logsDataConstructor(address creater, uint when, string text);
42     event newInvestor(address indexed addr, uint when, uint value);
43     event investToProject(address creater, uint when, string text);
44     event logPaymentUser(uint value, uint when, address indexed addr, string text);
45     event logPayDividends(uint value, uint when, address indexed addr, string text);
46     event logPayBonus(uint value, uint when, address indexed addr, string text);
47     event notEnoughETH(uint when, string text);
48     
49     constructor() public {
50         owner = msg.sender;
51         users.length++;
52         emit logsDataConstructor(msg.sender, now, "constructor");
53     }
54 
55     //     PercentCalc
56     PercentCalc.percent private dividendPercent = PercentCalc.percent(8); // 8%
57     PercentCalc.percent private refPercent = PercentCalc.percent(2); // 2%
58     PercentCalc.percent private refPercentBonus = PercentCalc.percent(4); // 4% 
59     PercentCalc.percent private advertisingPercent = PercentCalc.percent(5); // 5%
60     PercentCalc.percent private ownerPercent = PercentCalc.percent(2); // 2%
61 
62     function() public payable {
63         if (msg.value == 0) {
64             fetchDividends();
65             return;
66         }
67 
68         require(msg.value >= minInvest, "value can't be < than 0.01");
69         if (investorsStorage[msg.sender].idx > 0) { // dont send more if u have already invested!!! 
70             sendValueToAdv(msg.value);
71         } else {
72             address ref = msg.data.toAddr();
73             uint idx = investorsStorage[msg.sender].idx;
74             uint value = msg.value;
75             idx = users.length++;
76             if (ref.notZero() && investorsStorage[ref].idx > 0) {
77                 setUserBonus(ref, msg.value);
78                 value += refPercent.getValueByPercent(value);
79             }
80             emit newInvestor(msg.sender, now, msg.value);
81             investorsStorage[msg.sender] = User({
82                 idx : idx,
83                 value : value,
84                 bonus : 0,
85                 payValue: 0,
86                 payTime : now
87                 });
88         }
89 
90         sendValueToOwner(msg.value);
91         sendValueToAdv(msg.value);
92 
93         emit logsDataPayable(msg.value, now, msg.sender);
94     }
95 
96 
97     function setUserBonus(address addr, uint value) private {
98         uint bonus = refPercentBonus.getValueByPercent(value);
99         if (investorsStorage[addr].idx > 0) {
100             investorsStorage[addr].bonus += bonus;
101         } else {
102             sendValueToAdv(bonus);
103         }
104     }
105 
106     function fetchDividends() private {
107         User memory inv = findInvestorByAddress(msg.sender);
108         require(inv.idx > 0, "Payer is not investor");
109         uint payValueByTime = now.sub(inv.payTime).getDiffValue(1 hours);
110         require(payValueByTime > 0, "the payment was earlier than 1 hours");
111         uint newPayValye = payValueByTime + inv.payValue; // do not snooze
112         if (newPayValye > maxPayment) {
113             require(inv.bonus > 0, "you've already got 120%");
114             sendUserBonus(msg.sender, inv.bonus);
115         } else {
116             uint dividendValue = (dividendPercent.getValueByPercent(inv.value) * payValueByTime) / 24;
117             if (address(this).balance < dividendValue + inv.bonus) {
118                 emit notEnoughETH(now, "not enough Eth at address");
119                 return;
120             }
121             emit logPaymentUser(newPayValye, now, msg.sender, 'gotPercent value');
122             investorsStorage[msg.sender].payValue += payValueByTime;
123             if (inv.bonus > 0) {
124                 sendDividendsWithBonus(msg.sender, dividendValue, inv.bonus);
125             } else {
126                 sendDividends(msg.sender, dividendValue);
127             }
128         }
129     }
130 
131 
132     function sendUserBonus(address addr, uint bonus) private {
133         addr.transfer(bonus);
134         investorsStorage[addr].bonus = 0;
135         emit logPayBonus(bonus, now, addr, "Investor got bonuses!");
136     }
137 
138     function setAdvertisingAddress(address addr) public onlyOwner {
139         advertisingAddress = addr;
140     }
141 
142 
143     function sendDividends(address addr, uint value) private {
144         updatePayTime(addr, now);
145         emit logPayDividends(value, now, addr, "dividends");
146         addr.transfer(value);
147     }
148 
149     function sendDividendsWithBonus(address addr, uint value, uint bonus) private {
150         updatePayTime(addr, now);
151         addr.transfer(value + bonus);
152         investorsStorage[addr].bonus = 0;
153         emit logPayDividends(value + bonus, now, addr, "dividends with bonus");
154     }
155 
156     function findInvestorByAddress(address addr) internal view returns (User) {
157         return User(
158             investorsStorage[addr].idx,
159             investorsStorage[addr].value,
160             investorsStorage[addr].bonus,
161             investorsStorage[addr].payValue,
162             investorsStorage[addr].payTime
163         );
164     }
165 
166     function sendValueToOwner(uint val) private {
167         owner.transfer(ownerPercent.getValueByPercent(val));
168     }
169 
170     function sendValueToAdv(uint val) private {
171         advertisingAddress.transfer(advertisingPercent.getValueByPercent(val));
172     }
173 
174 
175     function updatePayTime(address addr, uint time) private returns (bool) {
176         if (investorsStorage[addr].idx == 0) return false;
177         investorsStorage[addr].payTime = time;
178         return true;
179     }
180 }
181 
182 
183 
184 
185 // Calc library
186 library Calc {
187     function getDiffValue(uint _a, uint _b) internal pure returns (uint) {
188         require(_b > 0);
189         uint c = _a / _b;
190         return c;
191     }
192 
193     function sub(uint _a, uint _b) internal pure returns (uint) {
194         require(_b <= _a);
195         uint c = _a - _b;
196 
197         return c;
198     }
199 }
200 // Percent Calc library
201 library PercentCalc {
202     struct percent {
203         uint val;
204     }
205 
206     function getValueByPercent(percent storage p, uint a) internal view returns (uint) {
207         if (a == 0) {
208             return 0;
209         }
210         return a * p.val / 100;
211     }
212 }
213 
214 library Zero {
215     function notZero(address addr) internal pure returns (bool) {
216         return !(addr == address(0));
217     }
218 }
219 
220 
221 library compileLibrary {
222     function toAddr(bytes source) internal pure returns (address addr) {
223         assembly {addr := mload(add(source, 0x14))}
224         return addr;
225     }
226 }