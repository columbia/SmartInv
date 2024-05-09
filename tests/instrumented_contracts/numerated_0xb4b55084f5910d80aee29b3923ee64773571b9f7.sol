1 pragma solidity ^0.4.24;
2 
3 /* - version: 1.0.0
4 *  - Ref bonuses 2-3%
5 *  - Invest dividends 3-4% if you invest more than 10 ETH you'll get 4%!
6 *
7 */
8 contract MainContract {
9     address owner;
10 
11     address advertisingAddress;
12 
13     uint private constant minInvest = 5 finney; // 0.005 eth
14     using Calc for uint;
15     using PercentCalc for PercentCalc.percent;
16     using Zero for *;
17     using compileLibrary for *;
18 
19     struct User {
20         uint idx;
21         uint value;
22         uint bonus;
23         bool invested10Eth;
24         uint payTime;
25     }
26 
27     mapping(address => User) investorsStorage;
28 
29     address[] users;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner, "access denied");
33         _;
34     }
35 
36     event logsDataPayable(uint value, uint time, address indexed addr);
37 
38     event logsDataConstructor(address creater, uint when, string text);
39 
40     event newInvestor(address indexed addr, uint when, uint value);
41 
42     event investToProject(address creater, uint when, string text);
43 
44     event logPayDividends(uint value, uint when, address indexed addr, string text);
45 
46     event logPayBonus(uint value, uint when, address indexed addr, string text);
47 
48     event notEnoughETH(uint when, string text);
49 
50     constructor() public {
51         owner = msg.sender;
52         users.length++;
53         emit logsDataConstructor(msg.sender, now, "constructor");
54     }
55 
56     //     PercentCalc
57     PercentCalc.percent private dividendPercent = PercentCalc.percent(3); // 3%
58     PercentCalc.percent private refPercent = PercentCalc.percent(2); // 2%
59     PercentCalc.percent private advertisingPercent = PercentCalc.percent(8); // 8%
60     PercentCalc.percent private ownerPercent = PercentCalc.percent(5); // 5%
61 
62     // dividend percent Bonus
63     PercentCalc.percent private dividendPercentBonus = PercentCalc.percent(4); // 4%
64     PercentCalc.percent private refPercentBonus = PercentCalc.percent(3); // 3%
65     //     PercentCalc
66 
67     function() public payable {
68         if (msg.value == 0) {
69             fetchDividends();
70             return;
71         }
72 
73         require(msg.value >= minInvest, "value can't be < than 0.005");
74 
75         if (investorsStorage[msg.sender].idx > 0) {
76             investorsStorage[msg.sender].value += msg.value;
77             
78             if (!investorsStorage[msg.sender].invested10Eth && msg.value >= 10 ether) {
79                 investorsStorage[msg.sender].invested10Eth = true;
80             }
81         } else {
82             address ref = msg.data.toAddr();
83             uint idx = investorsStorage[msg.sender].idx;
84             uint value = msg.value;
85             idx = users.length++;
86             if (ref.notZero() && investorsStorage[ref].idx > 0) {
87                 setUserBonus(ref, msg.value);
88                 value += refPercent.getValueByPercent(value);
89             }
90             emit newInvestor(msg.sender, now, msg.value);
91             investorsStorage[msg.sender] = User({
92                 idx : idx,
93                 value : value,
94                 bonus : 0,
95                 invested10Eth: msg.value >= 10 ether,
96                 payTime : now
97             });
98         }
99 
100         sendValueToOwner(msg.value);
101         sendValueToAdv(msg.value);
102 
103         emit logsDataPayable(msg.value, now, msg.sender);
104     }
105 
106 
107     function setUserBonus(address addr, uint value) private {
108         uint bonus = refPercent.getValueByPercent(value);
109         if (investorsStorage[addr].idx > 0) {
110             if (investorsStorage[addr].invested10Eth) bonus = refPercentBonus.getValueByPercent(value);
111             investorsStorage[addr].bonus += bonus;
112             emit logPayBonus(bonus, now, addr, "investor got bonuses!");
113         } else {
114             sendValueToAdv(bonus);
115         }
116     }
117 
118     function fetchDividends() private {
119         User memory inv = findInvestorByAddress(msg.sender);
120         require(inv.idx > 0, "payer is not investor");
121         uint payValueByTime = now.sub(inv.payTime).getDiffValue(12 hours);
122         require(payValueByTime > 0, "the payment was earlier than 12 hours");
123 
124         uint dividendValue = (dividendPercent.getValueByPercent(inv.value) * payValueByTime) / 2;
125         if (inv.invested10Eth) dividendValue = (dividendPercentBonus.getValueByPercent(inv.value) * payValueByTime) / 2;
126 
127         if (address(this).balance < dividendValue + inv.bonus) {
128             emit notEnoughETH(now, "not enough eth");
129             return;
130         }
131 
132         if (inv.bonus > 0) {
133             sendDividendsWithBonus(msg.sender, dividendValue, inv.bonus);
134         } else {
135             sendDividends(msg.sender, dividendValue);
136         }
137     }
138 
139 
140     function setAdvertisingAddress(address addr) public onlyOwner {
141         advertisingAddress = addr;
142     }
143 
144 
145     function sendDividends(address addr, uint value) private {
146         updatePayTime(addr, now);
147         emit logPayDividends(value, now, addr, "dividends");
148         addr.transfer(value);
149     }
150 
151     function sendDividendsWithBonus(address addr, uint value, uint bonus) private {
152         updatePayTime(addr, now);
153         emit logPayDividends(value + bonus, now, addr, "dividends with bonus");
154         addr.transfer(value + bonus);
155         investorsStorage[addr].bonus = 0;
156     }
157 
158     function findInvestorByAddress(address addr) internal view returns (User) {
159         return User(
160             investorsStorage[addr].idx,
161             investorsStorage[addr].value,
162             investorsStorage[addr].bonus,
163             investorsStorage[addr].invested10Eth,
164             investorsStorage[addr].payTime
165         );
166     }
167 
168     function sendValueToOwner(uint val) private {
169         owner.transfer(ownerPercent.getValueByPercent(val));
170     }
171 
172     function sendValueToAdv(uint val) private {
173         advertisingAddress.transfer(advertisingPercent.getValueByPercent(val));
174     }
175 
176 
177     function updatePayTime(address addr, uint time) private returns (bool) {
178         if (investorsStorage[addr].idx == 0) return false;
179         investorsStorage[addr].payTime = time;
180         return true;
181     }
182 }
183 
184 
185 
186 
187 // Calc library
188 library Calc {
189     function getDiffValue(uint _a, uint _b) internal pure returns (uint) {
190         require(_b > 0);
191         uint c = _a / _b;
192         return c;
193     }
194 
195     function sub(uint _a, uint _b) internal pure returns (uint) {
196         require(_b <= _a);
197         uint c = _a - _b;
198 
199         return c;
200     }
201 }
202 // Percent Calc library
203 library PercentCalc {
204     struct percent {
205         uint val;
206     }
207 
208     function getValueByPercent(percent storage p, uint a) internal view returns (uint) {
209         if (a == 0) {
210             return 0;
211         }
212         return a * p.val / 100;
213     }
214 }
215 
216 library Zero {
217     function notZero(address addr) internal pure returns (bool) {
218         return !(addr == address(0));
219     }
220 }
221 
222 
223 library compileLibrary {
224     function toAddr(bytes source) internal pure returns (address addr) {
225         assembly {addr := mload(add(source, 0x14))}
226         return addr;
227     }
228 }