1 pragma solidity 0.4.25;
2 
3 /** 
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 * 
6 * Web              - https://333eth.io
7 * 
8 * Twitter          - https://twitter.com/333eth_io
9 * 
10 * Telegram_channel - https://t.me/Ethereum333
11 * 
12 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
13 * 
14 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
15 * 
16 * KOR Telegram_chat: https://t.me/Ethereum333_chat_kor
17 * 
18 * Email:             mailto:support(at sign)333eth.io
19 * 
20 * 
21 * 
22 * AO Rules:
23 * 
24 * Shareholders are all participants of 333eth v1, v2 projects without exception
25 * 
26 * Received ETH share as follows:
27 * 
28 * 97% for losers, in projects 333eth v1, v2 in proportion to their losses
29 * 
30 * 3% for winners - the same amount.
31 * 
32 * 
33 * 
34 * Payment of dividends - every Saturday at 18.00 Moscow time.
35 * 
36 * The contract of the JSC prescribed a waiver of ownership. And payments are unchanged.
37 * 
38 * The specific amount of payments to each shareholder is determined by the success of the project. Your participation in previous projects determines your % in AO.
39 */
40 
41 
42 library RecipientsStorage {
43   struct Storage {
44     mapping(address => Recipient) data;
45     KeyFlag[] keys;
46     uint size;
47     uint losersValSum;
48     uint winnersNum;
49   }
50 
51   struct Recipient { 
52     uint keyIndex;
53     uint value;
54     bool isWinner;
55   }
56 
57   struct KeyFlag { 
58     address key; 
59     bool deleted;
60   }
61 
62   function init(Storage storage s) internal {
63     s.keys.length++;
64   }
65 
66   function insert(Storage storage s, address key, uint value, bool isWinner) internal returns (bool) {
67     uint keyIndex = s.data[key].keyIndex;
68    
69     if (!s.data[key].isWinner) {
70       s.losersValSum -= s.data[key].value;
71     }
72 
73     if (!isWinner) {
74       s.losersValSum += value;
75     }
76 
77     if (isWinner && !s.data[key].isWinner) {
78       s.winnersNum++;
79     }
80     s.data[key].value = value;
81     s.data[key].isWinner = isWinner;
82 
83     if (keyIndex > 0) {
84       return true;
85     }
86 
87     keyIndex = s.keys.length++;
88     s.data[key].keyIndex = keyIndex;
89     s.keys[keyIndex].key = key;
90     s.size++;
91     return true;
92   }
93 
94   function remove(Storage storage s, address key) internal returns (bool) {
95     uint keyIndex = s.data[key].keyIndex;
96     if (keyIndex == 0) {
97       return false;
98     }
99 
100     if (s.data[key].isWinner) {
101       s.winnersNum--;
102     } else {
103       s.losersValSum -= s.data[key].value;
104     }
105     
106       
107     delete s.data[key];
108     s.keys[keyIndex].deleted = true;
109     s.size--;
110     return true;
111   }
112 
113   function recipient(Storage storage s, address key) internal view returns (Recipient memory r) {
114     return Recipient(s.data[key].keyIndex, s.data[key].value, s.data[key].isWinner);
115   }
116   
117   function iterStart(Storage storage s) internal view returns (uint keyIndex) {
118     return iterNext(s, 0);
119   }
120 
121   function iterValid(Storage storage s, uint keyIndex) internal view returns (bool) {
122     return keyIndex < s.keys.length;
123   }
124 
125   function iterNext(Storage storage s, uint keyIndex) internal view returns (uint r_keyIndex) {
126     r_keyIndex = keyIndex + 1;
127     while (r_keyIndex < s.keys.length && s.keys[r_keyIndex].deleted) {
128       r_keyIndex++;
129     }
130   }
131 
132   function iterGet(Storage storage s, uint keyIndex) internal view returns (address key, Recipient storage r) {
133     key = s.keys[keyIndex].key;
134     r = s.data[key];
135   }
136 }
137 
138 
139 contract Accessibility {
140   enum AccessRank { None, Payout, Manager, Full }
141   mapping(address => AccessRank) internal m_admins;
142   modifier onlyAdmin(AccessRank  r) {
143     require(
144       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
145       "access denied"
146     );
147     _;
148   }
149   event LogProvideAccess(address indexed whom, AccessRank rank, uint when);
150 
151   constructor() public {
152     m_admins[msg.sender] = AccessRank.Full;
153     emit LogProvideAccess(msg.sender, AccessRank.Full, now);
154   }
155   
156   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Manager) {
157     require(rank <= AccessRank.Manager, "cannot to give full access rank");
158     if (m_admins[addr] != rank) {
159       m_admins[addr] = rank;
160       emit LogProvideAccess(addr, rank, now);
161     }
162   }
163 
164   function access(address addr) public view returns(AccessRank rank) {
165     rank = m_admins[addr];
166   }
167 }
168 
169 
170 library Percent {
171   // Solidity automatically throws when dividing by 0
172   struct percent {
173     uint num;
174     uint den;
175   }
176   // storage operations
177   function mul(percent storage p, uint a) internal view returns (uint) {
178     if (a == 0) {
179       return 0;
180     }
181     return a*p.num/p.den;
182   }
183 
184   function div(percent storage p, uint a) internal view returns (uint) {
185     return a/p.num*p.den;
186   }
187 
188   function sub(percent storage p, uint a) internal view returns (uint) {
189     uint b = mul(p, a);
190     if (b >= a) return 0; // solium-disable-line lbrace
191     return a - b;
192   }
193 
194   function add(percent storage p, uint a) internal view returns (uint) {
195     return a + mul(p, a);
196   }
197 
198   // memory operations
199   function mmul(percent memory p, uint a) internal pure returns (uint) {
200     if (a == 0) {
201       return 0;
202     }
203     return a*p.num/p.den;
204   }
205 
206   function mdiv(percent memory p, uint a) internal pure returns (uint) {
207     return a/p.num*p.den;
208   }
209 
210   function msub(percent memory p, uint a) internal pure returns (uint) {
211     uint b = mmul(p, a);
212     if (b >= a) return 0; // solium-disable-line lbrace
213     return a - b;
214   }
215 
216   function madd(percent memory p, uint a) internal pure returns (uint) {
217     return a + mmul(p, a);
218   }
219 }
220 
221 
222 contract AO is Accessibility {
223   using Percent for Percent.percent;
224   using RecipientsStorage for RecipientsStorage.Storage;
225   
226   uint public payPaymentTime;
227   uint public payKeyIndex;
228   uint public payValue;
229 
230   RecipientsStorage.Storage private m_recipients;
231   Percent.percent private m_winnersPercent = Percent.percent(3, 100);
232   Percent.percent private m_losersPercent = Percent.percent(97, 100);
233 
234   event LogPayDividends(address indexed addr, uint dividends, bool isWinner, uint when);
235   event LogInsertRecipient(address indexed addr, uint value, bool isWinner, uint when);
236   event LogRemoveRecipient(address indexed addr, uint when);
237 
238   constructor() public {
239     m_recipients.init();
240     payKeyIndex = m_recipients.iterStart();
241   }
242 
243   function() external payable {}
244 
245   function payoutIsDone() public view returns(bool done) {
246     return payKeyIndex == m_recipients.iterStart();
247   }
248 
249   function losersValueSum() public view returns(uint sum) {
250     return m_recipients.losersValSum;
251   }
252 
253   function winnersNumber() public view returns(uint number) {
254     return m_recipients.winnersNum;
255   }
256 
257   function recipient(address addr) public view returns(uint value, bool isWinner, uint numerator, uint denominator) {
258     RecipientsStorage.Recipient memory r = m_recipients.recipient(addr);
259     (value, isWinner) = (r.value, r.isWinner);
260 
261     if (r.isWinner) {
262       numerator = m_winnersPercent.num;
263       denominator = m_winnersPercent.den * m_recipients.winnersNum;
264     } else {
265       numerator = m_losersPercent.num * r.value;
266       denominator = m_losersPercent.den * m_recipients.losersValSum;
267     }
268   }
269 
270   function recipientsSize() public view returns(uint size) {
271     return m_recipients.size;
272   }
273 
274   function recipients() public view returns(address[] memory addrs, uint[] memory values, bool[] memory isWinners) {
275     addrs = new address[](m_recipients.size);
276     values = new uint[](m_recipients.size);
277     isWinners = new bool[](m_recipients.size);
278     RecipientsStorage.Recipient memory r;
279     uint i = m_recipients.iterStart();
280     uint c;
281 
282     for (i; m_recipients.iterValid(i); i = m_recipients.iterNext(i)) {
283       (addrs[c], r) = m_recipients.iterGet(i);
284       values[c] = r.value;
285       isWinners[c] = r.isWinner;
286       c++;
287     }
288   }
289 
290   function insertRecipients(address[] memory addrs, uint[] memory values, bool[] memory isWinners) public onlyAdmin(AccessRank.Full) {
291     require(addrs.length == values.length && values.length == isWinners.length, "invalid arguments length");
292     for (uint i; i < addrs.length; i++) {
293       if (addrs[i] == address(0x0)) {
294         continue;
295       }
296       if (m_recipients.insert(addrs[i], values[i], isWinners[i])) {
297         emit LogInsertRecipient(addrs[i], values[i], isWinners[i], now);
298       }
299     }
300   }
301 
302   function removeRecipients(address[] memory addrs) public onlyAdmin(AccessRank.Full) {
303     for (uint i; i < addrs.length; i++) {
304       if (m_recipients.remove(addrs[i])) {
305         emit LogRemoveRecipient(addrs[i], now);
306       }
307     }
308   }
309 
310   function payout() public onlyAdmin(AccessRank.Payout) { 
311     if (payKeyIndex == m_recipients.iterStart()) {
312       require(address(this).balance > 0, "zero balance");
313       require(now > payPaymentTime + 12 hours, "the latest payment was earlier than 12 hours");
314       payPaymentTime = now;
315       payValue = address(this).balance;
316     }
317 
318     uint dividends;
319     uint i = payKeyIndex;
320     uint valueForWinner = m_winnersPercent.mul(payValue) / m_recipients.winnersNum;
321     uint valueForLosers = m_losersPercent.mul(payValue);
322     RecipientsStorage.Recipient memory r;
323     address rAddr;
324 
325     for (i; m_recipients.iterValid(i) && gasleft() > 60000; i = m_recipients.iterNext(i)) {
326       (rAddr, r) = m_recipients.iterGet(i);
327       if (r.isWinner) {
328         dividends = valueForWinner;
329       } else {
330         dividends = valueForLosers * r.value / m_recipients.losersValSum;
331       }
332       if (rAddr.send(dividends)) {
333         emit LogPayDividends(rAddr, dividends, r.isWinner, now);
334       }
335     }
336 
337     if (m_recipients.iterValid(i)) {
338       payKeyIndex = i;
339     } else {
340       payKeyIndex = m_recipients.iterStart();
341     }
342   }
343 }