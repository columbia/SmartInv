1 /**
2  * @title The MORIART contracts concept.
3  * @author www.grox.solutions
4  */
5 
6 pragma solidity 0.5.10;
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b > 0);
23         uint256 c = a / b;
24 
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38 
39         return c;
40     }
41 }
42 
43 interface IERC20 {
44     function totalSupply() external view returns (uint256);
45     function balanceOf(address who) external view returns (uint256);
46     function allowance(address owner, address spender) external view returns (uint256);
47     function transfer(address to, uint256 value) external returns (bool);
48     function approve(address spender, uint256 value) external returns (bool);
49     function transferFrom(address from, address to, uint256 value) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract ERC20 is IERC20 {
55     using SafeMath for uint256;
56 
57     mapping (address => uint256) internal _balances;
58 
59     mapping (address => mapping (address => uint256)) internal _allowed;
60 
61     uint256 internal _totalSupply;
62 
63     function totalSupply() public view returns (uint256) {
64         return _totalSupply;
65     }
66 
67     function balanceOf(address addr) public view returns (uint256) {
68         return _balances[addr];
69     }
70 
71     function allowance(address addr, address spender) public view returns (uint256) {
72         return _allowed[addr][spender];
73     }
74 
75     function approve(address spender, uint256 value) public returns (bool) {
76         require(spender != address(0));
77 
78         _allowed[msg.sender][spender] = value;
79         emit Approval(msg.sender, spender, value);
80         return true;
81     }
82 
83     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
84         require(spender != address(0));
85 
86         _allowed[msg.sender][spender] = (
87         _allowed[msg.sender][spender].add(addedValue));
88         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
89         return true;
90     }
91 
92     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
93         require(spender != address(0));
94 
95         _allowed[msg.sender][spender] = (
96         _allowed[msg.sender][spender].sub(subtractedValue));
97         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
98         return true;
99     }
100 
101     function transfer(address to, uint256 value) public returns (bool) {
102         _transfer(msg.sender, to, value);
103         return true;
104     }
105 
106     function transferFrom(address from, address to, uint256 value) public returns (bool) {
107         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
108         _transfer(from, to, value);
109         return true;
110     }
111 
112     function _transfer(address from, address to, uint256 value) internal {
113         require(to != address(0));
114 
115         _balances[from] = _balances[from].sub(value);
116         _balances[to] = _balances[to].add(value);
117 
118         emit Transfer(from, to, value);
119     }
120 }
121 
122 contract DetailedToken is ERC20 {
123 
124     string private _name = "Moriartio";
125     string private _symbol = "MIO";
126     uint8 private _decimals = 18;
127 
128     function name() public view returns(string memory) {
129         return _name;
130     }
131 
132     function symbol() public view returns(string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view returns(uint8) {
137       return _decimals;
138     }
139 
140 }
141 
142 contract TOKEN is DetailedToken {
143 
144     mapping (address => uint256) internal _payoutsTo;
145 
146     uint256 internal magnitude = 1e18;
147     uint256 internal profitPerShare = 1e18;
148 
149     uint256 constant public DIV_TRIGGER = 0.000333 ether;
150 
151     event DividendsPayed(address indexed addr, uint256 amount);
152 
153     function _transfer(address payable from, address to, uint256 value) internal {
154         require(to != address(0));
155 
156         if (dividendsOf(from) > 0) {
157             _withdrawDividends(from);
158         }
159 
160         _balances[from] = _balances[from].sub(value);
161         _balances[to] = _balances[to].add(value);
162         _payoutsTo[from] -= profitPerShare * value;
163         _payoutsTo[to] += profitPerShare * value;
164 
165         emit Transfer(from, to, value);
166     }
167 
168     function _purchase(address recipient, uint256 value) internal {
169         if (totalSupply() > 0) {
170             profitPerShare = profitPerShare.add(value * magnitude / totalSupply());
171             _payoutsTo[recipient] = _payoutsTo[recipient].add(profitPerShare * value);
172         }
173 
174         _totalSupply = _totalSupply.add(value);
175         _balances[recipient] = _balances[recipient].add(value);
176 
177         emit Transfer(address(0), recipient, value);
178     }
179 
180     function _withdrawDividends(address payable addr) internal {
181         uint256 payout = dividendsOf(addr);
182         if (payout > 0) {
183             _payoutsTo[addr] = _payoutsTo[addr].add(dividendsOf(addr) * magnitude);
184             uint256 value;
185             if (msg.value == DIV_TRIGGER) {
186                 value = DIV_TRIGGER;
187             }
188             addr.transfer(payout + value);
189 
190             emit DividendsPayed(addr, payout);
191         }
192     }
193 
194     function dividendsOf(address addr) public view returns(uint256) {
195         return (profitPerShare.mul(balanceOf(addr)).sub(_payoutsTo[addr])) / magnitude;
196     }
197 
198     function myDividends() public view returns(uint256) {
199         return dividendsOf(msg.sender);
200     }
201 
202 }
203 
204 contract MORIART is TOKEN {
205     using SafeMath for uint256;
206 
207     uint256 constant public ONE_HUNDRED   = 10000;
208     uint256 constant public ADMIN_FEE     = 1000;
209     uint256 constant public TOKENIZATION  = 500;
210     uint256 constant public ONE_DAY       = 1 days;
211     uint256 constant public MINIMUM       = 0.1 ether;
212     uint16[3] public refPercent           = [300, 200, 100];
213 
214     uint256 constant public REF_TRIGGER   = 0 ether;
215     uint256 constant public EXIT_TRIGGER  = 0.000777 ether;
216 
217     struct Deposit {
218         uint256 amount;
219         uint256 time;
220     }
221 
222     struct User {
223         Deposit[] deposits;
224         address referrer;
225         uint256 bonus;
226     }
227 
228     mapping (address => User) public users;
229 
230     address payable public admin = 0x9C14a7882f635acebbC7f0EfFC0E2b78B9Aa4858;
231 
232     uint256 public maxBalance;
233 
234     uint256 public start = 1574035200;
235     bool public finalized;
236 
237     event InvestorAdded(address indexed investor);
238     event ReferrerAdded(address indexed investor, address indexed referrer);
239     event DepositAdded(address indexed investor, uint256 amount);
240     event Withdrawn(address indexed investor, uint256 amount);
241     event RefBonusAdded(address indexed investor, address indexed referrer, uint256 amount, uint256 indexed level);
242     event RefBonusPayed(address indexed investor, uint256 amount);
243     event Finalized(uint256 amount);
244 
245     modifier notOnPause() {
246         require(block.timestamp >= start && !finalized);
247         _;
248     }
249 
250     function() external payable {
251         if (msg.value == REF_TRIGGER) {
252             _withdrawBonus(msg.sender);
253         } else if (msg.value == DIV_TRIGGER) {
254             _withdrawDividends(msg.sender);
255         } else if (msg.value == EXIT_TRIGGER) {
256             _exit(msg.sender);
257         } else {
258             _invest(msg.sender);
259         }
260     }
261 
262     function _invest(address addr) internal notOnPause {
263         require(msg.value >= MINIMUM);
264         admin.transfer(msg.value * ADMIN_FEE / ONE_HUNDRED);
265 
266         users[addr].deposits.push(Deposit(msg.value, block.timestamp));
267 
268         if (users[addr].referrer != address(0)) {
269             _refSystem(addr);
270         } else if (msg.data.length == 20) {
271             _addReferrer(addr, _bytesToAddress(bytes(msg.data)));
272         }
273 
274         if (users[addr].deposits.length == 1) {
275             emit InvestorAdded(addr);
276         }
277 
278         _purchase(addr, msg.value * TOKENIZATION / ONE_HUNDRED);
279 
280         maxBalance += msg.value;
281 
282         emit DepositAdded(addr, msg.value);
283     }
284 
285     function _withdrawBonus(address payable addr) internal {
286         uint256 payout = getRefBonus(addr);
287         if (payout > 0) {
288             users[addr].bonus = 0;
289 
290             bool onFinalizing;
291             if (payout + REF_TRIGGER > address(this).balance.sub(getFinalWave())) {
292                 payout = address(this).balance.sub(getFinalWave());
293                 onFinalizing = true;
294             }
295 
296             addr.transfer(payout + REF_TRIGGER);
297 
298             emit RefBonusPayed(addr, payout);
299 
300             if (onFinalizing) {
301                 _finalize();
302             }
303         }
304     }
305 
306     function _withdrawDividends(address payable addr) internal {
307         uint256 payout = dividendsOf(addr);
308         if (payout > 0) {
309             _payoutsTo[addr] = _payoutsTo[addr].add(dividendsOf(addr) * magnitude);
310 
311             uint256 value;
312             if (msg.value == DIV_TRIGGER) {
313                 value = DIV_TRIGGER;
314             }
315 
316             bool onFinalizing;
317             if (payout + value > address(this).balance.sub(getFinalWave())) {
318                 payout = address(this).balance.sub(getFinalWave());
319                 onFinalizing = true;
320             }
321 
322             addr.transfer(payout + value);
323 
324             emit DividendsPayed(addr, payout);
325 
326             if (onFinalizing) {
327                 _finalize();
328             }
329         }
330     }
331 
332     function _exit(address payable addr) internal {
333 
334         uint256 payout = getProfit(addr);
335 
336         if (getRefBonus(addr) != 0) {
337             payout = payout.add(getRefBonus(addr));
338             emit RefBonusPayed(addr, getRefBonus(addr));
339             users[addr].bonus = 0;
340         }
341 
342         if (dividendsOf(addr) != 0) {
343             payout = payout.add(dividendsOf(addr));
344             emit DividendsPayed(addr, dividendsOf(addr));
345             _payoutsTo[addr] = _payoutsTo[addr].add(dividendsOf(addr) * magnitude);
346         }
347 
348         require(payout >= MINIMUM);
349 
350         bool onFinalizing;
351         if (payout + EXIT_TRIGGER > address(this).balance.sub(getFinalWave())) {
352             payout = address(this).balance.sub(getFinalWave());
353             onFinalizing = true;
354         }
355 
356         delete users[addr];
357 
358         addr.transfer(payout + EXIT_TRIGGER);
359 
360         emit Withdrawn(addr, payout);
361 
362         if (onFinalizing) {
363             _finalize();
364         }
365     }
366 
367     function _bytesToAddress(bytes memory source) internal pure returns(address parsedReferrer) {
368         assembly {
369             parsedReferrer := mload(add(source,0x14))
370         }
371         return parsedReferrer;
372     }
373 
374     function _addReferrer(address addr, address refAddr) internal {
375         if (refAddr != addr) {
376             users[addr].referrer = refAddr;
377 
378             _refSystem(addr);
379             emit ReferrerAdded(addr, refAddr);
380         }
381     }
382 
383     function _refSystem(address addr) internal {
384         address referrer = users[addr].referrer;
385 
386         for (uint256 i = 0; i < 3; i++) {
387             if (referrer != address(0)) {
388                 uint256 amount = msg.value * refPercent[i] / ONE_HUNDRED;
389                 users[referrer].bonus += amount;
390                 emit RefBonusAdded(addr, referrer, amount, i + 1);
391                 referrer = users[referrer].referrer;
392             } else break;
393         }
394     }
395 
396     function _finalize() internal {
397         admin.transfer(getFinalWave());
398         finalized = true;
399         emit Finalized(getFinalWave());
400     }
401 
402     function setRefPercent(uint16[3] memory newRefPercents) public {
403         require(msg.sender == admin);
404         for (uint256 i = 0; i < 3; i++) {
405             require(newRefPercents[i] <= 1000);
406         }
407         refPercent = newRefPercents;
408     }
409 
410     function getPercent() public view returns(uint256) {
411         if (block.timestamp >= start) {
412             uint256 time = block.timestamp.sub(start);
413             if (time < 60 * ONE_DAY) {
414                 return 10e18 + time * 1e18 * 10 / 60 / ONE_DAY;
415             }
416             if (time < 120 * ONE_DAY) {
417                 return 20e18 + (time - 60 * ONE_DAY) * 1e18 * 15 / 60 / ONE_DAY;
418             }
419             if (time < 180 * ONE_DAY) {
420                 return 35e18 + (time - 120 * ONE_DAY) * 1e18 * 20 / 60 / ONE_DAY;
421             }
422             if (time < 300 * ONE_DAY) {
423                 return 55e18 + (time - 180 * ONE_DAY) * 1e18 * 45 / 120 / ONE_DAY;
424             }
425             if (time >= 300 * ONE_DAY) {
426                 return 100e18 + (time - 300 * ONE_DAY) * 1e18 * 10 / 30 / ONE_DAY;
427             }
428         }
429     }
430 
431     function getDeposits(address addr) public view returns(uint256) {
432         uint256 sum;
433 
434         for (uint256 i = 0; i < users[addr].deposits.length; i++) {
435             sum += users[addr].deposits[i].amount;
436         }
437 
438         return sum;
439     }
440 
441     function getDeposit(address addr, uint256 index) public view returns(uint256) {
442         return users[addr].deposits[index].amount;
443     }
444 
445     function getProfit(address addr) public view returns(uint256) {
446         if (users[addr].deposits.length != 0) {
447             uint256 payout;
448             uint256 percent = getPercent();
449 
450             for (uint256 i = 0; i < users[addr].deposits.length; i++) {
451                 payout += (users[addr].deposits[i].amount * percent / 1e21) * (block.timestamp - users[addr].deposits[i].time) / ONE_DAY;
452             }
453 
454             return payout;
455         }
456     }
457 
458     function getRefBonus(address addr) public view returns(uint256) {
459         return users[addr].bonus;
460     }
461 
462     function getFinalWave() internal view returns(uint256) {
463         return maxBalance * ADMIN_FEE / ONE_HUNDRED;
464     }
465 
466 }