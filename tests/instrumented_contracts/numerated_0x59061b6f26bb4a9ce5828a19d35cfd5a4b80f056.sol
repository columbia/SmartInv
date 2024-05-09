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
61     string public name;
62     uint8 public decimals; 
63     string public symbol;     
64     string public version = '0.1';  
65     bool transfersOn = false;
66 
67 
68 
69     function Token(address _owner, string _tokenName, uint8 _decimals, string _symbol, address _ledger, address _rental) {
70         if (_owner == 0x0) throw;
71         owner = _owner;
72 
73         name = _tokenName;
74         decimals = _decimals;
75         symbol = _symbol;
76         ONE = 10**uint(decimals);
77         ledger = Ledger(_ledger);
78         rentalContract = Rental(_rental);
79     }
80 
81     /*
82     *	Bookkeeping and Admin Functions
83     */
84 
85     event LedgerUpdated(address,address);
86 
87     function changeClub(address _addr) onlyOwner {
88         if (_addr == 0x0) throw;
89 
90         club = _addr;
91     }
92 
93     function changePrice(uint _num) onlyOwner {
94         price = _num;
95     }
96 
97     function safeAdd(uint a, uint b) returns (uint) {
98         if ((a + b) < a) throw;
99         return (a + b);
100     }
101 
102     function changeLedger(address _addr) onlyOwner {
103         if (_addr == 0x0) throw;
104 
105         LedgerUpdated(msg.sender, _addr);
106         ledger = Ledger(_addr);
107     }
108 
109     function changeRental(address _addr) onlyOwner {
110         if (_addr == 0x0) throw;
111         rentalContract = Rental(_addr);
112     }
113 
114     function changeTimes(uint8 _rollOver, uint8 _start) onlyOwner {
115         rollOverTime = _rollOver;
116         startTime = _start;
117     }
118 
119     /*
120     * Locking is a feature that turns a user's balances into
121     * un-issued tokens, taking them out of an account and reducing the supply.
122     * Diluting is so named to remind the caller that they are changing the money supply.
123         */
124 
125     function lock(address _seizeAddr) onlyOwner mutexed {
126         uint myBalance = ledger.balanceOf(_seizeAddr);
127 
128         lockedSupply += myBalance;
129         ledger.setBalance(_seizeAddr, 0);
130     }
131 
132     event Dilution(address, uint);
133 
134     function dilute(address _destAddr, uint amount) onlyOwner {
135         if (amount > lockedSupply) throw;
136 
137         Dilution(_destAddr, amount);
138 
139         lockedSupply -= amount;
140 
141         uint curBalance = ledger.balanceOf(_destAddr);
142         curBalance = safeAdd(amount, curBalance);
143         ledger.setBalance(_destAddr, curBalance);
144     }
145 
146     /* 
147      * Crowdsale -- 
148      *
149      */
150     function completeCrowdsale() onlyOwner {
151         // Lock unsold tokens
152         // allow transfers for arbitrary owners
153         transfersOn = true;
154         lock(owner);
155     }
156 
157     function pauseTransfers() onlyOwner {
158         transfersOn = false;
159     }
160 
161     function resumeTransfers() onlyOwner {
162         transfersOn = true;
163     }
164 
165     /*
166     * Renting -- Logic TBD later. For now, we trust the rental contract
167     * to manage everything about the rentals, including bookkeeping on earnings
168     * and returning tokens.
169     */
170 
171     function rentOut(uint num) {
172         if (ledger.balanceOf(msg.sender) < num) throw;
173         rentalContract.offer(msg.sender, num);
174         ledger.tokenTransfer(msg.sender, rentalContract, num);
175     }
176 
177     function claimUnrented() {  
178         uint amount = rentalContract.claimBalance(msg.sender); // this should reduce sender's claimableBalance to 0
179 
180         ledger.tokenTransfer(rentalContract, msg.sender, amount);
181     }
182 
183     /*
184     * Burning -- We allow any user to burn tokens.
185     *
186      */
187 
188     function burn(uint _amount) {
189         uint balance = ledger.balanceOf(msg.sender);
190         if (_amount > balance) throw;
191 
192         ledger.setBalance(msg.sender, balance - _amount);
193     }
194 
195     /*
196     Entry
197     */
198     function checkIn(uint _numCheckins) returns(bool) {
199         int needed = int(price * ONE* _numCheckins);
200         if (int(ledger.balanceOf(msg.sender)) > needed) {
201             ledger.changeUsed(msg.sender, needed);
202             return true;
203         }
204         return false;
205     }
206 
207     // ERC20 Support. This could also use the fallback but
208     // I prefer the control for now.
209 
210     event Transfer(address, address, uint);
211     event Approval(address, address, uint);
212 
213     function totalSupply() constant returns(uint) {
214         return ledger.totalSupply();
215     }
216 
217     function transfer(address _to, uint _amount) returns(bool) {
218         if (!transfersOn && msg.sender != owner) return false;
219         if (! ledger.tokenTransfer(msg.sender, _to, _amount)) { return false; }
220 
221         Transfer(msg.sender, _to, _amount);
222         return true;
223     }
224 
225     function transferFrom(address _from, address _to, uint _amount) returns (bool) {
226         if (!transfersOn && msg.sender != owner) return false;
227         if (! ledger.tokenTransferFrom(msg.sender, _from, _to, _amount) ) { return false;}
228 
229         Transfer(msg.sender, _to, _amount);
230         return true;
231     }
232 
233     function allowance(address _from, address _to) constant returns(uint) {
234         return ledger.allowance(_from, _to); 
235     }
236 
237     function approve(address _spender, uint _value) returns (bool) {
238         if ( ledger.tokenApprove(msg.sender, _spender, _value) ) {
239             Approval(msg.sender, _spender, _value);
240             return true;
241         }
242         return false;
243     }
244 
245     function balanceOf(address _addr) constant returns(uint) {
246         return ledger.balanceOf(_addr);
247     }
248 }
249 
250 contract Ledger is Owned {
251     mapping (address => uint) balances;
252     mapping (address => uint) usedToday;
253 
254     mapping (address => bool) seenHere;
255     address[] public seenHereA;
256 
257     mapping (address => mapping (address => uint256)) allowed;
258     address token;
259     uint public totalSupply = 0;
260 
261     function Ledger(address _owner, uint _preMined, uint ONE) {
262         if (_owner == 0x0) throw;
263         owner = _owner;
264 
265         seenHere[_owner] = true;
266         seenHereA.push(_owner);
267 
268         totalSupply = _preMined *ONE;
269         balances[_owner] = totalSupply;
270     }
271 
272     modifier onlyToken {
273         if (msg.sender != token) throw;
274         _;
275     }
276 
277     modifier onlyTokenOrOwner {
278         if (msg.sender != token && msg.sender != owner) throw;
279         _;
280     }
281 
282 
283     function tokenTransfer(address _from, address _to, uint amount) onlyToken returns(bool) {
284         if (amount > balances[_from]) return false;
285         if ((balances[_to] + amount) < balances[_to]) return false;
286         if (amount == 0) { return false; }
287 
288         balances[_from] -= amount;
289         balances[_to] += amount;
290 
291         if (seenHere[_to] == false) {
292             seenHereA.push(_to);
293             seenHere[_to] = true;
294         }
295 
296         return true;
297     }
298 
299     function tokenTransferFrom(address _sender, address _from, address _to, uint amount) onlyToken returns(bool) {
300         if (allowed[_from][_sender] <= amount) return false;
301         if (amount > balanceOf(_from)) return false;
302         if (amount == 0) return false;
303 
304         if ((balances[_to] + amount) < amount) return false;
305 
306         balances[_from] -= amount;
307         balances[_to] += amount;
308         allowed[_from][_sender] -= amount;
309 
310         if (seenHere[_to] == false) {
311             seenHereA.push(_to);
312             seenHere[_to] = true;
313         }
314 
315         return true;
316     }
317 
318 
319     function changeUsed(address _addr, int amount) onlyToken {
320         int myToday = int(usedToday[_addr]) + amount;
321         usedToday[_addr] = uint(myToday);
322     }
323 
324     function resetUsedToday(uint8 startI, uint8 numTimes) onlyTokenOrOwner returns(uint8) {
325         uint8 numDeleted;
326         for (uint i = 0; i < numTimes && i + startI < seenHereA.length; i++) {
327             if (usedToday[seenHereA[i+startI]] != 0) { 
328                 delete usedToday[seenHereA[i+startI]];
329                 numDeleted++;
330             }
331         }
332         return numDeleted;
333     }
334 
335     function balanceOf(address _addr) constant returns (uint) {
336         // don't forget to subtract usedToday
337         if (usedToday[_addr] >= balances[_addr]) { return 0;}
338         return balances[_addr] - usedToday[_addr];
339     }
340 
341     event Approval(address, address, uint);
342 
343     function tokenApprove(address _from, address _spender, uint256 _value) onlyToken returns (bool) {
344         allowed[_from][_spender] = _value;
345         Approval(_from, _spender, _value);
346         return true;
347     }
348 
349     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
350         return allowed[_owner][_spender];
351     }
352 
353     function changeToken(address _token) onlyOwner {
354         token = Token(_token);
355     }
356 
357     function reduceTotalSupply(uint amount) onlyToken {
358         if (amount > totalSupply) throw;
359 
360         totalSupply -= amount;    
361     }
362 
363     function setBalance(address _addr, uint amount) onlyTokenOrOwner {
364         if (balances[_addr] == amount) { return; }
365         if (balances[_addr] < amount) {
366             // increasing totalSupply
367             uint increase = amount - balances[_addr];
368             totalSupply += increase;
369         } else {
370             // decreasing totalSupply
371             uint decrease = balances[_addr] - amount;
372             //TODO: safeSub
373             totalSupply -= decrease;
374         }
375         balances[_addr] = amount;
376     }
377 
378 }