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
19 */
20 
21 
22 
23 library RecipientsStorage {
24   struct Storage {
25     mapping(address => Recipient) data;
26     KeyFlag[] keys;
27     uint size;
28   }
29 
30   struct Recipient { 
31     uint keyIndex;
32     Percent.percent percent;
33     bool isLocked;
34   }
35 
36   struct KeyFlag { 
37     address key; 
38     bool deleted;
39   }
40 
41   function init(Storage storage s) internal {
42     s.keys.length++;
43   }
44 
45   function insert(Storage storage s, address key, Percent.percent memory percent, bool isLocked) internal returns (bool) {
46     if (s.data[key].isLocked) {
47       return false;
48     }
49 
50     uint keyIndex = s.data[key].keyIndex;
51     s.data[key].percent = percent;
52     s.data[key].isLocked = isLocked;
53     if (keyIndex > 0) {
54       return true;
55     }
56     keyIndex = s.keys.length++;
57     s.data[key].keyIndex = keyIndex;
58     s.keys[keyIndex].key = key;
59     s.size++;
60     return true;
61   }
62 
63   function remove(Storage storage s, address key) internal returns (bool) {
64     if (s.data[key].isLocked) {
65       return false;
66     }
67 
68     uint keyIndex = s.data[key].keyIndex;
69     if (keyIndex == 0) {
70       return false;
71     }
72       
73     delete s.data[key];
74     s.keys[keyIndex].deleted = true;
75     s.size--;
76   }
77 
78   function unlock(Storage storage s, address key) internal returns (bool) {
79     if (s.data[key].keyIndex == 0) {
80       return false;
81     }
82     s.data[key].isLocked = false;
83     return true;
84   }
85   
86 
87   function recipient(Storage storage s, address key) internal view returns (Recipient memory r) {
88     return Recipient(s.data[key].keyIndex, s.data[key].percent, s.data[key].isLocked);
89   }
90 
91   function iterStart(Storage storage s) internal view returns (uint keyIndex) {
92     return iterNext(s, 0);
93   }
94 
95   function iterValid(Storage storage s, uint keyIndex) internal view returns (bool) {
96     return keyIndex < s.keys.length;
97   }
98 
99   function iterNext(Storage storage s, uint keyIndex) internal view returns (uint r_keyIndex) {
100     r_keyIndex = keyIndex + 1;
101     while (r_keyIndex < s.keys.length && s.keys[r_keyIndex].deleted) {
102       r_keyIndex++;
103     }
104   }
105 
106   function iterGet(Storage storage s, uint keyIndex) internal view returns (address key, Recipient memory r) {
107     key = s.keys[keyIndex].key;
108     r = Recipient(s.data[key].keyIndex, s.data[key].percent, s.data[key].isLocked);
109   }
110 }
111 
112 
113 contract Accessibility {
114   enum AccessRank { None, Payout, Full }
115   mapping(address => AccessRank) internal m_admins;
116   modifier onlyAdmin(AccessRank  r) {
117     require(
118       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
119       "access denied"
120     );
121     _;
122   }
123   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
124 
125   constructor() public {
126     m_admins[msg.sender] = AccessRank.Full;
127     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
128   }
129   
130   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
131     require(m_admins[addr] != AccessRank.Full, "cannot change full access rank");
132     if (m_admins[addr] != rank) {
133       m_admins[addr] = rank;
134       emit LogProvideAccess(addr, now, rank);
135     }
136   }
137 
138   function access(address addr) public view returns(AccessRank rank) {
139     rank = m_admins[addr];
140   }
141 }
142 
143 
144 library Percent {
145   // Solidity automatically throws when dividing by 0
146   struct percent {
147     uint num;
148     uint den;
149   }
150   // storage operations
151   function mul(percent storage p, uint a) internal view returns (uint) {
152     if (a == 0) {
153       return 0;
154     }
155     return a*p.num/p.den;
156   }
157 
158   function div(percent storage p, uint a) internal view returns (uint) {
159     return a/p.num*p.den;
160   }
161 
162   function sub(percent storage p, uint a) internal view returns (uint) {
163     uint b = mul(p, a);
164     if (b >= a) return 0; // solium-disable-line lbrace
165     return a - b;
166   }
167 
168   function add(percent storage p, uint a) internal view returns (uint) {
169     return a + mul(p, a);
170   }
171 
172   // memory operations
173   function mmul(percent memory p, uint a) internal pure returns (uint) {
174     if (a == 0) {
175       return 0;
176     }
177     return a*p.num/p.den;
178   }
179 
180   function mdiv(percent memory p, uint a) internal pure returns (uint) {
181     return a/p.num*p.den;
182   }
183 
184   function msub(percent memory p, uint a) internal pure returns (uint) {
185     uint b = mmul(p, a);
186     if (b >= a) return 0; // solium-disable-line lbrace
187     return a - b;
188   }
189 
190   function madd(percent memory p, uint a) internal pure returns (uint) {
191     return a + mmul(p, a);
192   }
193 }
194 
195 
196 contract Distributor is Accessibility {
197   using Percent for Percent.percent;
198   using RecipientsStorage for RecipientsStorage.Storage;
199   RecipientsStorage.Storage private m_recipients;
200 
201   uint public startupAO;
202   uint public payPaymentTime;
203   uint public payKeyIndex;
204   uint public payValue;
205 
206   event LogPayDividends(address indexed addr, uint when, uint value);
207 
208   constructor() public {
209     m_recipients.init();
210     payKeyIndex = m_recipients.iterStart();
211   }
212 
213   function() external payable {}
214 
215 
216   function payoutIsDone() public view returns(bool done) {
217     return payKeyIndex == m_recipients.iterStart();
218   }
219 
220   function initAO(address AO) public onlyAdmin(AccessRank.Full) {
221     require(startupAO == 0, "cannot reinit");
222     Percent.percent memory r = Percent.percent(74, 100); // 1% for payout bot
223     bool isLocked = true;
224     startupAO = now;
225     m_recipients.insert(AO, r, isLocked);
226   }
227 
228   function unlockAO(address AO) public onlyAdmin(AccessRank.Full) {
229     require(startupAO > 0, "cannot unlock zero AO");
230     require((startupAO + 3 * 365 days) <= now, "cannot unlock if 3 years not pass");
231     m_recipients.unlock(AO);
232   }
233 
234   function recipient(address addr) public view returns(uint numerator, uint denominator, bool isLocked) {
235     RecipientsStorage.Recipient memory r = m_recipients.recipient(addr);
236     return (r.percent.num, r.percent.den, r.isLocked);
237   }
238 
239   function recipientsSize() public view returns(uint size) {
240     return m_recipients.size;
241   }
242 
243   function recipients() public view returns(address[] memory addrs, uint[] memory nums, uint[] memory dens, bool[] memory isLockeds) {
244     addrs = new address[](m_recipients.size);
245     nums = new uint[](m_recipients.size);
246     dens = new uint[](m_recipients.size);
247     isLockeds = new bool[](m_recipients.size);
248     RecipientsStorage.Recipient memory r;
249     uint i = m_recipients.iterStart();
250     uint c;
251 
252     for (i; m_recipients.iterValid(i); i = m_recipients.iterNext(i)) {
253       (addrs[c], r) = m_recipients.iterGet(i);
254       nums[c] = r.percent.num;
255       dens[c] = r.percent.den;
256       isLockeds[c] = r.isLocked;
257       c++;
258     }
259   }
260 
261   function insertRecipients(address[] memory addrs, uint[] memory nums, uint[] memory dens) public onlyAdmin(AccessRank.Full) {
262     require(addrs.length == nums.length && nums.length == dens.length, "invalid arguments length");
263     bool isLocked = false;
264     for (uint i; i < addrs.length; i++) {
265       if (addrs[i] == address(0x0) || dens[i] == 0) {
266         continue;
267       }
268       m_recipients.insert(addrs[i], Percent.percent(nums[i], dens[i]), isLocked);
269     }
270   }
271 
272   function removeRecipients(address[] memory addrs) public onlyAdmin(AccessRank.Full) {
273     for (uint i; i < addrs.length; i++) {
274       m_recipients.remove(addrs[i]);
275     }
276   }
277 
278   function payout() public onlyAdmin(AccessRank.Payout) { 
279     if (payKeyIndex == m_recipients.iterStart()) {
280       require(address(this).balance > 0, "zero balance");
281       require(now>payPaymentTime+12 hours, "the latest payment was earlier than 12 hours");
282       payPaymentTime = now;
283       payValue = address(this).balance;
284     }
285     
286     uint i = payKeyIndex;
287     uint dividends;
288     RecipientsStorage.Recipient memory r;
289     address rAddr;
290 
291     for (i; m_recipients.iterValid(i) && gasleft() > 60000; i = m_recipients.iterNext(i)) {
292       (rAddr, r) = m_recipients.iterGet(i);
293       dividends = r.percent.mmul(payValue);
294       if (rAddr.send(dividends)) {
295         emit LogPayDividends(rAddr, now, dividends); 
296       }
297     }
298 
299     if (m_recipients.iterValid(i)) {
300       payKeyIndex = i;
301     } else {
302       payKeyIndex = m_recipients.iterStart();
303     }
304   }
305 }