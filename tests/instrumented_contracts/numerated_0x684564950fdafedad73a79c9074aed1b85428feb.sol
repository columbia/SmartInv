1 pragma solidity ^0.4.24;
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
12   function isPositive(Fraction memory fraction) internal pure returns (bool) {
13     return fraction.numerator > 0 && fraction.denominator > 0;
14   }
15 
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
17     r = a * b;
18     require((a == 0) || (r / a == b));
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
22     r = a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
26     require((r = a - b) <= a);
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
30     require((r = a + b) >= a);
31   }
32 
33   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
34     return x <= y ? x : y;
35   }
36 
37   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
38     return x >= y ? x : y;
39   }
40 
41   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
42     r = value * m;
43     if (r / value == m) {
44       r /= d;
45     } else {
46       r = mul(value / d, m);
47     }
48   }
49 
50   function mulDivCeil(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
51     r = value * m;
52     if (r / value == m) {
53       if (r % d == 0) {
54         r /= d;
55       } else {
56         r = (r / d) + 1;
57       }
58     } else {
59       r = mul(value / d, m);
60       if (value % d != 0) {
61         r += 1;
62       }
63     }
64   }
65 
66   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
67     return mulDiv(x, f.numerator, f.denominator);
68   }
69 
70   function mulCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
71     return mulDivCeil(x, f.numerator, f.denominator);
72   }
73 
74   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
75     return mulDiv(x, f.denominator, f.numerator);
76   }
77 
78   function divCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
79     return mulDivCeil(x, f.denominator, f.numerator);
80   }
81 
82   function mul(Fraction memory x, Fraction memory y) internal pure returns (Math.Fraction) {
83     return Math.Fraction({
84       numerator: mul(x.numerator, y.numerator),
85       denominator: mul(x.denominator, y.denominator)
86     });
87   }
88 }
89 
90 contract FsTKColdWallet {
91   using Math for uint256;
92 
93   event ConfirmationNeeded(address indexed initiator, bytes32 indexed operation, address indexed to, uint256 value, bytes data);
94   event Confirmation(address indexed authority, bytes32 indexed operation);
95   event Revoke(address indexed authority, bytes32 indexed operation);
96 
97   event AuthorityChanged(address indexed oldAuthority, address indexed newAuthority);
98   event AuthorityAdded(address authority);
99   event AuthorityRemoved(address authority);
100 
101   event RequirementChanged(uint256 required);
102   event DayLimitChanged(uint256 dayLimit);
103   event SpentTodayReset(uint256 spentToday);
104 
105   event Deposit(address indexed from, uint256 value);
106   event SingleTransaction(address indexed authority, address indexed to, uint256 value, bytes data, address created);
107   event MultiTransaction(address indexed authority, bytes32 indexed operation, address indexed to, uint256 value, bytes data, address created);
108 
109   struct TransactionInfo {
110     address to;
111     uint256 value;
112     bytes data;
113   }
114 
115   struct PendingTransactionState {
116     TransactionInfo info;
117     uint256 confirmNeeded;
118     uint256 confirmBitmap;
119     uint256 index;
120   }
121 
122   modifier onlyAuthority {
123     require(isAuthority(msg.sender));
124     _;
125   }
126 
127   modifier confirmAndRun(bytes32 operation) {
128     if (confirmAndCheck(operation)) {
129       _;
130     }
131   }
132 
133   uint256 constant MAX_AUTHORITIES = 250;
134 
135   uint256 public requiredAuthorities;
136   uint256 public numAuthorities;
137 
138   uint256 public dailyLimit;
139   uint256 public spentToday;
140   uint256 public lastDay;
141 
142   address[256] public authorities;
143   mapping(address => uint256) public authorityIndex;
144   mapping(bytes32 => PendingTransactionState) public pendingTransaction;
145   bytes32[] public pendingOperation;
146 
147   constructor(address[] _authorities, uint256 required, uint256 _daylimit) public {
148     require(
149       required > 0 &&
150       authorities.length >= required
151     );
152 
153     numAuthorities = _authorities.length;
154     for (uint256 i = 0; i < _authorities.length; i += 1) {
155       authorities[1 + i] = _authorities[i];
156       authorityIndex[_authorities[i]] = 1 + i;
157     }
158 
159     requiredAuthorities = required;
160 
161     dailyLimit = _daylimit;
162     lastDay = today();
163   }
164 
165   function() external payable {
166     if (msg.value > 0) {
167       emit Deposit(msg.sender, msg.value);
168     }
169   }
170 
171   function getAuthority(uint256 index) public view returns (address) {
172     return authorities[index + 1];
173   }
174 
175   function getAuthorityIndex(address authority) public view returns (uint256 index) {
176     index = authorityIndex[authority];
177     require(index > 0);
178   }
179 
180   function isAuthority(address authority) public view returns (bool) {
181     return authorityIndex[authority] > 0;
182   }
183 
184   function hasConfirmed(bytes32 operation, address _address) public view returns (bool) {
185     return (pendingTransaction[operation].confirmBitmap & (1 << getAuthorityIndex(_address))) != 0;
186   }
187 
188   function changeAuthority(address from, address to) public confirmAndRun(keccak256(msg.data)) {
189     require(!isAuthority(to));
190 
191     uint256 index = getAuthorityIndex(from);
192     authorities[index] = to;
193     authorityIndex[to] = index;
194     delete authorityIndex[from];
195     clearPending();
196 
197     emit AuthorityChanged(from, to);
198   }
199 
200   function addAuthority(address authority) public confirmAndRun(keccak256(msg.data)) {
201     require(!isAuthority(authority));
202     if (numAuthorities >= MAX_AUTHORITIES) {
203       reOrganizeAuthorities();
204     }
205     require(numAuthorities < MAX_AUTHORITIES);
206 
207     numAuthorities += 1;
208     authorities[numAuthorities] = authority;
209     authorityIndex[authority] = numAuthorities;
210     clearPending();
211 
212     emit AuthorityAdded(authority);
213   }
214 
215   function removeAuthority(address authority) public confirmAndRun(keccak256(msg.data)) {
216     require(numAuthorities > requiredAuthorities);
217 
218     uint256 index = getAuthorityIndex(authority);
219     delete authorities[index];
220     delete authorityIndex[authority];
221     clearPending();
222     reOrganizeAuthorities();
223 
224     emit AuthorityRemoved(authority);
225   }
226 
227   function setRequirement(uint256 required) public confirmAndRun(keccak256(msg.data)) {
228     require(numAuthorities >= requiredAuthorities);
229     clearPending();
230 
231     emit RequirementChanged(requiredAuthorities = required);
232   }
233 
234   function setDailyLimit(uint256 _dailyLimit) public confirmAndRun(keccak256(msg.data)) {
235     clearPending();
236 
237     emit DayLimitChanged(dailyLimit = _dailyLimit);
238   }
239 
240   function resetSpentToday() public confirmAndRun(keccak256(msg.data)) {
241     clearPending();
242 
243     emit SpentTodayReset(spentToday);
244     delete spentToday;
245   }
246 
247   function propose(
248     address to,
249     uint256 value,
250     bytes data
251   )
252     public
253     onlyAuthority
254     returns (bytes32 operation)
255   {
256     if ((data.length == 0 && checkAndUpdateLimit(value)) || requiredAuthorities == 1) {
257       emit SingleTransaction(msg.sender, to, value, data, execute0(to, value, data));
258     } else {
259       operation = keccak256(abi.encodePacked(msg.data, pendingOperation.length));
260       PendingTransactionState storage status = pendingTransaction[operation];
261       if (status.info.to == 0 && status.info.value == 0 && status.info.data.length == 0) {
262         status.info = TransactionInfo({
263           to: to,
264           value: value,
265           data: data
266         });
267       }
268 
269       if (!confirm(operation)) {
270         emit ConfirmationNeeded(msg.sender, operation, to, value, data);
271       }
272     }
273   }
274 
275   function revoke(bytes32 operation) public {
276     uint256 confirmFlag = 1 << getAuthorityIndex(msg.sender);
277     PendingTransactionState storage state = pendingTransaction[operation];
278     if (state.confirmBitmap & confirmFlag > 0) {
279       state.confirmNeeded += 1;
280       state.confirmBitmap &= ~confirmFlag;
281       emit Revoke(msg.sender, operation);
282     }
283   }
284 
285   function confirm(bytes32 operation) public confirmAndRun(operation) returns (bool) {
286      PendingTransactionState storage status = pendingTransaction[operation];
287     if (status.info.to != 0 || status.info.value != 0 || status.info.data.length != 0) {
288       emit MultiTransaction(
289         msg.sender,
290         operation,
291         status.info.to,
292         status.info.value,
293         status.info.data,
294         execute0(status.info.to, status.info.value, status.info.data)
295       );
296       delete pendingTransaction[operation].info;
297 
298       return true;
299     }
300   }
301 
302   function execute0(
303     address to,
304     uint256 value,
305     bytes data
306   )
307     private
308     returns (address created)
309   {
310     if (to == 0) {
311       created = create0(value, data);
312     } else {
313       require(to.call.value(value)(data));
314     }
315   }
316 
317   function create0(uint256 value, bytes code) internal returns (address _address) {
318     assembly {
319       _address := create(value, add(code, 0x20), mload(code))
320       if iszero(extcodesize(_address)) {
321         revert(0, 0)
322       }
323     }
324   }
325 
326   function confirmAndCheck(bytes32 operation) private returns (bool) {
327     PendingTransactionState storage pending = pendingTransaction[operation];
328     if (pending.confirmNeeded == 0) {
329       pending.confirmNeeded = requiredAuthorities;
330       delete pending.confirmBitmap;
331       pending.index = pendingOperation.length;
332       pendingOperation.push(operation);
333     }
334 
335     uint256 confirmFlag = 1 << getAuthorityIndex(msg.sender);
336 
337     if (pending.confirmBitmap & confirmFlag == 0) {
338       emit Confirmation(msg.sender, operation);
339       if (pending.confirmNeeded <= 1) {
340         delete pendingOperation[pending.index];
341         delete pending.confirmNeeded;
342         delete pending.confirmBitmap;
343         delete pending.index;
344         return true;
345       } else {
346         pending.confirmNeeded -= 1;
347         pending.confirmBitmap |= confirmFlag;
348       }
349     }
350   }
351 
352   function checkAndUpdateLimit(uint256 value) private returns (bool) {
353     if (today() > lastDay) {
354       spentToday = 0;
355       lastDay = today();
356     }
357 
358     uint256 _spentToday = spentToday.add(value);
359     if (_spentToday <= dailyLimit) {
360       spentToday = _spentToday;
361       return true;
362     }
363     return false;
364   }
365 
366   function today() private view returns (uint256) {
367     return block.timestamp / 1 days;
368   }
369 
370   function reOrganizeAuthorities() private {
371     uint256 free = 1;
372     while (free < numAuthorities) {
373       while (free < numAuthorities && authorities[free] != 0) {
374         free += 1;
375       }
376       while (numAuthorities > 1 && authorities[numAuthorities] == 0) {
377         numAuthorities -= 1;
378       }
379       if (free < numAuthorities && authorities[numAuthorities] != 0 && authorities[free] == 0) {
380         authorities[free] = authorities[numAuthorities];
381         authorityIndex[authorities[free]] = free;
382         delete authorities[numAuthorities];
383       }
384     }
385   }
386 
387   function clearPending() private {
388     for (uint256 i = 0; i < pendingOperation.length; i += 1) {
389       delete pendingTransaction[pendingOperation[i]];
390     }
391     delete pendingOperation;
392   }
393 
394 }