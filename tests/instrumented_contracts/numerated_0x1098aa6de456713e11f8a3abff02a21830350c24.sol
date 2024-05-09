1 pragma solidity ^0.4.8;
2 
3 contract Owned {
4     address public owner;
5 
6     function changeOwner(address _addr) onlyOwner {
7         if (_addr == 0x0) throw;
8         owner = _addr;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) throw;
13         _;
14     }
15 }
16 
17 contract Mutex is Owned {
18     bool locked = false;
19     modifier mutexed {
20         if (locked) throw;
21         locked = true;
22         _;
23         locked = false;
24     }
25 
26     function unMutex() onlyOwner {
27         locked = false;
28     }
29 }
30 
31 
32 contract Rental is Owned {
33     function Rental(address _owner) {
34         if (_owner == 0x0) throw;
35         owner = _owner;
36     }
37 
38     function offer(address from, uint num) {
39 
40     }
41 
42     function claimBalance(address) returns(uint) {
43         return 0;
44     }
45 
46     function exec(address dest) onlyOwner {
47         if (!dest.call(msg.data)) throw;
48     }
49 }
50 
51 contract Token is Owned, Mutex {
52     uint ONE = 10**8;
53     uint price = 5000;
54     Ledger ledger;
55     Rental rentalContract;
56     uint8 rollOverTime = 4;
57     uint8 startTime = 8;
58     bool live = false;
59     address club;
60     uint lockedSupply = 0;
61     string public name = "Legends";
62     uint8 public decimals = 8;
63     string public symbol = "LGD";
64     string public version = '1.1';
65     bool transfersOn = false;
66 
67     modifier onlyInputWords(uint n) {
68         if (msg.data.length != (32 * n) + 4) throw;
69         _;
70     }
71 
72     function Token() {
73         owner = msg.sender;
74     }
75 
76     /*
77     *	Bookkeeping and Admin Functions
78     */
79 
80     event LedgerUpdated(address,address);
81 
82     function changeClub(address _addr) onlyOwner {
83         if (_addr == 0x0) throw;
84 
85         club = _addr;
86     }
87 
88     function changePrice(uint _num) onlyOwner {
89         price = _num;
90     }
91 
92     function safeAdd(uint a, uint b) returns (uint) {
93         if ((a + b) < a) throw;
94         return (a + b);
95     }
96 
97     function changeLedger(address _addr) onlyOwner {
98         if (_addr == 0x0) throw;
99 
100         LedgerUpdated(msg.sender, _addr);
101         ledger = Ledger(_addr);
102     }
103 
104     function changeRental(address _addr) onlyOwner {
105         if (_addr == 0x0) throw;
106         rentalContract = Rental(_addr);
107     }
108 
109     function changeTimes(uint8 _rollOver, uint8 _start) onlyOwner {
110         rollOverTime = _rollOver;
111         startTime = _start;
112     }
113 
114     /*
115     * Locking is a feature that turns a user's balances into
116     * un-issued tokens, taking them out of an account and reducing the supply.
117     * Diluting is so named to remind the caller that they are changing the money supply.
118         */
119 
120     function lock(address _seizeAddr) onlyOwner mutexed {
121         uint myBalance = ledger.balanceOf(_seizeAddr);
122 
123         lockedSupply += myBalance;
124         ledger.setBalance(_seizeAddr, 0);
125     }
126 
127     event Dilution(address, uint);
128 
129     function dilute(address _destAddr, uint amount) onlyOwner {
130         if (amount > lockedSupply) throw;
131 
132         Dilution(_destAddr, amount);
133 
134         lockedSupply -= amount;
135 
136         uint curBalance = ledger.balanceOf(_destAddr);
137         curBalance = safeAdd(amount, curBalance);
138         ledger.setBalance(_destAddr, curBalance);
139     }
140 
141     /*
142      * Crowdsale --
143      *
144      */
145     function completeCrowdsale() onlyOwner {
146         // Lock unsold tokens
147         // allow transfers for arbitrary owners
148         transfersOn = true;
149         lock(owner);
150     }
151 
152     function pauseTransfers() onlyOwner {
153         transfersOn = false;
154     }
155 
156     function resumeTransfers() onlyOwner {
157         transfersOn = true;
158     }
159 
160     /*
161     * Renting -- Logic TBD later. For now, we trust the rental contract
162     * to manage everything about the rentals, including bookkeeping on earnings
163     * and returning tokens.
164     */
165 
166     function rentOut(uint num) {
167         if (ledger.balanceOf(msg.sender) < num) throw;
168         rentalContract.offer(msg.sender, num);
169         ledger.tokenTransfer(msg.sender, rentalContract, num);
170     }
171 
172     function claimUnrented() {
173         uint amount = rentalContract.claimBalance(msg.sender); // this should reduce sender's claimableBalance to 0
174 
175         ledger.tokenTransfer(rentalContract, msg.sender, amount);
176     }
177 
178     /*
179     * Burning -- We allow any user to burn tokens.
180     *
181      */
182 
183     function burn(uint _amount) {
184         uint balance = ledger.balanceOf(msg.sender);
185         if (_amount > balance) throw;
186 
187         ledger.setBalance(msg.sender, balance - _amount);
188     }
189 
190     /*
191     Entry
192     */
193     function checkIn(uint _numCheckins) returns(bool) {
194         int needed = int(price * ONE* _numCheckins);
195         if (int(ledger.balanceOf(msg.sender)) > needed) {
196             ledger.changeUsed(msg.sender, needed);
197             return true;
198         }
199         return false;
200     }
201 
202     // ERC20 Support. This could also use the fallback but
203     // I prefer the control for now.
204 
205     event Transfer(address indexed _from, address indexed _to, uint _value);
206     event Approval(address indexed _owner, address indexed _spender, uint _value);
207 
208     function totalSupply() constant returns(uint) {
209         return ledger.totalSupply();
210     }
211 
212     function transfer(address _to, uint _amount) onlyInputWords(2) returns(bool) {
213         if (!transfersOn && msg.sender != owner) return false;
214         if (!ledger.tokenTransfer(msg.sender, _to, _amount)) { return false; }
215 
216         Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219 
220     function transferFrom(address _from, address _to, uint _amount) onlyInputWords(3) returns (bool) {
221         if (!transfersOn && msg.sender != owner) return false;
222         if (! ledger.tokenTransferFrom(msg.sender, _from, _to, _amount) ) { return false;}
223 
224         Transfer(msg.sender, _to, _amount);
225         return true;
226     }
227 
228     function allowance(address _from, address _to) constant returns(uint) {
229         return ledger.allowance(_from, _to);
230     }
231 
232     function approve(address _spender, uint _value) returns (bool) {
233         if ( ledger.tokenApprove(msg.sender, _spender, _value) ) {
234             Approval(msg.sender, _spender, _value);
235             return true;
236         }
237         return false;
238     }
239 
240     function balanceOf(address _addr) constant returns(uint) {
241         return ledger.balanceOf(_addr);
242     }
243 }
244 
245 contract Ledger is Owned {
246     uint ONE = 10**8;
247     uint preMined = 30000000;
248     mapping (address => uint) balances;
249     mapping (address => uint) usedToday;
250 
251     mapping (address => bool) seenHere;
252     address[] public seenHereA;
253 
254     mapping (address => mapping (address => uint256)) allowed;
255     address token;
256     uint public totalSupply = 0;
257 
258     function Ledger() {
259         owner = msg.sender;
260         seenHere[owner] = true;
261         seenHereA.push(owner);
262 
263         totalSupply = preMined *ONE;
264         balances[owner] = totalSupply;
265     }
266 
267     modifier onlyToken {
268         if (msg.sender != token) throw;
269         _;
270     }
271 
272     modifier onlyTokenOrOwner {
273         if (msg.sender != token && msg.sender != owner) throw;
274         _;
275     }
276 
277     function tokenTransfer(address _from, address _to, uint amount) onlyToken returns(bool) {
278         if (amount > balances[_from]) return false;
279         if ((balances[_to] + amount) < balances[_to]) return false;
280         if (amount == 0) { return false; }
281 
282         balances[_from] -= amount;
283         balances[_to] += amount;
284 
285         if (seenHere[_to] == false) {
286             seenHereA.push(_to);
287             seenHere[_to] = true;
288         }
289 
290         return true;
291     }
292 
293     function tokenTransferFrom(address _sender, address _from, address _to, uint amount) onlyToken returns(bool) {
294         if (allowed[_from][_sender] <= amount) return false;
295         if (amount > balanceOf(_from)) return false;
296         if (amount == 0) return false;
297 
298         if ((balances[_to] + amount) < amount) return false;
299 
300         balances[_from] -= amount;
301         balances[_to] += amount;
302         allowed[_from][_sender] -= amount;
303 
304         if (seenHere[_to] == false) {
305             seenHereA.push(_to);
306             seenHere[_to] = true;
307         }
308 
309         return true;
310     }
311 
312 
313     function changeUsed(address _addr, int amount) onlyToken {
314         int myToday = int(usedToday[_addr]) + amount;
315         usedToday[_addr] = uint(myToday);
316     }
317 
318     function resetUsedToday(uint8 startI, uint8 numTimes) onlyTokenOrOwner returns(uint8) {
319         uint8 numDeleted;
320         for (uint i = 0; i < numTimes && i + startI < seenHereA.length; i++) {
321             if (usedToday[seenHereA[i+startI]] != 0) {
322                 delete usedToday[seenHereA[i+startI]];
323                 numDeleted++;
324             }
325         }
326         return numDeleted;
327     }
328 
329     function balanceOf(address _addr) constant returns (uint) {
330         // don't forget to subtract usedToday
331         if (usedToday[_addr] >= balances[_addr]) { return 0;}
332         return balances[_addr] - usedToday[_addr];
333     }
334 
335     event Approval(address, address, uint);
336 
337     function tokenApprove(address _from, address _spender, uint256 _value) onlyToken returns (bool) {
338         allowed[_from][_spender] = _value;
339         Approval(_from, _spender, _value);
340         return true;
341     }
342 
343     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
344         return allowed[_owner][_spender];
345     }
346 
347     function changeToken(address _token) onlyOwner {
348         token = Token(_token);
349     }
350 
351     function reduceTotalSupply(uint amount) onlyToken {
352         if (amount > totalSupply) throw;
353 
354         totalSupply -= amount;
355     }
356 
357     function setBalance(address _addr, uint amount) onlyTokenOrOwner {
358         if (balances[_addr] == amount) { return; }
359         if (balances[_addr] < amount) {
360             // increasing totalSupply
361             uint increase = amount - balances[_addr];
362             totalSupply += increase;
363         } else {
364             // decreasing totalSupply
365             uint decrease = balances[_addr] - amount;
366             //TODO: safeSub
367             totalSupply -= decrease;
368         }
369         balances[_addr] = amount;
370     }
371 
372 }