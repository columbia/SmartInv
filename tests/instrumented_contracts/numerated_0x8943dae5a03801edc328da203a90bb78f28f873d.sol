1 // AP Ok - Recent version
2 pragma solidity ^0.4.13;
3 
4 // ----------------------------------------------------------------------------
5 // Arenaplay Crowdsale Token Contract
6 //
7 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd
8 // The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths, borrowed from OpenZeppelin
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16 
17     // ------------------------------------------------------------------------
18     // Add a number to another number, checking for overflows
19     // ------------------------------------------------------------------------
20     // AP Ok - Overflow protected
21     function add(uint a, uint b) internal returns (uint) {
22         uint c = a + b;
23         assert(c >= a && c >= b);
24         return c;
25     }
26 
27     // ------------------------------------------------------------------------
28     // Subtract a number from another number, checking for underflows
29     // ------------------------------------------------------------------------
30     // AP Ok - Underflow protected
31     function sub(uint a, uint b) internal returns (uint) {
32         assert(b <= a);
33         return a - b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // Owned contract
40 // ----------------------------------------------------------------------------
41 contract Owned {
42     // AP Next 3 lines Ok
43     address public owner;
44     address public newOwner;
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     // AP Ok - Constructor assigns `owner` variable
48     function Owned() {
49         owner = msg.sender;
50     }
51 
52     // AP Ok - Only owner can execute function
53     modifier onlyOwner {
54         // AP Ok - Could be replaced with `require(msg.sender == owner);`
55         require(msg.sender == owner);
56         _;
57     }
58 
59     // AP Ok - Propose ownership transfer
60     function transferOwnership(address _newOwner) onlyOwner {
61         newOwner = _newOwner;
62     }
63  
64     // AP Ok - Accept ownership transfer
65     function acceptOwnership() {
66         if (msg.sender == newOwner) {
67             OwnershipTransferred(owner, newOwner);
68             owner = newOwner;
69         }
70     }
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // ERC20 Token, with the addition of symbol, name and decimals
76 // https://github.com/ethereum/EIPs/issues/20
77 // ----------------------------------------------------------------------------
78 contract ERC20Token is Owned {
79     // AP Ok - For overflow and underflow protection
80     using SafeMath for uint;
81 
82     // ------------------------------------------------------------------------
83     // Total Supply
84     // ------------------------------------------------------------------------
85     // AP Ok
86     uint256 _totalSupply = 0;
87 
88     // ------------------------------------------------------------------------
89     // Balances for each account
90     // ------------------------------------------------------------------------
91     // AP Ok
92     mapping(address => uint256) balances;
93 
94     // ------------------------------------------------------------------------
95     // Owner of account approves the transfer of an amount to another account
96     // ------------------------------------------------------------------------
97     // AP Ok
98     mapping(address => mapping (address => uint256)) allowed;
99 
100     // ------------------------------------------------------------------------
101     // Get the total token supply
102     // ------------------------------------------------------------------------
103     // AP Ok
104     function totalSupply() constant returns (uint256 totalSupply) {
105         totalSupply = _totalSupply;
106     }
107 
108     // ------------------------------------------------------------------------
109     // Get the account balance of another account with address _owner
110     // ------------------------------------------------------------------------
111     // AP Ok
112     function balanceOf(address _owner) constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     // ------------------------------------------------------------------------
117     // Transfer the balance from owner's account to another account
118     // ------------------------------------------------------------------------
119     // AP NOTE - This function will return true/false instead of throwing an
120     //           error, as the conditions protect against overflows and 
121     //           underflows
122     // AP NOTE - This function does not protect against the short address
123     //           bug, but the short address bug is more the responsibility
124     //           of automated processes checking the data sent to this function
125     function transfer(address _to, uint256 _amount) returns (bool success) {
126         // AP Ok - Account has sufficient balance to transfer
127         if (balances[msg.sender] >= _amount                // User has balance
128             // AP Ok - Non-zero amount
129             && _amount > 0                                 // Non-zero transfer
130             // AP Ok - Overflow protection
131             && balances[_to] + _amount > balances[_to]     // Overflow check
132         ) {
133             // AP Ok
134             balances[msg.sender] = balances[msg.sender].sub(_amount);
135             // AP Ok
136             balances[_to] = balances[_to].add(_amount);
137             // AP Ok - Logging
138             Transfer(msg.sender, _to, _amount);
139             return true;
140         } else {
141             return false;
142         }
143     }
144 
145     // ------------------------------------------------------------------------
146     // Allow _spender to withdraw from your account, multiple times, up to the
147     // _value amount. If this function is called again it overwrites the
148     // current allowance with _value.
149     // ------------------------------------------------------------------------
150     // AP NOTE - This simpler method of `approve(...)` together with 
151     //           `transferFrom(...)` can be used in the double spending attack, 
152     //           but the risk is low, and can be mitigated by the user setting 
153     //           the approval limit to 0 before changing the limit 
154     function approve(
155         address _spender,
156         uint256 _amount
157     ) returns (bool success) {
158         // AP Ok
159         allowed[msg.sender][_spender] = _amount;
160         Approval(msg.sender, _spender, _amount);
161         return true;
162     }
163 
164     // ------------------------------------------------------------------------
165     // Spender of tokens transfer an amount of tokens from the token owner's
166     // balance to the spender's account. The owner of the tokens must already
167     // have approve(...)-d this transfer
168     // ------------------------------------------------------------------------
169     // AP NOTE - This function will return true/false instead of throwing an
170     //           error, as the conditions protect against overflows and 
171     //           underflows
172     // AP NOTE - This simpler method of `transferFrom(...)` together with 
173     //           `approve(...)` can be used in the double spending attack, 
174     //           but the risk is low, and can be mitigated by the user setting 
175     //           the approval limit to 0 before changing the limit 
176     // AP NOTE - This function does not protect against the short address
177     //           bug, but the short address bug is more the responsibility
178     //           of automated processes checking the data sent to this function
179     function transferFrom(
180         address _from,
181         address _to,
182         uint256 _amount
183     ) returns (bool success) {
184         // AP Ok - Account has sufficient balance to transfer
185         if (balances[_from] >= _amount                  // From a/c has balance
186             // AP Ok - Account is authorised to spend at least this amount
187             && allowed[_from][msg.sender] >= _amount    // Transfer approved
188             // AP Ok - Non-zero amount
189             && _amount > 0                              // Non-zero transfer
190             // AP Ok - Overflow protection
191             && balances[_to] + _amount > balances[_to]  // Overflow check
192         ) {
193             // AP Ok
194             balances[_from] = balances[_from].sub(_amount);
195             // AP Ok
196             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
197             // AP Ok
198             balances[_to] = balances[_to].add(_amount);
199             // AP Ok
200             Transfer(_from, _to, _amount);
201             return true;
202         } else {
203             return false;
204         }
205     }
206 
207     // ------------------------------------------------------------------------
208     // Returns the amount of tokens approved by the owner that can be
209     // transferred to the spender's account
210     // ------------------------------------------------------------------------
211     // AP Ok
212     function allowance(
213         address _owner, 
214         address _spender
215     ) constant returns (uint256 remaining) {
216         return allowed[_owner][_spender];
217     }
218 
219     // AP Ok
220     event Transfer(address indexed _from, address indexed _to, uint256 _value);
221     // AP Ok
222     event Approval(address indexed _owner, address indexed _spender,
223         uint256 _value);
224 }
225 
226 
227 contract ArenaplayToken is ERC20Token {
228 
229     // ------------------------------------------------------------------------
230     // Token information
231     // ------------------------------------------------------------------------
232     // AP Next 3 lines Ok. Using uint8 for decimals instead of uint256
233     string public constant symbol = "APY";
234     string public constant name = "Arenaplay.io";
235     uint8 public constant decimals = 18;
236 
237     // > new Date("2017-06-29T13:00:00").getTime()/1000
238     // 1498741200
239     // Do not use `now` here
240     // AP NOTE - This contract uses the date/time instead of blocks to determine
241     //           the start, end and BET/ETH scale. The use of date/time in 
242     //           these contracts can be used by miners to skew the block time.
243     //           This is not a significant risk in a crowdfunding contract.
244     uint256 public constant STARTDATE = 1501173471;
245     // BK Ok
246     uint256 public constant ENDDATE = STARTDATE + 39 days;
247 
248     // Cap USD 10mil @ 200 ETH/USD
249     // AP NOTE - The following constant will need to be updated with the correct
250     //           ETH/USD exchange rate. The aim for Arenaplay.io is to raise
251     //           USD 10 million, INCLUDING the precommitments. This cap will
252     //           have to take into account the ETH equivalent amount of the
253     //           precommitment 
254     uint256 public constant CAP = 50000 ether;
255 
256     // Cannot have a constant address here - Solidity bug
257     // https://github.com/ethereum/solidity/issues/2441
258     // AP Ok
259     address public multisig = 0x0e43311768025D0773F62fBF4a6cd083C508d979;
260 
261     // AP Ok - To compare against the `CAP` variable
262     uint256 public totalEthers;
263 
264     // AP Ok - Constructor
265     function ArenaplayToken() {
266     }
267 
268 
269     // ------------------------------------------------------------------------
270  
271     // ------------------------------------------------------------------------
272     // AP Ok - Calculate the APY/ETH at this point in time
273     function buyPrice() constant returns (uint256) {
274         return buyPriceAt(now);
275     }
276 
277     // AP Ok - Calculate APY/ETH at any point in time. Can be used in EtherScan
278     //         to determine past, current or future APY/ETH rate 
279     // AP NOTE - Scale is continuous
280     function buyPriceAt(uint256 at) constant returns (uint256) {
281         if (at < STARTDATE) {
282             return 0;
283         } else if (at < (STARTDATE + 9 days)) {
284             return 2700;
285         } else if (at < (STARTDATE + 18 days)) {
286             return 2400;
287         } else if (at < (STARTDATE + 27 days)) {
288             return 2050;
289         } else if (at <= ENDDATE) {
290             return 1500;
291         } else {
292             return 0;
293         }
294     }
295 
296 
297     // ------------------------------------------------------------------------
298     // Buy tokens from the contract
299     // ------------------------------------------------------------------------
300     // AP Ok - Account can send tokens directly to this contract's address
301     function () payable {
302         proxyPayment(msg.sender);
303     }
304 
305 
306     // ------------------------------------------------------------------------
307     // Exchanges can buy on behalf of participant
308     // ------------------------------------------------------------------------
309     // AP Ok
310     function proxyPayment(address participant) payable {
311         // No contributions before the start of the crowdsale
312         // AP Ok
313         require(now >= STARTDATE);
314         // No contributions after the end of the crowdsale
315         // AP Ok
316         require(now <= ENDDATE);
317         // No 0 contributions
318         // AP Ok
319         require(msg.value > 0);
320 
321         // Add ETH raised to total
322         // AP Ok - Overflow protected
323         totalEthers = totalEthers.add(msg.value);
324         // Cannot exceed cap
325         // AP Ok
326         require(totalEthers <= CAP);
327 
328         // What is the APY to ETH rate
329         // AP Ok
330         uint256 _buyPrice = buyPrice();
331 
332         // Calculate #APY - this is safe as _buyPrice is known
333         // and msg.value is restricted to valid values
334         // AP Ok
335         uint tokens = msg.value * _buyPrice;
336 
337         // Check tokens > 0
338         // AP Ok
339         require(tokens > 0);
340         // Compute tokens for foundation 20%
341         // Number of tokens restricted so maths is safe
342         // AP Ok
343         uint multisigTokens = tokens * 2 / 10 ;
344 
345         // Add to total supply
346         // AP Ok
347         _totalSupply = _totalSupply.add(tokens);
348         // AP Ok
349         _totalSupply = _totalSupply.add(multisigTokens);
350 
351         // Add to balances
352         // AP Ok
353         balances[participant] = balances[participant].add(tokens);
354         // AP Ok
355         balances[multisig] = balances[multisig].add(multisigTokens);
356 
357         // Log events
358         // AP Next 4 lines Ok
359         TokensBought(participant, msg.value, totalEthers, tokens,
360             multisigTokens, _totalSupply, _buyPrice);
361         Transfer(0x0, participant, tokens);
362         Transfer(0x0, multisig, multisigTokens);
363 
364         // Move the funds to a safe wallet
365         // https://github.com/ConsenSys/smart-contract-best-practices#be-aware-of-the-tradeoffs-between-send-transfer-and-callvalue
366         multisig.transfer(msg.value);
367     }
368     // AP Ok
369     event TokensBought(address indexed buyer, uint256 ethers, 
370         uint256 newEtherBalance, uint256 tokens, uint256 multisigTokens, 
371         uint256 newTotalSupply, uint256 buyPrice);
372 
373 
374     // ------------------------------------------------------------------------
375     // Owner to add precommitment funding token balance before the crowdsale
376     // commences
377     // ------------------------------------------------------------------------
378     // AP NOTE - Owner can only execute this before the crowdsale starts
379     // AP NOTE - Owner must add amount * 3 / 7 for the foundation for each
380     //           precommitment amount
381     // AP NOTE - The CAP must take into account the equivalent ETH raised
382     //           for the precommitment amounts
383     function addPrecommitment(address participant, uint balance) onlyOwner {
384         //APK Ok
385         require(now < STARTDATE);
386         // AP Ok
387         require(balance > 0);
388         // AP Ok
389         balances[participant] = balances[participant].add(balance);
390         // AP Ok
391         _totalSupply = _totalSupply.add(balance);
392         // AP Ok
393         Transfer(0x0, participant, balance);
394     }
395 
396 
397     // ------------------------------------------------------------------------
398     // Transfer the balance from owner's account to another account, with a
399     // check that the crowdsale is finalised
400     // ------------------------------------------------------------------------
401     // AP Ok
402     function transfer(address _to, uint _amount) returns (bool success) {
403         // Cannot transfer before crowdsale ends or cap reached
404         // AP Ok
405         require(now > ENDDATE || totalEthers == CAP);
406         // Standard transfer
407         // AP Ok
408         return super.transfer(_to, _amount);
409     }
410 
411 
412     // ------------------------------------------------------------------------
413     // Spender of tokens transfer an amount of tokens from the token owner's
414     // balance to another account, with a check that the crowdsale is
415     // finalised
416     // ------------------------------------------------------------------------
417     // AP Ok
418     function transferFrom(address _from, address _to, uint _amount) 
419         returns (bool success)
420     {
421         // Cannot transfer before crowdsale ends or cap reached
422         // AP Ok
423         require(now > ENDDATE || totalEthers == CAP);
424         // Standard transferFrom
425         // AP Ok
426         return super.transferFrom(_from, _to, _amount);
427     }
428 
429 
430     // ------------------------------------------------------------------------
431     // Owner can transfer out any accidentally sent ERC20 tokens
432     // ------------------------------------------------------------------------
433     // AP Ok - Only owner
434     function transferAnyERC20Token(address tokenAddress, uint amount)
435       onlyOwner returns (bool success) 
436     {
437         // AP Ok
438         return ERC20Token(tokenAddress).transfer(owner, amount);
439     }
440 }