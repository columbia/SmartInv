1 pragma solidity ^0.4.23;
2 pragma experimental "v0.5.0";
3 pragma experimental ABIEncoderV2;
4 
5 library Math {
6 
7   struct Fraction {
8     uint256 numerator;
9     uint256 denominator;
10   }
11 
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
13     r = a * b;
14     require((a == 0) || (r / a == b));
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
18     r = a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
22     require((r = a - b) <= a);
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
26     require((r = a + b) >= a);
27   }
28 
29   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
30     return x <= y ? x : y;
31   }
32 
33   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
34     return x >= y ? x : y;
35   }
36 
37   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
38     r = value * m;
39     if (r / value == m) {
40       r /= d;
41     } else {
42       r = mul(value / d, m);
43     }
44   }
45 
46   function mulDivCeil(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
47     r = value * m;
48     if (r / value == m) {
49       r /= d;
50       if (r % d != 0) {
51         r += 1;
52       }
53     } else {
54       r = mul(value / d, m);
55       if (value % d != 0) {
56         r += 1;
57       }
58     }
59   }
60 
61   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
62     return mulDiv(x, f.numerator, f.denominator);
63   }
64 
65   function mulCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
66     return mulDivCeil(x, f.numerator, f.denominator);
67   }
68 
69   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
70     return mulDiv(x, f.denominator, f.numerator);
71   }
72 
73   function divCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
74     return mulDivCeil(x, f.denominator, f.numerator);
75   }
76 }
77 
78 contract FsTKColdWallet {
79   using Math for uint256;
80 
81   event ConfirmationNeeded(address indexed initiator, bytes32 indexed operation, address indexed to, uint256 value, bytes data);
82   event Confirmation(address indexed authority, bytes32 indexed operation);
83   event Revoke(address indexed authority, bytes32 indexed operation);
84 
85   event AuthorityChanged(address indexed oldAuthority, address indexed newAuthority);
86   event AuthorityAdded(address authority);
87   event AuthorityRemoved(address authority);
88 
89   event RequirementChanged(uint256 required);
90   event DayLimitChanged(uint256 dayLimit);
91   event SpentTodayReset(uint256 spentToday);
92 
93   event Deposit(address indexed from, uint256 value);
94   event SingleTransaction(address indexed authority, address indexed to, uint256 value, bytes data, address created);
95   event MultiTransaction(address indexed authority, bytes32 indexed operation, address indexed to, uint256 value, bytes data, address created);
96 
97   struct TransactionInfo {
98     address to;
99     uint256 value;
100     bytes data;
101   }
102 
103   struct PendingTransactionState {
104     TransactionInfo info;
105     uint256 confirmNeeded;
106     uint256 confirmBitmap;
107     uint256 index;
108   }
109 
110   modifier onlyAuthority {
111     require(isAuthority(msg.sender));
112     _;
113   }
114 
115   modifier confirmAndRun(bytes32 operation) {
116     if (confirmAndCheck(operation)) {
117       _;
118     }
119   }
120 
121   uint256 constant MAX_AUTHORITIES = 250;
122 
123   uint256 public requiredAuthorities;
124   uint256 public numAuthorities;
125 
126   uint256 public dailyLimit;
127   uint256 public spentToday;
128   uint256 public lastDay;
129 
130   address[256] public authorities;
131   mapping(address => uint256) public authorityIndex;
132   mapping(bytes32 => PendingTransactionState) public pendingTransaction;
133   bytes32[] public pendingOperation;
134 
135   constructor(address[] _authorities, uint256 required, uint256 _daylimit) public {
136     require(required > 0);
137     require(authorities.length >= required);
138 
139     numAuthorities = _authorities.length;
140     for (uint256 i = 0; i < _authorities.length; i += 1) {
141       authorities[1 + i] = _authorities[i];
142       authorityIndex[_authorities[i]] = 1 + i;
143     }
144 
145     requiredAuthorities = required;
146 
147     dailyLimit = _daylimit;
148     lastDay = today();
149   }
150 
151   function() external payable {
152     if (msg.value > 0) {
153       emit Deposit(msg.sender, msg.value);
154     }
155   }
156 
157   function getAuthority(uint256 index) public view returns (address) {
158     return authorities[index + 1];
159   }
160 
161   function getAuthorityIndex(address authority) public view returns (uint256 index) {
162     index = authorityIndex[authority];
163     require(index > 0);
164   }
165 
166   function isAuthority(address authority) public view returns (bool) {
167     return authorityIndex[authority] > 0;
168   }
169 
170   function hasConfirmed(bytes32 operation, address _address) public view returns (bool) {
171     return (pendingTransaction[operation].confirmBitmap & (1 << getAuthorityIndex(_address))) != 0;
172   }
173 
174   function changeAuthority(address from, address to) public confirmAndRun(keccak256(msg.data)) {
175     require(!isAuthority(to));
176 
177     uint256 index = getAuthorityIndex(from);
178     authorities[index] = to;
179     authorityIndex[to] = index;
180     delete authorityIndex[from];
181     clearPending();
182 
183     emit AuthorityChanged(from, to);
184   }
185 
186   function addAuthority(address authority) public confirmAndRun(keccak256(msg.data)) {
187     require(!isAuthority(authority));
188     if (numAuthorities >= MAX_AUTHORITIES) {
189       reOrganizeAuthorities();
190     }
191     require(numAuthorities < MAX_AUTHORITIES);
192 
193     numAuthorities += 1;
194     authorities[numAuthorities] = authority;
195     authorityIndex[authority] = numAuthorities;
196     clearPending();
197 
198     emit AuthorityAdded(authority);
199   }
200 
201   function removeAuthority(address authority) public confirmAndRun(keccak256(msg.data)) {
202     require(numAuthorities > requiredAuthorities);
203 
204     uint256 index = getAuthorityIndex(authority);
205     delete authorities[index];
206     delete authorityIndex[authority];
207     clearPending();
208     reOrganizeAuthorities();
209 
210     emit AuthorityRemoved(authority);
211   }
212 
213   function setRequirement(uint256 required) public confirmAndRun(keccak256(msg.data)) {
214     require(numAuthorities >= requiredAuthorities);
215     clearPending();
216 
217     emit RequirementChanged(requiredAuthorities = required);
218   }
219 
220   function setDailyLimit(uint256 _dailyLimit) public confirmAndRun(keccak256(msg.data)) {
221     clearPending();
222 
223     emit DayLimitChanged(dailyLimit = _dailyLimit);
224   }
225 
226   function resetSpentToday() public confirmAndRun(keccak256(msg.data)) {
227     clearPending();
228 
229     emit SpentTodayReset(spentToday);
230     delete spentToday;
231   }
232 
233   function propose(
234     address to,
235     uint256 value,
236     bytes data
237   )
238     public
239     onlyAuthority
240     returns (bytes32 operation)
241   {
242     if ((data.length == 0 && checkAndUpdateLimit(value)) || requiredAuthorities == 1) {
243       emit SingleTransaction(msg.sender, to, value, data, execute0(to, value, data));
244     } else {
245       operation = keccak256(msg.data, pendingOperation.length);
246       PendingTransactionState storage status = pendingTransaction[operation];
247       if (status.info.to == 0 && status.info.value == 0 && status.info.data.length == 0) {
248         status.info = TransactionInfo({
249           to: to,
250           value: value,
251           data: data
252         });
253       }
254 
255       if (!confirm(operation)) {
256         emit ConfirmationNeeded(msg.sender, operation, to, value, data);
257       }
258     }
259   }
260 
261   function revoke(bytes32 operation) public {
262     uint256 confirmFlag = 1 << getAuthorityIndex(msg.sender);
263     PendingTransactionState storage state = pendingTransaction[operation];
264     if (state.confirmBitmap & confirmFlag > 0) {
265       state.confirmNeeded += 1;
266       state.confirmBitmap &= ~confirmFlag;
267       emit Revoke(msg.sender, operation);
268     }
269   }
270 
271   function confirm(bytes32 operation) public confirmAndRun(operation) returns (bool) {
272      PendingTransactionState storage status = pendingTransaction[operation];
273     if (status.info.to != 0 || status.info.value != 0 || status.info.data.length != 0) {
274       emit MultiTransaction(
275         msg.sender,
276         operation,
277         status.info.to,
278         status.info.value,
279         status.info.data,
280         execute0(status.info.to, status.info.value, status.info.data)
281       );
282       delete pendingTransaction[operation].info;
283 
284       return true;
285     }
286   }
287 
288   function execute0(
289     address to,
290     uint256 value,
291     bytes data
292   )
293     private
294     returns (address created)
295   {
296     if (to == 0) {
297       created = create0(value, data);
298     } else {
299       require(to.call.value(value)(data));
300     }
301   }
302 
303   function create0(uint256 value, bytes code) internal returns (address _address) {
304     assembly {
305       _address := create(value, add(code, 0x20), mload(code))
306       if iszero(extcodesize(_address)) {
307         revert(0, 0)
308       }
309     }
310   }
311 
312   function confirmAndCheck(bytes32 operation) private returns (bool) {
313     PendingTransactionState storage pending = pendingTransaction[operation];
314     if (pending.confirmNeeded == 0) {
315       pending.confirmNeeded = requiredAuthorities;
316       delete pending.confirmBitmap;
317       pending.index = pendingOperation.length;
318       pendingOperation.push(operation);
319     }
320 
321     uint256 confirmFlag = 1 << getAuthorityIndex(msg.sender);
322 
323     if (pending.confirmBitmap & confirmFlag == 0) {
324       emit Confirmation(msg.sender, operation);
325       if (pending.confirmNeeded <= 1) {
326         delete pendingOperation[pending.index];
327         delete pending.confirmNeeded;
328         delete pending.confirmBitmap;
329         delete pending.index;
330         return true;
331       } else {
332         pending.confirmNeeded -= 1;
333         pending.confirmBitmap |= confirmFlag;
334       }
335     }
336   }
337 
338   function checkAndUpdateLimit(uint256 value) private returns (bool) {
339     if (today() > lastDay) {
340       spentToday = 0;
341       lastDay = today();
342     }
343 
344     uint256 _spentToday = spentToday.add(value);
345     if (_spentToday <= dailyLimit) {
346       spentToday = _spentToday;
347       return true;
348     }
349     return false;
350   }
351 
352   function today() private view returns (uint256) {
353     return block.timestamp / 1 days;
354   }
355 
356   function reOrganizeAuthorities() private {
357     uint256 free = 1;
358     while (free < numAuthorities) {
359       while (free < numAuthorities && authorities[free] != 0) {
360         free += 1;
361       }
362       while (numAuthorities > 1 && authorities[numAuthorities] == 0) {
363         numAuthorities -= 1;
364       }
365       if (free < numAuthorities && authorities[numAuthorities] != 0 && authorities[free] == 0) {
366         authorities[free] = authorities[numAuthorities];
367         authorityIndex[authorities[free]] = free;
368         delete authorities[numAuthorities];
369       }
370     }
371   }
372 
373   function clearPending() private {
374     for (uint256 i = 0; i < pendingOperation.length; i += 1) {
375       delete pendingTransaction[pendingOperation[i]];
376     }
377     delete pendingOperation;
378   }
379 
380 }