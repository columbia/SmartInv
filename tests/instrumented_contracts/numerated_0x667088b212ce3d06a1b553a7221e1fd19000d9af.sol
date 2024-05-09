1 contract Ownable {
2   address public owner;
3 
4   function Ownable() {
5     owner = msg.sender;
6   }
7 
8   modifier onlyOwner() {
9     if (msg.sender == owner)
10       _;
11   }
12 
13   function transferOwner(address newOwner) onlyOwner {
14     if (newOwner != address(0)) owner = newOwner;
15   }
16 
17 }
18 
19 contract ERC20 {
20   uint public totalSupply;
21   function balanceOf(address who) constant returns (uint);
22   function allowance(address owner, address spender) constant returns (uint);
23 
24   function transfer(address to, uint value) returns (bool ok);
25   function transferFrom(address from, address to, uint value) returns (bool ok);
26   function approve(address spender, uint value) returns (bool ok);
27   event Transfer(address indexed from, address indexed to, uint value);
28   event Approval(address indexed owner, address indexed spender, uint value);
29 }
30 
31 contract SafeMath {
32   function safeMul(uint a, uint b) internal returns (uint) {
33     uint c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function assert(bool assertion) internal {
50     if (!assertion) throw;
51   }
52 }
53 
54 contract StandardToken is ERC20, SafeMath {
55 
56   mapping(address => uint) balances;
57   mapping (address => mapping (address => uint)) allowed;
58 
59   function transfer(address _to, uint _value) returns (bool success) {
60     balances[msg.sender] = safeSub(balances[msg.sender], _value);
61     balances[_to] = safeAdd(balances[_to], _value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
67     var _allowance = allowed[_from][msg.sender];
68     
69     balances[_to] = safeAdd(balances[_to], _value);
70     balances[_from] = safeSub(balances[_from], _value);
71     allowed[_from][msg.sender] = safeSub(_allowance, _value);
72     Transfer(_from, _to, _value);
73     return true;
74   }
75 
76   function balanceOf(address _owner) constant returns (uint balance) {
77     return balances[_owner];
78   }
79 
80   function approve(address _spender, uint _value) returns (bool success) {
81     allowed[msg.sender][_spender] = _value;
82     Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) constant returns (uint remaining) {
87     return allowed[_owner][_spender];
88   }
89 
90 }
91 
92 /*
93   Wings ERC20 Token.
94   Added allocation for users who participiated in Wings Campaign.
95 
96   Important!
97   We have to run pre-mine allocation first.
98   And only then rest of users.
99   Or it's not going to work due to whenAllocation logic.
100 */
101 contract Token is StandardToken, Ownable {
102   // Account allocation event
103   event ALLOCATION(address indexed account, uint amount);
104 
105   /*
106     Premine events
107   */
108   event PREMINER_ADDED(address indexed owner, address account, uint amount);
109   event PREMINE_ALLOCATION_ADDED(address indexed account, uint time);
110   event PREMINE_RELEASE(address indexed account, uint timestamp, uint amount);
111   event PREMINER_CHANGED(address indexed oldPreminer, address newPreminer, address newRecipient);
112 
113   /*
114     Premine structure
115   */
116   struct Preminer {
117     address account;
118     uint monthlyPayment;
119     uint latestAllocation;
120     bool disabled;
121 
122     uint allocationsCount;
123     mapping(uint => uint) allocations;
124   }
125 
126   /*
127     List of preminers
128   */
129   mapping(address => Preminer) preminers;
130 
131   /*
132     Token Name & Token Symbol & Decimals
133   */
134   string public name = "WINGS";
135   string public symbol = "WINGS";
136   uint public decimals = 18;
137 
138   /*
139     Total supply
140   */
141   uint public totalSupply = 10**26;//100000000000000000000000000;
142 
143   /*
144     Premine allocation interval
145   */
146   uint public DAYS_28 = 2419200;
147   uint public DAYS_31 = 2678400;
148 
149   /*
150     Maximum premine allocations count
151   */
152   uint public MAX_ALLOCATIONS_COUNT = 26;
153 
154   /*
155     How many accounts allocated?
156   */
157   uint public accountsToAllocate;
158 
159   /*
160     Multisignature
161   */
162   address public multisignature;
163 
164   /*
165     Only multisignature
166   */
167   modifier onlyMultisignature() {
168     if (msg.sender != multisignature) {
169       throw;
170     }
171 
172     _;
173   }
174 
175   /*
176     When preminer is not disabled
177   */
178   modifier whenPreminerIsntDisabled(address _account) {
179     if (preminers[_account].disabled == true) {
180       throw;
181     }
182 
183     _;
184   }
185 
186   /*
187     Modifier for checking is allocation completed.
188     Maybe we should add here pre-mine accounts too.
189   */
190   modifier whenAllocation(bool value) {
191     if ((accountsToAllocate > 0) == value) {
192       _;
193     } else {
194       throw;
195     }
196   }
197 
198   /*
199     Check if user already allocated
200   */
201   modifier whenAccountHasntAllocated(address user) {
202     if (balances[user] == 0) {
203       _;
204     } else {
205       throw;
206     }
207   }
208 
209   /*
210     Check if preminer already added
211   */
212   modifier whenPremineHasntAllocated(address preminer) {
213     if (preminers[preminer].account == address(0)) {
214       _;
215     } else {
216       throw;
217     }
218   }
219 
220   function Token(uint _accountsToAllocate, address _multisignature) {
221     /*
222       Maybe we should calculate it in allocation and pre-mine.
223       I mean total supply
224     */
225     owner = msg.sender;
226     accountsToAllocate = _accountsToAllocate;
227     multisignature = _multisignature;
228   }
229 
230   /*
231     Allocate tokens for users.
232     Only owner and only while allocation active.
233 
234     Should check if user allocated already (no double allocations)
235   */
236   function allocate(address user, uint balance) onlyOwner() whenAllocation(true) whenAccountHasntAllocated(user) {
237     balances[user] = balance;
238 
239     accountsToAllocate--;
240     ALLOCATION(user, balance);
241   }
242 
243   /*
244     Standard Token functional
245   */
246   function transfer(address _to, uint _value) whenAllocation(false) returns (bool success) {
247     return super.transfer(_to, _value);
248   }
249 
250   function transferFrom(address _from, address _to, uint _value) whenAllocation(false) returns (bool success) {
251     return super.transferFrom(_from, _to, _value);
252   }
253 
254   function approve(address _spender, uint _value) whenAllocation(false) returns (bool success) {
255     return super.approve(_spender, _value);
256   }
257 
258   /*
259     Premine functionality
260   */
261 
262   /*
263     Add pre-mine account
264   */
265   function addPreminer(address preminer, address recipient, uint initialBalance, uint monthlyPayment) onlyOwner() whenAllocation(true) whenPremineHasntAllocated(preminer) {
266     var premine = Preminer(
267         recipient,
268         monthlyPayment,
269         0,
270         false,
271         0
272       );
273 
274 
275     balances[recipient] = safeAdd(balances[recipient], initialBalance);
276     preminers[preminer] = premine;
277     accountsToAllocate--;
278     PREMINER_ADDED(preminer, premine.account, initialBalance);
279   }
280 
281   /*
282     Disable pre-miner
283   */
284   function disablePreminer(address _preminer, address _newPreminer, address _newRecipient) onlyMultisignature() whenPreminerIsntDisabled(_preminer) {
285     var oldPreminer = preminers[_preminer];
286 
287     if (oldPreminer.account == address(0) || preminers[_newPreminer].account != address(0)) {
288       throw;
289     }
290 
291     preminers[_newPreminer] = oldPreminer;
292     preminers[_newPreminer].account = _newRecipient;
293     oldPreminer.disabled = true;
294 
295     if(preminers[_newPreminer].disabled == true) {
296       throw;
297     }
298 
299     for (uint i = 0; i < preminers[_newPreminer].allocationsCount; i++) {
300       preminers[_newPreminer].allocations[i] = oldPreminer.allocations[i];
301     }
302 
303     PREMINER_CHANGED(_preminer, _newPreminer, _newRecipient);
304   }
305 
306   /*
307     Add pre-mine allocation
308   */
309   function addPremineAllocation(address _preminer, uint _time) onlyOwner() whenAllocation(true) whenPreminerIsntDisabled(_preminer) {
310     var preminer = preminers[_preminer];
311 
312     if (preminer.account == address(0) ||  _time == 0 || preminer.allocationsCount == MAX_ALLOCATIONS_COUNT) {
313       throw;
314     }
315 
316     if (preminer.allocationsCount > 0) {
317       var previousAllocation = preminer.allocations[preminer.allocationsCount-1];
318 
319       if (previousAllocation > _time) {
320         throw;
321       }
322 
323       if (previousAllocation + DAYS_28 > _time) {
324         throw;
325       }
326 
327       if (previousAllocation + DAYS_31 < _time) {
328         throw;
329       }
330     }
331 
332     preminer.allocations[preminer.allocationsCount++] = _time;
333     PREMINE_ALLOCATION_ADDED(_preminer, _time);
334   }
335 
336   /*
337     Get preminer
338   */
339   function getPreminer(address _preminer) constant returns (address, bool, uint, uint, uint) {
340     var preminer = preminers[_preminer];
341 
342     return (preminer.account, preminer.disabled, preminer.monthlyPayment, preminer.latestAllocation, preminer.allocationsCount);
343   }
344 
345   /*
346     Get preminer allocation time by index
347   */
348   function getPreminerAllocation(address _preminer, uint _index) constant returns (uint) {
349     return preminers[_preminer].allocations[_index];
350   }
351 
352   /*
353     Release premine when preminer asking
354     Gas usage: 0x5786 or 22406 GAS.
355     Maximum is 26 months of pre-mine in case of Wings. So should be enough to execute it.
356   */
357   function releasePremine() whenAllocation(false) whenPreminerIsntDisabled(msg.sender) {
358     var preminer = preminers[msg.sender];
359 
360     if (preminer.account == address(0)) {
361       throw;
362     }
363 
364     for (uint i = preminer.latestAllocation; i < preminer.allocationsCount; i++) {
365       if (preminer.allocations[i] < block.timestamp) {
366         if (preminer.allocations[i] == 0) {
367           continue;
368         }
369 
370         balances[preminer.account] = safeAdd(balances[preminer.account], preminer.monthlyPayment);
371         preminer.latestAllocation = i;
372 
373         PREMINE_RELEASE(preminer.account, preminer.allocations[i], preminer.monthlyPayment);
374         preminer.allocations[i] = 0;
375       } else {
376         break;
377       }
378     }
379   }
380 }