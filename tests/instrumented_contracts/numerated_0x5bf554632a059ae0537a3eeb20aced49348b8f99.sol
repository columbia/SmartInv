1 /*
2 * This is the source code of the smart contract for the SOUL token, aka Soul Napkins.
3 * Copyright 2017 and all rights reserved by the owner of the following Ethereum address:
4 * 0x10E44C6bc685c4E4eABda326c211561d5367EEec
5 */
6 
7 pragma solidity ^0.4.17;
8 
9 // ERC Token standard #20 Interface
10 // https://github.com/ethereum/EIPs/issues/20
11 contract ERC20Interface {
12 
13     // Token symbol
14     string public constant symbol = "TBA";
15 
16     // Name of token
17     string public constant name ="TBA";
18 
19     // Decimals of token
20     uint8 public constant decimals = 18;
21 
22     // Total token supply
23     function totalSupply() public constant returns (uint256 supply);
24 
25     // The balance of account with address _owner
26     function balanceOf(address _owner) public constant returns (uint256 balance);
27 
28     // Send _value tokens to address _to
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     // Send _value tokens from address _from to address _to
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
35     // If this function is called again it overwrites the current allowance with _value.
36     // this function is required for some DEX functionality
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     // Returns the amount which _spender is still allowed to withdraw from _owner
40     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
41 
42     // Triggered when tokens are transferred.
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44 
45     // Triggered whenever approve(address _spender, uint256 _value) is called.
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 
50 // Implementation of ERC20Interface
51 contract ERC20Token is ERC20Interface{
52 
53     // account balances
54     mapping(address => uint256) balances;
55 
56     // Owner of account approves the transfer of amount to another account
57     mapping(address => mapping (address => uint256)) allowed;
58 
59     // Function to access acount balances
60     function balanceOf(address _owner) public constant returns (uint256) {
61         return balances[_owner];
62     }
63 
64     // Transfer the _amount from msg.sender to _to account
65     function transfer(address _to, uint256 _amount) public returns (bool) {
66         if (balances[msg.sender] >= _amount && _amount > 0
67                 && balances[_to] + _amount > balances[_to]) {
68             balances[msg.sender] -= _amount;
69             balances[_to] += _amount;
70             Transfer(msg.sender, _to, _amount);
71             return true;
72         } else {
73             return false;
74         }
75     }
76 
77     // Send _value amount of tokens from address _from to address _to
78     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
79     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
80     // fees in sub-currencies; the command should fail unless the _from account has
81     // deliberately authorized the sender of the message via some mechanism; we propose
82     // these standardized APIs for approval:
83     function transferFrom(
84         address _from,
85         address _to,
86         uint256 _amount
87     ) public returns (bool) {
88         if (balances[_from] >= _amount
89             && allowed[_from][msg.sender] >= _amount && _amount > 0
90                 && balances[_to] + _amount > balances[_to]) {
91             balances[_from] -= _amount;
92             allowed[_from][msg.sender] -= _amount;
93             balances[_to] += _amount;
94             Transfer(_from, _to, _amount);
95             return true;
96         } else {
97             return false;
98         }
99     }
100 
101     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
102     // If this function is called again it overwrites the current allowance with _value.
103     function approve(address _spender, uint256 _amount) public returns (bool) {
104         allowed[msg.sender][_spender] = _amount;
105         Approval(msg.sender, _spender, _amount);
106         return true;
107     }
108 
109     // Function to specify how much _spender is allowed to transfer on _owner's behalf
110     function allowance(address _owner, address _spender) public constant returns (uint256) {
111         return allowed[_owner][_spender];
112     }
113 
114 }
115 
116 
117 // Token implementation that allows selling of souls and distribution of napkins
118 contract SoulToken is ERC20Token{
119 
120     // The three letter symbol of token
121     string public constant symbol = "SOUL";
122 
123     // Name of token
124     string public constant name = "Soul Napkins";
125 
126     // 6 is a holy number (2*3) so there are 6 decimals
127     uint8 public constant decimals = 6;
128 
129     // With 6 decimals, a single unit is 10**6
130     uint256 public constant unit = 1000000;
131 
132     // fee to pay to transfer soul, 10% like the ecclesiastical tithe
133     uint8 public constant obol = 10;
134 
135     // price per token, 100 napkins per Ether
136     uint256 public constant napkinPrice = 10 finney / unit;
137 
138     // Total number of napkins available
139     // 144,000 (get it?)
140     uint256 constant totalSupply_ = 144000 * unit;
141 
142     // mapping to keep the reason of the soul sale!
143     mapping(address => string) reasons;
144 
145     // prices that people put up for their soul
146     mapping(address => uint256) soulPrices;
147 
148     // who owns a particular soul
149     mapping(address => address) ownedBy;
150 
151     // number of souls owned by someone
152     mapping(address => uint256) soulsOwned;
153 
154     // book of souls, listing all souls on sale and sold
155     mapping(uint256 => address) soulBook;
156 
157     // owner of the contract
158     address public owner;
159 
160     // Address where soul obol is due to
161     address public charonsBoat;
162 
163     // small fee to insert soul into soulbook
164     uint256 public bookingFee;
165 
166     // souls for sale
167     uint256 public soulsForSale;
168 
169     // souls already sold
170     uint256 public soulsSold;
171 
172     // total amount of Wei collected by Charon
173     uint256 public totalObol;
174 
175     // Logs a soul transfer
176     event SoulTransfer(address indexed _from, address indexed _to);
177 
178     function SoulToken() public{
179         owner = msg.sender;
180         charonsBoat = msg.sender;
181         // fee for inserting into soulbook, unholy 13 finney
182         bookingFee = 13 finney;
183         soulsForSale = 0;
184         soulsSold = 0;
185         totalObol = 0;
186         // all napkins belong to the contract at first:
187         balances[this] = totalSupply_;
188         // 1111 napkins for the dev ;-)
189         payOutNapkins(1111 * unit);
190     }
191 
192     // fallback function, Charon sells napkins as merchandise!
193     function () public payable {
194         uint256 amount;
195         uint256 checkedAmount;
196         // give away some napkins in return proportional to value
197         amount = msg.value / napkinPrice;
198         checkedAmount = checkAmount(amount);
199         // only payout napkins if there is the appropriate amount available
200         // else throw
201         require(amount == checkedAmount);
202         // forward money to Charon
203         payCharon(msg.value);
204         // finally payout napkins
205         payOutNapkins(checkedAmount);
206     }
207 
208     // allows changing of the booking fee, note obol and token price are fixed and cannot change
209     function changeBookingFee(uint256 fee) public {
210         require(msg.sender == owner);
211         bookingFee = fee;
212     }
213 
214     // changes Charon's boat, i.e. the address where the obol is paid to
215     function changeBoat(address newBoat) public{
216         require(msg.sender == owner);
217         charonsBoat = newBoat;
218     }
219 
220     // total number of napkins distributed by Charon
221     function totalSupply() public constant returns (uint256){
222         return totalSupply_;
223     }
224 
225     // returns the reason for the selling of one's soul
226     function soldSoulBecause(address noSoulMate) public constant returns(string){
227         return reasons[noSoulMate];
228     }
229 
230     // returns the owner of a soul
231     function soulIsOwnedBy(address noSoulMate) public constant returns(address){
232         return ownedBy[noSoulMate];
233     }
234 
235     // returns number of souls owned by someone
236     function ownsSouls(address soulOwner) public constant returns(uint256){
237         return soulsOwned[soulOwner];
238     }
239 
240     // returns price of a soul
241     function soldSoulFor(address noSoulMate) public constant returns(uint256){
242         return soulPrices[noSoulMate];
243     }
244 
245     // returns the nth entry in the soulbook
246     function soulBookPage(uint256 page) public constant returns(address){
247         return soulBook[page];
248     }
249 
250     // sells your soul for a given price and a given reason!
251     function sellSoul(string reason, uint256 price) public payable{
252         uint256 charonsObol;
253         string storage has_reason = reasons[msg.sender];
254 
255         // require that user gives a reason
256         require(bytes(reason).length > 0);
257 
258         // require to pay bookingFee
259         require(msg.value >= bookingFee);
260 
261         // you cannot give away your soul for free, at least Charon wants some share
262         charonsObol = price / obol;
263         require(charonsObol > 0);
264 
265         // assert has not sold her or his soul, yet
266         require(bytes(has_reason).length == 0);
267         require(soulPrices[msg.sender] == 0);
268         require(ownedBy[msg.sender] == address(0));
269 
270         // pay book keeping fee
271         payCharon(msg.value);
272 
273         // store the reason forever on the blockchain
274         reasons[msg.sender] = reason;
275         // also the price is forever kept on the blockchain, so do not be too cheap
276         soulPrices[msg.sender] = price;
277         // and keep the soul in the soul book
278         soulBook[soulsForSale + soulsSold] = msg.sender;
279         soulsForSale += 1;
280     }
281 
282     // buys msg.sender a soul and rewards him with tokens!
283     function buySoul(address noSoulMate) public payable returns(uint256 amount){
284         uint256 charonsObol;
285         uint256 price;
286 
287         // you cannot buy an owned soul:
288         require(ownedBy[noSoulMate] == address(0));
289         // get the price of the soul
290         price = soulPrices[noSoulMate];
291         // Soul must be for sale
292         require(price > 0);
293         require(bytes(reasons[noSoulMate]).length > 0);
294         // Msg sender needs to pay the soul price
295         require(msg.value >= price);
296         charonsObol = msg.value / obol;
297 
298         // check for wrap around
299         require(soulsOwned[msg.sender] + 1 > soulsOwned[msg.sender]);
300 
301         // pay Charon
302         payCharon(charonsObol);
303         // pay the soul owner
304         noSoulMate.transfer(msg.value - charonsObol);
305 
306         // Update the soul stats
307         soulsForSale -= 1;
308         soulsSold += 1;
309         // Increase the sender's balance by the appropriate amount of souls ;-)
310         soulsOwned[msg.sender] += 1;
311         ownedBy[noSoulMate] = msg.sender;
312         // log the transfer
313         SoulTransfer(noSoulMate, msg.sender);
314 
315         // and give away napkins proportional to obol plus 1 bonus napkin ;-)
316         amount = charonsObol / napkinPrice + unit;
317         amount = checkAmount(amount);
318         if (amount > 0){
319             // only payout napkins if they are available
320             payOutNapkins(amount);
321         }
322 
323         return amount;
324     }
325 
326     // can transfer a soul to a different account, but beware you have to pay Charon again!
327     function transferSoul(address _to, address noSoulMate) public payable{
328         uint256 charonsObol;
329 
330         // require correct ownership
331         require(ownedBy[noSoulMate] == msg.sender);
332         require(soulsOwned[_to] + 1 > soulsOwned[_to]);
333         // require transfer fee is payed again
334         charonsObol = soulPrices[noSoulMate] / obol;
335         require(msg.value >= charonsObol);
336         // pay Charon
337         payCharon(msg.value);
338         // transfer the soul
339         soulsOwned[msg.sender] -= 1;
340         soulsOwned[_to] += 1;
341         ownedBy[noSoulMate] = _to;
342 
343         // Log the soul transfer
344         SoulTransfer(msg.sender, _to);
345     }
346 
347     // logs and pays charon fees
348     function payCharon(uint256 obolValue) internal{
349         totalObol += obolValue;
350         charonsBoat.transfer(obolValue);
351     }
352 
353     // checks if napkins are still available and adjusts amount accordingly
354     function checkAmount(uint256 amount) internal constant returns(uint256 checkedAmount){
355 
356         if (amount > balances[this]){
357             checkedAmount = balances[this];
358         } else {
359             checkedAmount = amount;
360         }
361 
362         return checkedAmount;
363     }
364 
365     // transfers napkins to people
366     function payOutNapkins(uint256 amount) internal{
367         // check for amount and wrap around
368         require(amount > 0);
369         // yeah some sanity check
370         require(amount <= balances[this]);
371 
372         // send napkins from contract to msg.sender
373         balances[this] -= amount;
374         balances[msg.sender] += amount;
375         // log napkin transfer
376         Transfer(this, msg.sender, amount);
377     }
378 
379 }