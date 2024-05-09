1 pragma solidity ^0.4.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Owned {
34 
35     // The address of the account that is the current owner
36     address public owner;
37 
38     // The publiser is the inital owner
39     function Owned() {
40         owner = msg.sender;
41     }
42 
43     /**
44      * Restricted access to the current owner
45      */
46     modifier onlyOwner() {
47         if (msg.sender != owner) throw;
48         _;
49     }
50 
51     /**
52      * Transfer ownership to `_newOwner`
53      *
54      * @param _newOwner The address of the account that will become the new owner
55      */
56     function transferOwnership(address _newOwner) onlyOwner {
57         owner = _newOwner;
58     }
59 }
60 
61 // Abstract contract for the full ERC 20 Token standard
62 // https://github.com/ethereum/EIPs/issues/20
63 contract Token {
64     /* This is a slight change to the ERC20 base standard.
65     function totalSupply() constant returns (uint256 supply);
66     is replaced with:
67     uint256 public totalSupply;
68     This automatically creates a getter function for the totalSupply.
69     This is moved to the base contract since public getter functions are not
70     currently recognised as an implementation of the matching abstract
71     function by the compiler.
72     */
73     /// total amount of tokens
74     uint256 public totalSupply;
75 
76     /// @param _owner The address from which the balance will be retrieved
77     /// @return The balance
78     function balanceOf(address _owner) constant returns (uint256 balance);
79 
80     /// @notice send `_value` token to `_to` from `msg.sender`
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transfer(address _to, uint256 _value) returns (bool success);
85 
86     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
87     /// @param _from The address of the sender
88     /// @param _to The address of the recipient
89     /// @param _value The amount of token to be transferred
90     /// @return Whether the transfer was successful or not
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
92 
93     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
94     /// @param _spender The address of the account able to transfer the tokens
95     /// @param _value The amount of tokens to be approved for transfer
96     /// @return Whether the approval was successful or not
97     function approve(address _spender, uint256 _value) returns (bool success);
98 
99     /// @param _owner The address of the account owning tokens
100     /// @param _spender The address of the account able to transfer the tokens
101     /// @return Amount of remaining tokens allowed to spent
102     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
103 
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 }
107 
108 /**
109  * @title RICH token
110  *
111  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition
112  * of ownership, a lock and issuing.
113  *
114  * #created 05/03/2017
115  * #author Frank Bonnet
116  */
117 contract RICHToken is Owned, Token {
118 
119     using SafeMath for uint256;
120 
121     // Ethereum token standaard
122     string public standard = "Token 0.2";
123 
124     // Full name
125     string public name = "RICH token";
126 
127     // Symbol
128     string public symbol = "RCH";
129 
130     // No decimal points
131     uint8 public decimals = 8;
132 
133     // Token starts if the locked state restricting transfers
134     bool public locked;
135 
136     uint256 public crowdsaleStart; // Reference to time of first crowd sale
137     uint256 public icoPeriod = 10 days;
138     uint256 public noIcoPeriod = 10 days;
139     mapping (address => mapping (uint256 => uint256)) balancesPerIcoPeriod;
140 
141     uint256 public burnPercentageDefault = 1; // 0.01%
142     uint256 public burnPercentage10m = 5; // 0.05%
143     uint256 public burnPercentage100m = 50; // 0.5%
144     uint256 public burnPercentage1000m = 100; // 1%
145 
146     mapping (address => uint256) balances;
147     mapping (address => mapping (address => uint256)) allowed;
148 
149     /**
150      * Get burning line. All investors that own less than burning line
151      * will lose some tokens if they don't invest each round 20% more tokens
152      *
153      * @return burnLine
154      */
155     function getBurnLine() returns (uint256 burnLine) {
156         if (totalSupply < 10**7 * 10**8) {
157             return totalSupply * burnPercentageDefault / 10000;
158         }
159 
160         if (totalSupply < 10**8 * 10**8) {
161             return totalSupply * burnPercentage10m / 10000;
162         }
163 
164         if (totalSupply < 10**9 * 10**8) {
165             return totalSupply * burnPercentage100m / 10000;
166         }
167 
168         return totalSupply * burnPercentage1000m / 10000;
169     }
170 
171     /**
172      * Return ICO number (PreIco has index 0)
173      *
174      * @return ICO number
175      */
176     function getCurrentIcoNumber() returns (uint256 icoNumber) {
177         uint256 timeBehind = now - crowdsaleStart;
178 
179         if (now < crowdsaleStart) {
180             return 0;
181         }
182 
183         return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));
184     }
185 
186     /**
187      * Get balance of `_owner`
188      *
189      * @param _owner The address from which the balance will be retrieved
190      * @return The balance
191      */
192     function balanceOf(address _owner) constant returns (uint256 balance) {
193         return balances[_owner];
194     }
195 
196     /**
197      * Start of the crowd sale can be set only once
198      *
199      * @param _start start of the crowd sale
200      */
201     function setCrowdSaleStart(uint256 _start) onlyOwner {
202         if (crowdsaleStart > 0) {
203             return;
204         }
205 
206         crowdsaleStart = _start;
207     }
208 
209     /**
210      * Send `_value` token to `_to` from `msg.sender`
211      *
212      * @param _to The address of the recipient
213      * @param _value The amount of token to be transferred
214      * @return Whether the transfer was successful or not
215      */
216     function transfer(address _to, uint256 _value) returns (bool success) {
217 
218         // Unable to transfer while still locked
219         if (locked) {
220             throw;
221         }
222 
223         // Check if the sender has enough tokens
224         if (balances[msg.sender] < _value) {
225             throw;
226         }
227 
228         // Check for overflows
229         if (balances[_to] + _value < balances[_to])  {
230             throw;
231         }
232 
233         // Transfer tokens
234         balances[msg.sender] -= _value;
235         balances[_to] += _value;
236 
237         // Notify listners
238         Transfer(msg.sender, _to, _value);
239 
240         balancesPerIcoPeriod[_to][getCurrentIcoNumber()] = balances[_to];
241         balancesPerIcoPeriod[msg.sender][getCurrentIcoNumber()] = balances[msg.sender];
242         return true;
243     }
244 
245     /**
246      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
247      *
248      * @param _from The address of the sender
249      * @param _to The address of the recipient
250      * @param _value The amount of token to be transferred
251      * @return Whether the transfer was successful or not
252      */
253     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
254 
255          // Unable to transfer while still locked
256         if (locked) {
257             throw;
258         }
259 
260         // Check if the sender has enough
261         if (balances[_from] < _value) {
262             throw;
263         }
264 
265         // Check for overflows
266         if (balances[_to] + _value < balances[_to]) {
267             throw;
268         }
269 
270         // Check allowance
271         if (_value > allowed[_from][msg.sender]) {
272             throw;
273         }
274 
275         // Transfer tokens
276         balances[_to] += _value;
277         balances[_from] -= _value;
278 
279         // Update allowance
280         allowed[_from][msg.sender] -= _value;
281 
282         // Notify listners
283         Transfer(_from, _to, _value);
284 
285         balancesPerIcoPeriod[_to][getCurrentIcoNumber()] = balances[_to];
286         balancesPerIcoPeriod[_from][getCurrentIcoNumber()] = balances[_from];
287         return true;
288     }
289 
290     /**
291      * `msg.sender` approves `_spender` to spend `_value` tokens
292      *
293      * @param _spender The address of the account able to transfer the tokens
294      * @param _value The amount of tokens to be approved for transfer
295      * @return Whether the approval was successful or not
296      */
297     function approve(address _spender, uint256 _value) returns (bool success) {
298 
299         // Unable to approve while still locked
300         if (locked) {
301             throw;
302         }
303 
304         // Update allowance
305         allowed[msg.sender][_spender] = _value;
306 
307         // Notify listners
308         Approval(msg.sender, _spender, _value);
309         return true;
310     }
311 
312 
313     /**
314      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
315      *
316      * @param _owner The address of the account owning tokens
317      * @param _spender The address of the account able to transfer the tokens
318      * @return Amount of remaining tokens allowed to spent
319      */
320     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
321       return allowed[_owner][_spender];
322     }
323 
324     /**
325      * Starts with a total supply of zero and the creator starts with
326      * zero tokens (just like everyone else)
327      */
328     function RICHToken() {
329         balances[msg.sender] = 0;
330         totalSupply = 0;
331         locked = false;
332     }
333 
334 
335     /**
336      * Unlocks the token irreversibly so that the transfering of value is enabled
337      *
338      * @return Whether the unlocking was successful or not
339      */
340     function unlock() onlyOwner returns (bool success)  {
341         locked = false;
342         return true;
343     }
344 
345     /**
346      * Restricted access to the current owner
347      */
348     modifier onlyOwner() {
349         if (msg.sender != owner) throw;
350         _;
351     }
352 
353     /**
354      * Issues `_value` new tokens to `_recipient`
355      *
356      * @param _recipient The address to which the tokens will be issued
357      * @param _value The amount of new tokens to issue
358      * @return Whether the approval was successful or not
359      */
360     function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {
361 
362         // Create tokens
363         balances[_recipient] += _value;
364         totalSupply += _value;
365 
366         balancesPerIcoPeriod[_recipient][getCurrentIcoNumber()] = balances[_recipient];
367 
368         return true;
369     }
370 
371     /**
372      * Check if investor has invested enough to avoid burning
373      *
374      * @param _investor Investor
375      * @return Whether investor has invested enough or not
376      */
377     function isIncreasedEnough(address _investor) returns (bool success) {
378         uint256 currentIcoNumber = getCurrentIcoNumber();
379 
380         if (currentIcoNumber - 2 < 0) {
381             return true;
382         }
383 
384         uint256 currentBalance = balances[_investor];
385         uint256 icosBefore = balancesPerIcoPeriod[_investor][currentIcoNumber - 2];
386 
387         if (icosBefore == 0) {
388             for(uint i = currentIcoNumber; i >= 2; i--) {
389                 icosBefore = balancesPerIcoPeriod[_investor][i-2];
390 
391                 if (icosBefore != 0) {
392                     break;
393                 }
394             }
395         }
396 
397         if (currentBalance < icosBefore) {
398             return false;
399         }
400 
401         if (currentBalance - icosBefore > icosBefore * 12 / 10) {
402             return true;
403         }
404 
405         return false;
406     }
407 
408     /**
409      * Function that everyone can call and burn for other tokens if they can
410      * be burned. In return, 10% of burned tokens go to executor of function
411      *
412      * @param _investor Address of investor which tokens are subject of burn
413      */
414     function burn(address _investor) public {
415 
416         uint256 burnLine = getBurnLine();
417 
418         if (balances[_investor] > burnLine || isIncreasedEnough(_investor)) {
419             return;
420         }
421 
422         uint256 toBeBurned = burnLine - balances[_investor];
423         if (toBeBurned > balances[_investor]) {
424             toBeBurned = balances[_investor];
425         }
426 
427         // 10% for executor
428         uint256 executorReward = toBeBurned / 10;
429 
430         balances[msg.sender] = balances[msg.sender].add(executorReward);
431         balances[_investor] = balances[_investor].sub(toBeBurned);
432         totalSupply = totalSupply.sub(toBeBurned - executorReward);
433         Burn(_investor, toBeBurned);
434     }
435 
436     event Burn(address indexed burner, uint indexed value);
437 
438     /**
439      * Prevents accidental sending of ether
440      */
441     function () {
442         throw;
443     }
444 }