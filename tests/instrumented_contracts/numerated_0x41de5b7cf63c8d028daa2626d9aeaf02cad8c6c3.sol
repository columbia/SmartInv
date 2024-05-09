1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract DSMath {
21 
22     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         assert((z = x + y) >= x);
24     }
25 
26     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         assert((z = x - y) <= x);
28     }
29 
30     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
31         assert((z = x * y) >= x);
32     }
33 
34     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
35         z = x / y;
36     }
37 
38     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         return x <= y ? x : y;
40     }
41 
42     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
43         return x >= y ? x : y;
44     }
45 }
46 
47 
48 contract queue {
49     Queue public q;
50 
51     struct BuyTicket {
52         address account;
53         uint amount;
54         uint time;
55     }
56 
57     struct Queue {
58         BuyTicket[] data;
59         uint front;
60         uint back;
61     }
62 
63     function queueSize() constant returns (uint r) {
64         r = q.back - q.front;
65     }
66 
67     function queue() {
68         q.data.length = 600000;
69     }
70 
71     function pushQueue(BuyTicket ticket) internal {
72         require((q.back + 1) % q.data.length != q.front);
73 
74         q.data[q.back] = ticket;
75         q.back = (q.back + 1) % q.data.length;
76     }
77 
78     function peekQueue() internal returns (BuyTicket r) {
79         require(q.back != q.front);
80 
81         r = q.data[q.front];
82     }
83 
84     function popQueue() internal {
85         require(q.back != q.front);
86 
87         delete q.data[q.front];
88         q.front = (q.front + 1) % q.data.length;
89     }
90 }
91 
92 contract DeCenterToken is owned, queue, DSMath {
93     string public standard = 'Token 0.1';
94     string public name = 'DeCenter';
95     string public symbol = 'DC';
96     uint8 public decimals = 8;
97 
98     uint256 public totalSupply = 10000000000000000; // 100 million
99     uint256 public availableTokens = 6000000000000000; // 60 million
100     uint256 public teamAndExpertsTokens = 4000000000000000; // 40 million
101     uint256 public price = 0.0000000001 ether; // 0.01 ether per token
102 
103     uint public startTime;
104     uint public refundStartTime;
105     uint public refundDuration = 3 days; // 3 years
106     uint public firstStageDuration = 3 days; // 31 days
107     uint public lastScheduledTopUp;
108     uint public lastProcessedDay = 3;
109 
110     uint public maxDailyCap = 3333300000000; // 33 333 DC
111     mapping (uint => uint) public dailyTotals;
112 
113     uint public queuedAmount;
114 
115     address public beneficiary;
116     address public expertsAccount;
117     address public teamAccount;
118 
119     mapping (address => uint256) public balanceOf;
120 
121     mapping (address => mapping (address => uint256)) public allowance;
122 
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     // for testing
126     uint public cTime = 0;
127     function setCTime(uint _cTime) onlyOwner {
128         cTime = _cTime;
129     }
130 
131     function DeCenterToken(
132     address _beneficiary,
133     address _expertsAccount,
134     address _teamAccount,
135     uint _startTime,
136     uint _refundStartTime
137     ) {
138         beneficiary = _beneficiary;
139         expertsAccount = _expertsAccount;
140         teamAccount = _teamAccount;
141 
142         startTime = _startTime;
143         refundStartTime = _refundStartTime;
144 
145         balanceOf[this] = totalSupply;
146 
147         scheduledTopUp();
148     }
149 
150     function time() constant returns (uint) {
151         // for testing
152         if(cTime > 0) {
153             return cTime;
154         }
155 
156         return block.timestamp;
157     }
158 
159     function today() constant returns (uint) {
160         return dayFor(time());
161     }
162 
163     function dayFor(uint timestamp) constant returns (uint) {
164         return sub(timestamp, startTime) / 24 hours;
165     }
166 
167     function lowerLimitForToday() constant returns (uint) {
168         return today() * 1 ether;
169     }
170 
171     function scheduledTopUp() onlyOwner {
172         uint payment = 400000000000000; // 4 million tokens
173 
174         require(sub(time(), lastScheduledTopUp) >= 1 years);
175         require(teamAndExpertsTokens >= payment * 2);
176 
177         lastScheduledTopUp = time();
178 
179         teamAndExpertsTokens -= payment;
180         balanceOf[this] = sub(balanceOf[this], payment);
181         balanceOf[expertsAccount] = add(balanceOf[expertsAccount], payment);
182 
183         teamAndExpertsTokens -= payment;
184         balanceOf[this] = sub(balanceOf[this], payment);
185         balanceOf[teamAccount] = add(balanceOf[teamAccount], payment);
186 
187         Transfer(this, expertsAccount, payment); // execute an event reflecting the change
188         Transfer(this, teamAccount, payment); // execute an event reflecting the change
189     }
190 
191     /* Allow another contract to spend some tokens in your behalf */
192     function approve(address _spender, uint256 _value) returns (bool success) {
193         allowance[msg.sender][_spender] = _value;
194 
195         return true;
196     }
197 
198     function refund(uint256 _value) internal {
199         require(time() > refundStartTime);
200         require(this.balance >= _value * price);
201 
202         balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
203         balanceOf[this] = add(balanceOf[this], _value);
204         availableTokens = add(availableTokens, _value);
205 
206         msg.sender.transfer(_value * price);
207 
208         Transfer(msg.sender, this, _value); // Notify anyone listening that this transfer took place
209     }
210 
211     /* Send tokens */
212     function transfer(address _to, uint256 _value) {
213         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
214 
215         if (_to == address(this)) {
216             refund(_value);
217             return;
218         }
219 
220         balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
221         balanceOf[_to] = add(balanceOf[_to], _value);
222 
223         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
224     }
225 
226     /* A contract attempts to get the tokens */
227     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
228         require(balanceOf[_from] >= _value); // Check if the sender has enough
229         require(_value <= allowance[_from][msg.sender]); // Check allowance
230 
231         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value); //  Subtract from the allowance
232         balanceOf[_from] = sub(balanceOf[_from], _value); // Subtract from the sender
233         balanceOf[_to] = add(balanceOf[_to], _value); // Add the same to the recipient
234 
235         Transfer(_from, _to, _value);
236 
237         return true;
238     }
239 
240     function closeRefund() onlyOwner {
241         require(time() - refundStartTime > refundDuration);
242 
243         beneficiary.transfer(this.balance);
244     }
245 
246     /*
247      *    Token purchasing has 2 stages:
248      *       - First stage holds 31 days. There is no limit of buying.
249      *       - Second stage holds ~5 years after. There will be limit of 333.33 ether per day.
250      */
251     function buy() payable {
252         require(startTime <= time()); // check if ICO is going
253 
254         uint amount = div(msg.value, price);
255 
256         if (time() - startTime > firstStageDuration) { // second stage
257             require(1 ether <= msg.value); // check min. limit
258             require(msg.value <= 300 ether); // check max. limit
259 
260             // send 80% to beneficiary account, another 20% stays for refunding
261             beneficiary.transfer(mul(div(msg.value, 5), 4));
262 
263             uint currentDay = lastProcessedDay + 1;
264             uint limit = maxDailyCap - dailyTotals[currentDay];
265 
266             if (limit >= amount) {
267                 availableTokens = sub(availableTokens, amount);
268                 balanceOf[this] = sub(balanceOf[this], amount); // subtracts amount from seller's balance
269                 dailyTotals[currentDay] = add(dailyTotals[currentDay], amount);
270                 balanceOf[msg.sender] = add(balanceOf[msg.sender], amount); // adds the amount to buyer's balance
271 
272                 Transfer(this, msg.sender, amount); // execute an event reflecting the change
273             } else {
274                 queuedAmount = add(queuedAmount, amount);
275                 require(queuedAmount <= availableTokens);
276                 BuyTicket memory ticket = BuyTicket({account: msg.sender, amount: amount, time: time()});
277                 pushQueue(ticket);
278             }
279 
280         } else { // first stage
281             require(lowerLimitForToday() <= msg.value); // check min. limit
282             require(amount <= availableTokens);
283 
284             // send 80% to beneficiary account, another 20% stays for refunding
285             beneficiary.transfer(mul(div(msg.value, 5), 4));
286 
287             availableTokens = sub(availableTokens, amount);
288             balanceOf[this] = sub(balanceOf[this], amount); // subtracts amount from seller's balance
289             balanceOf[msg.sender] = add(balanceOf[msg.sender], amount); // adds the amount to buyer's balance
290 
291             Transfer(this, msg.sender, amount); // execute an event reflecting the change
292         }
293     }
294 
295     function processPendingTickets() onlyOwner {
296 
297         uint size = queueSize();
298         uint ptr = 0;
299         uint currentDay;
300         uint limit;
301         BuyTicket memory ticket;
302 
303         while (ptr < size) {
304             currentDay = lastProcessedDay + 1;
305             limit = maxDailyCap - dailyTotals[currentDay];
306 
307             // stop then trying to process future
308             if (startTime + (currentDay - 1) * 1 days > time()) {
309                 return;
310             }
311 
312             // limit to prevent out of gas error
313             if (ptr > 50) {
314                 return;
315             }
316 
317             ticket = peekQueue();
318 
319             if (limit < ticket.amount || ticket.time - 1000 seconds > startTime + (currentDay - 1) * 1 days) {
320                 lastProcessedDay += 1;
321                 continue;
322             }
323 
324             popQueue();
325             ptr += 1;
326 
327             availableTokens = sub(availableTokens, ticket.amount);
328             queuedAmount = sub(queuedAmount, ticket.amount);
329             dailyTotals[currentDay] = add(dailyTotals[currentDay], ticket.amount);
330             balanceOf[this] = sub(balanceOf[this], ticket.amount);
331             balanceOf[ticket.account] = add(balanceOf[ticket.account], ticket.amount); // adds the amount to buyer's balance
332 
333             Transfer(this, ticket.account, ticket.amount); // execute an event reflecting the change
334         }
335     }
336 
337     function() payable {
338         buy();
339     }
340 }