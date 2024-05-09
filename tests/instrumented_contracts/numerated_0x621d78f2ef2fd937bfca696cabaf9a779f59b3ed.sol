1 contract Owned {
2 
3     // The address of the account that is the current owner 
4     address public owner;
5 
6     // The publiser is the inital owner
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     /**
12      * Access is restricted to the current owner
13      */
14     modifier onlyOwner() {
15         if (msg.sender != owner) throw;
16         _;
17     }
18 
19     /**
20      * Transfer ownership to `_newOwner`
21      *
22      * @param _newOwner The address of the account that will become the new owner 
23      */
24     function transferOwnership(address _newOwner) onlyOwner {
25         owner = _newOwner;
26     }
27 }
28 
29 // Abstract contract for the full ERC 20 Token standard
30 // https://github.com/ethereum/EIPs/issues/20
31 contract Token {
32     /* This is a slight change to the ERC20 base standard.
33     function totalSupply() constant returns (uint256 supply);
34     is replaced with:
35     uint256 public totalSupply;
36     This automatically creates a getter function for the totalSupply.
37     This is moved to the base contract since public getter functions are not
38     currently recognised as an implementation of the matching abstract
39     function by the compiler.
40     */
41     /// total amount of tokens
42     uint256 public totalSupply;
43 
44     /// @param _owner The address from which the balance will be retrieved
45     /// @return The balance
46     function balanceOf(address _owner) constant returns (uint256 balance);
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool success);
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of tokens to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) returns (bool success);
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 /**
77  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
78  *
79  * Modified version of https://github.com/ConsenSys/Tokens that implements the 
80  * original Token contract, an abstract contract for the full ERC 20 Token standard
81  */
82 contract StandardToken is Token {
83 
84     // Token starts if the locked state restricting transfers
85     bool public locked;
86 
87     // DCORP token balances
88     mapping (address => uint256) balances;
89 
90     // DCORP token allowances
91     mapping (address => mapping (address => uint256)) allowed;
92     
93 
94     /** 
95      * Get balance of `_owner` 
96      * 
97      * @param _owner The address from which the balance will be retrieved
98      * @return The balance
99      */
100     function balanceOf(address _owner) constant returns (uint256 balance) {
101         return balances[_owner];
102     }
103 
104 
105     /** 
106      * Send `_value` token to `_to` from `msg.sender`
107      * 
108      * @param _to The address of the recipient
109      * @param _value The amount of token to be transferred
110      * @return Whether the transfer was successful or not
111      */
112     function transfer(address _to, uint256 _value) returns (bool success) {
113 
114         // Unable to transfer while still locked
115         if (locked) {
116             throw;
117         }
118 
119         // Check if the sender has enough tokens
120         if (balances[msg.sender] < _value) { 
121             throw;
122         }        
123 
124         // Check for overflows
125         if (balances[_to] + _value < balances[_to])  { 
126             throw;
127         }
128 
129         // Transfer tokens
130         balances[msg.sender] -= _value;
131         balances[_to] += _value;
132 
133         // Notify listners
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138 
139     /** 
140      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
141      * 
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value The amount of token to be transferred
145      * @return Whether the transfer was successful or not
146      */
147     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
148 
149          // Unable to transfer while still locked
150         if (locked) {
151             throw;
152         }
153 
154         // Check if the sender has enough
155         if (balances[_from] < _value) { 
156             throw;
157         }
158 
159         // Check for overflows
160         if (balances[_to] + _value < balances[_to]) { 
161             throw;
162         }
163 
164         // Check allowance
165         if (_value > allowed[_from][msg.sender]) { 
166             throw;
167         }
168 
169         // Transfer tokens
170         balances[_to] += _value;
171         balances[_from] -= _value;
172 
173         // Update allowance
174         allowed[_from][msg.sender] -= _value;
175 
176         // Notify listners
177         Transfer(_from, _to, _value);
178         return true;
179     }
180 
181 
182     /** 
183      * `msg.sender` approves `_spender` to spend `_value` tokens
184      * 
185      * @param _spender The address of the account able to transfer the tokens
186      * @param _value The amount of tokens to be approved for transfer
187      * @return Whether the approval was successful or not
188      */
189     function approve(address _spender, uint256 _value) returns (bool success) {
190 
191         // Unable to approve while still locked
192         if (locked) {
193             throw;
194         }
195 
196         // Update allowance
197         allowed[msg.sender][_spender] = _value;
198 
199         // Notify listners
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204 
205     /** 
206      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
207      * 
208      * @param _owner The address of the account owning tokens
209      * @param _spender The address of the account able to transfer the tokens
210      * @return Amount of remaining tokens allowed to spent
211      */
212     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
213       return allowed[_owner][_spender];
214     }
215 }
216 
217 /**
218  * @title DRP (DCorp) token
219  *
220  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition 
221  * of ownership, a lock and issuing.
222  *
223  * #created 05/03/2017
224  * #author Frank Bonnet
225  */
226 contract DRPToken is Owned, StandardToken {
227 
228     // Ethereum token standaard
229     string public standard = "Token 0.1";
230 
231     // Full name
232     string public name = "DCORP";        
233     
234     // Symbol
235     string public symbol = "DRP";
236 
237     // No decimal points
238     uint8 public decimals = 2;
239 
240     // Core team insentive distribution
241     bool public incentiveDistributionStarted = false;
242     uint256 public incentiveDistributionDate = 0;
243     uint256 public incentiveDistributionRound = 1;
244     uint256 public incentiveDistributionMaxRounds = 3;
245     uint256 public incentiveDistributionInterval = 1 years;
246     uint256 public incentiveDistributionRoundDenominator = 2;
247     
248     // Core team incentives
249     struct Incentive {
250         address recipient;
251         uint8 percentage;
252     }
253 
254     Incentive[] public incentives;
255     
256 
257     /**
258      * Starts with a total supply of zero and the creator starts with 
259      * zero tokens (just like everyone else)
260      */
261     function DRPToken() {  
262         balances[msg.sender] = 0;
263         totalSupply = 0;
264         locked = true;
265 
266         incentives.push(Incentive(0x3cAf983aCCccc2551195e0809B7824DA6FDe4EC8, 49)); // 0.049 * 10^3 founder
267         incentives.push(Incentive(0x11666F3492F03c930682D0a11c93BF708d916ad7, 19)); // 0.019 * 10^3 core angel
268         incentives.push(Incentive(0x6c31dE34b5df94F681AFeF9757eC3ed1594F7D9e, 19)); // 0.019 * 10^3 core angel
269         incentives.push(Incentive(0x5becE8B6Cb3fB8FAC39a09671a9c32872ACBF267, 9));  // 0.009 * 10^3 core early
270         incentives.push(Incentive(0x00DdD4BB955e0C93beF9b9986b5F5F330Fd016c6, 5));  // 0.005 * 10^3 misc
271     }
272 
273 
274     /**
275      * Starts incentive distribution 
276      *
277      * Called by the crowdsale contract when tokenholders voted 
278      * for the transfer of ownership of the token contract to DCorp
279      * 
280      * @return Whether the incentive distribution was started
281      */
282     function startIncentiveDistribution() onlyOwner returns (bool success) {
283         if (!incentiveDistributionStarted) {
284             incentiveDistributionDate = now + incentiveDistributionInterval;
285             incentiveDistributionStarted = true;
286         }
287 
288         return incentiveDistributionStarted;
289     }
290 
291 
292     /**
293      * Distributes incentives over the core team members as 
294      * described in the whitepaper
295      */
296     function withdrawIncentives() {
297 
298         // Crowdsale triggers incentive distribution
299         if (!incentiveDistributionStarted) {
300             throw;
301         }
302 
303         // Enforce max distribution rounds
304         if (incentiveDistributionRound > incentiveDistributionMaxRounds) {
305             throw;
306         }
307 
308         // Enforce time interval
309         if (now < incentiveDistributionDate) {
310             throw;
311         }
312 
313         uint256 totalSupplyToDate = totalSupply;
314         uint256 denominator = 1;
315 
316         // Incentive decreased each round
317         if (incentiveDistributionRound > 1) {
318             denominator = incentiveDistributionRoundDenominator**(incentiveDistributionRound - 1);
319         }
320 
321         for (uint256 i = 0; i < incentives.length; i++) {
322 
323             // totalSupplyToDate * (percentage * 10^3) / 10^3 / denominator
324             uint256 amount = totalSupplyToDate * incentives[i].percentage / 10**3 / denominator; 
325             address recipient =  incentives[i].recipient;
326 
327             // Create tokens
328             balances[recipient] += amount;
329             totalSupply += amount;
330 
331             // Notify listners
332             Transfer(0, this, amount);
333             Transfer(this, recipient, amount);
334         }
335 
336         // Next round
337         incentiveDistributionDate = now + incentiveDistributionInterval;
338         incentiveDistributionRound++;
339     }
340 
341 
342     /**
343      * Unlocks the token irreversibly so that the transfering of value is enabled 
344      *
345      * @return Whether the unlocking was successful or not
346      */
347     function unlock() onlyOwner returns (bool success)  {
348         locked = false;
349         return true;
350     }
351 
352 
353     /**
354      * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)
355      *
356      * @param _recipient The address to which the tokens will be issued
357      * @param _value The amount of new tokens to issue
358      * @return Whether the approval was successful or not
359      */
360     function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {
361 
362         // Guarantee positive 
363         if (_value < 0) {
364             throw;
365         }
366 
367         // Create tokens
368         balances[_recipient] += _value;
369         totalSupply += _value;
370 
371         // Notify listners
372         Transfer(0, owner, _value);
373         Transfer(owner, _recipient, _value);
374 
375         return true;
376     }
377 
378 
379     /**
380      * Prevents accidental sending of ether
381      */
382     function () {
383         throw;
384     }
385 }