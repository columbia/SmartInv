1 pragma solidity ^0.4.17;
2 
3 
4 // ----------------------------------------------------------------------------
5 // 'KWHToken' contract
6 //
7 // Symbol      : KWHT
8 // Name        : KWHToken
9 // Total supply: 900,000.000000000000000000
10 // Decimals    : 18
11 //
12 // The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // Overflow math functions.
17 
18 contract SafeMath {
19 
20     function safeAdd(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24 
25     function safeSub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29 
30     function safeMul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34 
35     function safeDiv(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 
40     function assert(bool assertion) internal {
41         require(assertion);
42     }
43 
44 }
45 
46 
47 // Contract Owned
48 
49 contract Owned {
50 
51     address public owner;
52 
53     function Owned() {
54 
55         owner = msg.sender;
56 
57     }
58 
59     modifier onlyOwner {
60 
61         require(msg.sender == owner);
62         _;
63 
64     }
65 
66     function transferOwnership(address newOwner) onlyOwner {
67 
68         require(newOwner != 0x0);
69         
70         owner = newOwner;
71 
72     }
73 
74 }
75 
76 
77 // Contract Token
78 
79 contract Token {
80 
81     uint256 public totalSupply;
82 
83     function balanceOf(address _owner) constant returns (uint256 balance);
84 
85     function transfer(address _to, uint256 _value) returns (bool success);
86 
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
88 
89     function approve(address _spender, uint256 _value) returns (bool success);
90 
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94 
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97 }
98 
99 
100 // StandardToken
101 
102 contract StandardToken is Token {
103 
104     function transfer(address _to, uint256 _value) returns (bool success) {
105 
106         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
107 
108             balances[msg.sender] -= _value;
109             
110             balances[_to] += _value;
111             
112             Transfer(msg.sender, _to, _value);
113             
114             return true;
115 
116         } else {
117             
118             return false;
119             
120         }
121     }
122 
123     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
124 
125         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
126 
127             balances[_from] -= _value;
128             
129             balances[_to] += _value;
130             
131             allowed[_from][msg.sender] -= _value;
132             
133             Transfer(_from, _to, _value);
134             
135             return true;
136 
137         } else {
138             
139             return false;
140             
141         }
142     }
143 
144     function balanceOf(address _owner) constant returns (uint256 balance) {
145 
146         return balances[_owner];
147 
148     }
149 
150     function approve(address _spender, uint256 _value) returns (bool success) {
151 
152         allowed[msg.sender][_spender] = _value;
153         
154         Approval(msg.sender, _spender, _value);
155         
156         return true;
157 
158     }
159 
160     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
161 
162       return allowed[_owner][_spender];
163 
164     }
165 
166     mapping (address => uint256) balances;
167 
168     mapping (address => mapping (address => uint256)) allowed;
169 
170 }
171 
172 
173 
174 // 'KWHToken' contract
175 
176 contract KWHToken is SafeMath, Owned, StandardToken {
177 
178     string public symbol = "KWHT";
179     
180     string public name = "KWHToken";
181 
182     address public KWHTokenAddress = this;
183     
184     uint8 public decimals = 18;
185     
186     uint256 public totalSupply;
187     
188     uint256 public buyPriceEth = 5 finney;
189     
190     uint256 public sellPriceEth = 5 finney;
191     
192     uint256 public gasForKWH = 3 finney;
193     
194     uint256 public KWHForGas = 10;
195     
196     uint256 public gasReserve = 1 ether;
197     
198     uint256 public minBalanceForAccounts = 20 finney;
199     
200     bool public directTradeAllowed = false;
201 
202 
203     function KWHToken() {
204         
205         totalSupply = 900000 * 10**uint(decimals);
206         
207         balances[msg.sender] = totalSupply;
208         
209     }
210 
211     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner {
212         
213         buyPriceEth = newBuyPriceEth;
214         
215         sellPriceEth = newSellPriceEth;
216         
217     }
218     
219     function setGasForKWH(uint newGasAmountInWei) onlyOwner {
220         
221         gasForKWH = newGasAmountInWei;
222         
223     }
224     
225     function setKWHForGas(uint newDCNAmount) onlyOwner {
226         
227         KWHForGas = newDCNAmount;
228         
229     }
230     
231     function setGasReserve(uint newGasReserveInWei) onlyOwner {
232         
233         gasReserve = newGasReserveInWei;
234     
235     }
236     
237     function setMinBalance(uint minimumBalanceInWei) onlyOwner {
238         
239         minBalanceForAccounts = minimumBalanceInWei;
240         
241     }
242 
243 
244 // Halts or unhalts direct trades without the sell and buy functions below
245     function haltDirectTrade() onlyOwner {
246         
247         directTradeAllowed = false;
248         
249     }
250     
251     function unhaltDirectTrade() onlyOwner {
252         
253         directTradeAllowed = true;
254         
255     }
256 
257     function transfer(address _to, uint256 _value) returns (bool success) {
258         
259         require(_value > KWHForGas);
260         
261         if (msg.sender != owner && _to == KWHTokenAddress && directTradeAllowed) {
262             
263             sellKWHAgainstEther(_value);
264             
265             return true;
266             
267         }
268 
269         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
270             
271             balances[msg.sender] = safeSub(balances[msg.sender], _value);
272 
273             if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {
274                 
275                 balances[_to] = safeAdd(balances[_to], _value);
276                 
277                 Transfer(msg.sender, _to, _value);
278                 
279                 return true;
280                 
281             } else {
282                 
283                 balances[this] = safeAdd(balances[this], KWHForGas);
284                 
285                 balances[_to] = safeAdd(balances[_to], safeSub(_value, KWHForGas));
286                 
287                 Transfer(msg.sender, _to, safeSub(_value, KWHForGas));
288 
289                 if(msg.sender.balance < minBalanceForAccounts) {
290                     
291                     require(msg.sender.send(gasForKWH));
292                     
293                 }
294                 
295                 if(_to.balance < minBalanceForAccounts) {
296                     
297                     require(_to.send(gasForKWH));
298                 
299                 }
300             }
301         } else { 
302             throw; 
303         }
304     }
305 
306 // User buys KWHs and pays in Ether
307     function buyKWHAgainstEther() payable returns (uint amount) {
308         
309         require(!(buyPriceEth == 0 || msg.value < buyPriceEth));
310         
311         amount = msg.value / buyPriceEth;
312         
313         require(!(balances[this] < amount));
314         
315         balances[msg.sender] = safeAdd(balances[msg.sender], amount);
316         
317         balances[this] = safeSub(balances[this], amount);
318         
319         Transfer(this, msg.sender, amount);
320         
321         return amount;
322     }
323 
324 
325 // User sells KWHs and gets Ether
326     function sellKWHAgainstEther(uint256 amount) returns (uint revenue) {
327         
328         require(!(sellPriceEth == 0 || amount < KWHForGas));
329         
330         require(!(balances[msg.sender] < amount));
331         
332         revenue = safeMul(amount, sellPriceEth);
333         
334         require(!(safeSub(this.balance, revenue) < gasReserve));
335         
336         if (!msg.sender.send(revenue)) {
337             
338             throw;
339             
340         } else {
341             
342             balances[this] = safeAdd(balances[this], amount);
343             
344             balances[msg.sender] = safeSub(balances[msg.sender], amount);
345             
346             Transfer(this, msg.sender, revenue);
347             
348             return revenue;
349         }
350     }
351 
352 
353 // Refunding owner
354     function refundToOwner (uint256 amountOfEth, uint256 kwh) onlyOwner {
355         
356         uint256 eth = safeMul(amountOfEth, 1 ether);
357         
358         if (!msg.sender.send(eth)) {
359             
360             throw;
361             
362         } else {
363             
364             Transfer(this, msg.sender, kwh);
365             
366         }
367         
368         require(!(balances[this] < kwh));
369         
370         balances[msg.sender] = safeAdd(balances[msg.sender], kwh);
371         
372         balances[this] = safeSub(balances[this], kwh);
373         
374         Transfer(this, msg.sender, kwh);
375     }
376 
377 
378     function() payable {
379         
380         if (msg.sender != owner) {
381             
382             require(directTradeAllowed);
383             
384             buyKWHAgainstEther();
385             
386         }
387     }
388 }