1 pragma solidity ^0.4.8;
2 
3 /// @title Assertive contract
4 /// @author Melonport AG <team@melonport.com>
5 /// @notice Asserts function
6 contract Assertive {
7 
8   function assert(bool assertion) internal {
9       if (!assertion) throw;
10   }
11 
12 }
13 
14 /// @title Overflow aware uint math functions.
15 /// @author Melonport AG <team@melonport.com>
16 /// @notice Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
17 contract SafeMath is Assertive{
18 
19     function safeMul(uint a, uint b) internal returns (uint) {
20         uint c = a * b;
21         assert(a == 0 || c / a == b);
22         return c;
23     }
24 
25     function safeSub(uint a, uint b) internal returns (uint) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function safeAdd(uint a, uint b) internal returns (uint) {
31         uint c = a + b;
32         assert(c>=a && c>=b);
33         return c;
34     }
35 
36 }
37 
38 /// @title ERC20 Token Protocol
39 /// @author Melonport AG <team@melonport.com>
40 /// @notice See https://github.com/ethereum/EIPs/issues/20
41 contract ERC20Protocol {
42 
43     function totalSupply() constant returns (uint256 totalSupply) {}
44     function balanceOf(address _owner) constant returns (uint256 balance) {}
45     function transfer(address _to, uint256 _value) returns (bool success) {}
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
47     function approve(address _spender, uint256 _value) returns (bool success) {}
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53 }
54 
55 /// @title ERC20 Token
56 /// @author Melonport AG <team@melonport.com>
57 /// @notice Original taken from https://github.com/ethereum/EIPs/issues/20
58 /// @notice Checked against integer overflow
59 contract ERC20 is ERC20Protocol {
60 
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91         return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95 
96     mapping (address => mapping (address => uint256)) allowed;
97 
98     uint256 public totalSupply;
99 
100 }
101 
102 
103 /// @title Melon Token Contract
104 /// @author Melonport AG <team@melonport.com>
105 contract MelonToken is ERC20, SafeMath {
106 
107     // FIELDS
108 
109     // Constant token specific fields
110     string public constant name = "Melon Token";
111     string public constant symbol = "MLN";
112     uint public constant decimals = 18;
113     uint public constant THAWING_DURATION = 2 years; // Time needed for iced tokens to thaw into liquid tokens
114     uint public constant MAX_TOTAL_TOKEN_AMOUNT_OFFERED_TO_PUBLIC = 1000000 * 10 ** decimals; // Max amount of tokens offered to the public
115     uint public constant MAX_TOTAL_TOKEN_AMOUNT = 1250000 * 10 ** decimals; // Max amount of total tokens raised during all contributions (includes stakes of patrons)
116 
117     // Fields that are only changed in constructor
118     address public minter; // Contribution contract(s)
119     address public melonport; // Can change to other minting contribution contracts but only until total amount of token minted
120     uint public startTime; // Contribution start time in seconds
121     uint public endTime; // Contribution end time in seconds
122 
123     // Fields that can be changed by functions
124     mapping (address => uint) lockedBalances;
125 
126     // MODIFIERS
127 
128     modifier only_minter {
129         assert(msg.sender == minter);
130         _;
131     }
132 
133     modifier only_melonport {
134         assert(msg.sender == melonport);
135         _;
136     }
137 
138     modifier is_later_than(uint x) {
139         assert(now > x);
140         _;
141     }
142 
143     modifier max_total_token_amount_not_reached(uint amount) {
144         assert(safeAdd(totalSupply, amount) <= MAX_TOTAL_TOKEN_AMOUNT);
145         _;
146     }
147 
148     // CONSTANT METHODS
149 
150     function lockedBalanceOf(address _owner) constant returns (uint balance) {
151         return lockedBalances[_owner];
152     }
153 
154     // METHODS
155 
156     /// Pre: All fields, except { minter, melonport, startTime, endTime } are valid
157     /// Post: All fields, including { minter, melonport, startTime, endTime } are valid
158     function MelonToken(address setMinter, address setMelonport, uint setStartTime, uint setEndTime) {
159         minter = setMinter;
160         melonport = setMelonport;
161         startTime = setStartTime;
162         endTime = setEndTime;
163     }
164 
165     /// Pre: Address of contribution contract (minter) is set
166     /// Post: Mints token into tradeable tranche
167     function mintLiquidToken(address recipient, uint amount)
168         external
169         only_minter
170         max_total_token_amount_not_reached(amount)
171     {
172         balances[recipient] = safeAdd(balances[recipient], amount);
173         totalSupply = safeAdd(totalSupply, amount);
174     }
175 
176     /// Pre: Address of contribution contract (minter) is set
177     /// Post: Mints Token into iced tranche. Become liquid after completion of the melonproject or two years.
178     function mintIcedToken(address recipient, uint amount)
179         external
180         only_minter
181         max_total_token_amount_not_reached(amount)
182     {
183         lockedBalances[recipient] = safeAdd(lockedBalances[recipient], amount);
184         totalSupply = safeAdd(totalSupply, amount);
185     }
186 
187     /// Pre: Thawing period has passed - iced funds have turned into liquid ones
188     /// Post: All funds available for trade
189     function unlockBalance(address recipient)
190         is_later_than(endTime + THAWING_DURATION)
191     {
192         balances[recipient] = safeAdd(balances[recipient], lockedBalances[recipient]);
193         lockedBalances[recipient] = 0;
194     }
195 
196     /// Pre: Prevent transfers until contribution period is over.
197     /// Post: Transfer MLN from msg.sender
198     /// Note: ERC20 interface
199     function transfer(address recipient, uint amount)
200         is_later_than(endTime)
201         returns (bool success)
202     {
203         return super.transfer(recipient, amount);
204     }
205 
206     /// Pre: Prevent transfers until contribution period is over.
207     /// Post: Transfer MLN from arbitrary address
208     /// Note: ERC20 interface
209     function transferFrom(address sender, address recipient, uint amount)
210         is_later_than(endTime)
211         returns (bool success)
212     {
213         return super.transferFrom(sender, recipient, amount);
214     }
215 
216     /// Pre: Melonport address is set. Restricted to melonport.
217     /// Post: New minter can now create tokens up to MAX_TOTAL_TOKEN_AMOUNT.
218     /// Note: This allows additional contribution periods at a later stage, while still using the same ERC20 compliant contract.
219     function changeMintingAddress(address newAddress) only_melonport { minter = newAddress; }
220 
221     /// Pre: Melonport address is set. Restricted to melonport.
222     /// Post: New address set. This address controls the setting of the minter address
223     function changeMelonportAddress(address newAddress) only_melonport { melonport = newAddress; }
224 }
225 
226 
227 /// @title Contribution Contract
228 /// @author Melonport AG <team@melonport.com>
229 /// @notice This follows Condition-Orientated Programming as outlined here:
230 /// @notice   https://medium.com/@gavofyork/condition-orientated-programming-969f6ba0161a#.saav3bvva
231 contract Contribution is SafeMath {
232 
233     // FIELDS
234 
235     // Constant fields
236     uint public constant ETHER_CAP = 227000 ether; // Max amount raised during first contribution; targeted amount CHF 2.5MN
237     uint public constant MAX_CONTRIBUTION_DURATION = 4 weeks; // Max amount in seconds of contribution period
238     uint public constant BTCS_ETHER_CAP = ETHER_CAP * 25 / 100; // Max melon token allocation for btcs before contribution period starts
239     // Price Rates
240     uint public constant PRICE_RATE_FIRST = 2200; // Four price tiers, each valid for two weeks
241     uint public constant PRICE_RATE_SECOND = 2150;
242     uint public constant PRICE_RATE_THIRD = 2100;
243     uint public constant PRICE_RATE_FOURTH = 2050;
244     uint public constant DIVISOR_PRICE = 1000; // Price rates are divided by this number
245     // Addresses of Patrons
246     address public constant FOUNDER_ONE = 0x009beAE06B0c0C536ad1eA43D6f61DCCf0748B1f;
247     address public constant FOUNDER_TWO = 0xB1EFca62C555b49E67363B48aE5b8Af3C7E3e656;
248     address public constant EXT_COMPANY_ONE = 0x00779e0e4c6083cfd26dE77B4dbc107A7EbB99d2;
249     address public constant EXT_COMPANY_TWO = 0x1F06B976136e94704D328D4d23aae7259AaC12a2;
250     address public constant EXT_COMPANY_THREE = 0xDD91615Ea8De94bC48231c4ae9488891F1648dc5;
251     address public constant ADVISOR_ONE = 0x0001126FC94AE0be2B685b8dE434a99B2552AAc3;
252     address public constant ADVISOR_TWO = 0x4f2AF8d2614190Cc80c6E9772B0C367db8D9753C;
253     address public constant ADVISOR_THREE = 0x715a70a7c7d76acc8d5874862e381c1940c19cce;
254     address public constant ADVISOR_FOUR = 0x8615F13C12c24DFdca0ba32511E2861BE02b93b2;
255     address public constant AMBASSADOR_ONE = 0xd3841FB80CE408ca7d0b41D72aA91CA74652AF47;
256     address public constant AMBASSADOR_TWO = 0xDb775577538018a689E4Ad2e8eb5a7Ae7c34722B;
257     address public constant AMBASSADOR_THREE = 0xaa967e0ce6A1Ff5F9c124D15AD0412F137C99767;
258     address public constant AMBASSADOR_FOUR = 0x910B41a6568a645437bC286A5C733f3c501d8c88;
259     address public constant AMBASSADOR_FIVE = 0xb1d16BFE840E66E3c81785551832aAACB4cf69f3;
260     address public constant AMBASSADOR_SIX = 0x5F6ff16364BfEf546270325695B6e90cc89C497a;
261     address public constant AMBASSADOR_SEVEN = 0x58656e8872B0d266c2acCD276cD23F4C0B5fEfb9;
262     address public constant SPECIALIST_ONE = 0x8a815e818E617d1f93BE7477D179258aC2d25310;
263     address public constant SPECIALIST_TWO = 0x1eba6702ba21cfc1f6c87c726364b60a5e444901;
264     address public constant SPECIALIST_THREE = 0x82eae6c30ed9606e2b389ae65395648748c6a17f;
265     // Stakes of Patrons
266     uint public constant MELONPORT_COMPANY_STAKE = 1000; // 10% of all created melon token allocated to melonport company
267     uint public constant FOUNDER_STAKE = 445; // 4.45% of all created melon token allocated to founder
268     uint public constant EXT_COMPANY_STAKE_ONE = 150; // 1.5% of all created melon token allocated to external company
269     uint public constant EXT_COMPANY_STAKE_TWO = 100; // 1% of all created melon token allocated to external company
270     uint public constant EXT_COMPANY_STAKE_THREE = 50; // 0.5% of all created melon token allocated to external company
271     uint public constant ADVISOR_STAKE_ONE = 150; // 1.5% of all created melon token allocated to advisor
272     uint public constant ADVISOR_STAKE_TWO = 50; // 0.5% of all created melon token allocated to advisor
273     uint public constant ADVISOR_STAKE_THREE = 25; // 0.25% of all created melon token allocated to advisor
274     uint public constant ADVISOR_STAKE_FOUR = 10; // 0.1% of all created melon token allocated to advisor
275     uint public constant AMBASSADOR_STAKE = 5; // 0.05% of all created melon token allocated to ambassadors
276     uint public constant SPECIALIST_STAKE_ONE = 25; // 0.25% of all created melon token allocated to specialist
277     uint public constant SPECIALIST_STAKE_TWO = 10; // 0.1% of all created melon token allocated to specialist
278     uint public constant SPECIALIST_STAKE_THREE = 5; // 0.05% of all created melon token allocated to specialist
279     uint public constant DIVISOR_STAKE = 10000; // Stakes are divided by this number; Results to one basis point
280 
281     // Fields that are only changed in constructor
282     address public melonport; // All deposited ETH will be instantly forwarded to this address.
283     address public btcs; // Bitcoin Suisse address for their allocation option
284     address public signer; // Signer address as on https://contribution.melonport.com
285     uint public startTime; // Contribution start time in seconds
286     uint public endTime; // Contribution end time in seconds
287     MelonToken public melonToken; // Contract of the ERC20 compliant melon token
288 
289     // Fields that can be changed by functions
290     uint public etherRaised; // This will keep track of the Ether raised during the contribution
291     bool public halted; // The melonport address can set this to true to halt the contribution due to an emergency
292 
293     // EVENTS
294 
295     event TokensBought(address indexed sender, uint eth, uint amount);
296 
297     // MODIFIERS
298 
299     modifier is_signer_signature(uint8 v, bytes32 r, bytes32 s) {
300         bytes32 hash = sha256(msg.sender);
301         assert(ecrecover(hash, v, r, s) == signer);
302         _;
303     }
304 
305     modifier only_melonport {
306         assert(msg.sender == melonport);
307         _;
308     }
309 
310     modifier only_btcs {
311         assert(msg.sender == btcs);
312         _;
313     }
314 
315     modifier is_not_halted {
316         assert(!halted);
317         _;
318     }
319 
320     modifier ether_cap_not_reached {
321         assert(safeAdd(etherRaised, msg.value) <= ETHER_CAP);
322         _;
323     }
324 
325     modifier btcs_ether_cap_not_reached {
326         assert(safeAdd(etherRaised, msg.value) <= BTCS_ETHER_CAP);
327         _;
328     }
329 
330     modifier is_not_earlier_than(uint x) {
331         assert(now >= x);
332         _;
333     }
334 
335     modifier is_earlier_than(uint x) {
336         assert(now < x);
337         _;
338     }
339 
340     // CONSTANT METHODS
341 
342     /// Pre: startTime, endTime specified in constructor,
343     /// Post: Price rate at given blockTime; One ether equals priceRate() / DIVISOR_PRICE of melon tokens
344     function priceRate() constant returns (uint) {
345         // Four price tiers
346         if (startTime <= now && now < startTime + 1 weeks)
347             return PRICE_RATE_FIRST;
348         if (startTime + 1 weeks <= now && now < startTime + 2 weeks)
349             return PRICE_RATE_SECOND;
350         if (startTime + 2 weeks <= now && now < startTime + 3 weeks)
351             return PRICE_RATE_THIRD;
352         if (startTime + 3 weeks <= now && now < endTime)
353             return PRICE_RATE_FOURTH;
354         // Should not be called before or after contribution period
355         assert(false);
356     }
357 
358     // NON-CONSTANT METHODS
359 
360     /// Pre: All fields, except { melonport, btcs, signer, startTime } are valid
361     /// Post: All fields, including { melonport, btcs, signer, startTime } are valid
362     function Contribution(address setMelonport, address setBTCS, address setSigner, uint setStartTime) {
363         melonport = setMelonport;
364         btcs = setBTCS;
365         signer = setSigner;
366         startTime = setStartTime;
367         endTime = startTime + MAX_CONTRIBUTION_DURATION;
368         melonToken = new MelonToken(this, melonport, startTime, endTime); // Create Melon Token Contract
369         var maxTotalTokenAmountOfferedToPublic = melonToken.MAX_TOTAL_TOKEN_AMOUNT_OFFERED_TO_PUBLIC();
370         uint stakeMultiplier = maxTotalTokenAmountOfferedToPublic / DIVISOR_STAKE;
371         // Mint liquid tokens for melonport company, liquid means tradeale
372         melonToken.mintLiquidToken(melonport,       MELONPORT_COMPANY_STAKE * stakeMultiplier);
373         // Mint iced tokens that are unable to trade for two years and allocate according to relevant stakes
374         melonToken.mintIcedToken(FOUNDER_ONE,       FOUNDER_STAKE *           stakeMultiplier);
375         melonToken.mintIcedToken(FOUNDER_TWO,       FOUNDER_STAKE *           stakeMultiplier);
376         melonToken.mintIcedToken(EXT_COMPANY_ONE,   EXT_COMPANY_STAKE_ONE *   stakeMultiplier);
377         melonToken.mintIcedToken(EXT_COMPANY_TWO,   EXT_COMPANY_STAKE_TWO *   stakeMultiplier);
378         melonToken.mintIcedToken(EXT_COMPANY_THREE, EXT_COMPANY_STAKE_THREE * stakeMultiplier);
379         melonToken.mintIcedToken(ADVISOR_ONE,       ADVISOR_STAKE_ONE *       stakeMultiplier);
380         melonToken.mintIcedToken(ADVISOR_TWO,       ADVISOR_STAKE_TWO *       stakeMultiplier);
381         melonToken.mintIcedToken(ADVISOR_THREE,     ADVISOR_STAKE_THREE *     stakeMultiplier);
382         melonToken.mintIcedToken(ADVISOR_FOUR,      ADVISOR_STAKE_FOUR *      stakeMultiplier);
383         melonToken.mintIcedToken(AMBASSADOR_ONE,    AMBASSADOR_STAKE *        stakeMultiplier);
384         melonToken.mintIcedToken(AMBASSADOR_TWO,    AMBASSADOR_STAKE *        stakeMultiplier);
385         melonToken.mintIcedToken(AMBASSADOR_THREE,  AMBASSADOR_STAKE *        stakeMultiplier);
386         melonToken.mintIcedToken(AMBASSADOR_FOUR,   AMBASSADOR_STAKE *        stakeMultiplier);
387         melonToken.mintIcedToken(AMBASSADOR_FIVE,   AMBASSADOR_STAKE *        stakeMultiplier);
388         melonToken.mintIcedToken(AMBASSADOR_SIX,    AMBASSADOR_STAKE *        stakeMultiplier);
389         melonToken.mintIcedToken(AMBASSADOR_SEVEN,  AMBASSADOR_STAKE *        stakeMultiplier);
390         melonToken.mintIcedToken(SPECIALIST_ONE,    SPECIALIST_STAKE_ONE *    stakeMultiplier);
391         melonToken.mintIcedToken(SPECIALIST_TWO,    SPECIALIST_STAKE_TWO *    stakeMultiplier);
392         melonToken.mintIcedToken(SPECIALIST_THREE,  SPECIALIST_STAKE_THREE *  stakeMultiplier);
393     }
394 
395     /// Pre: Valid signature received from https://contribution.melonport.com
396     /// Post: Bought melon tokens according to priceRate() and msg.value
397     function buy(uint8 v, bytes32 r, bytes32 s) payable { buyRecipient(msg.sender, v, r, s); }
398 
399     /// Pre: Valid signature received from https://contribution.melonport.com
400     /// Post: Bought melon tokens according to priceRate() and msg.value on behalf of recipient
401     function buyRecipient(address recipient, uint8 v, bytes32 r, bytes32 s)
402         payable
403         is_signer_signature(v, r, s)
404         is_not_earlier_than(startTime)
405         is_earlier_than(endTime)
406         is_not_halted
407         ether_cap_not_reached
408     {
409         uint amount = safeMul(msg.value, priceRate()) / DIVISOR_PRICE;
410         melonToken.mintLiquidToken(recipient, amount);
411         etherRaised = safeAdd(etherRaised, msg.value);
412         assert(melonport.send(msg.value));
413         TokensBought(recipient, msg.value, amount);
414     }
415 
416     /// Pre: BTCS before contribution period, BTCS has exclusive right to buy up to 25% of all melon tokens
417     /// Post: Bought melon tokens according to PRICE_RATE_FIRST and msg.value on behalf of recipient
418     function btcsBuyRecipient(address recipient)
419         payable
420         only_btcs
421         is_earlier_than(startTime)
422         is_not_halted
423         btcs_ether_cap_not_reached
424     {
425         uint amount = safeMul(msg.value, PRICE_RATE_FIRST) / DIVISOR_PRICE;
426         melonToken.mintLiquidToken(recipient, amount);
427         etherRaised = safeAdd(etherRaised, msg.value);
428         assert(melonport.send(msg.value));
429         TokensBought(recipient, msg.value, amount);
430     }
431 
432     /// Pre: Emergency situation that requires contribution period to stop.
433     /// Post: Contributing not possible anymore.
434     function halt() only_melonport { halted = true; }
435 
436     /// Pre: Emergency situation resolved.
437     /// Post: Contributing becomes possible again withing the outlined restrictions.
438     function unhalt() only_melonport { halted = false; }
439 
440     /// Pre: Restricted to melonport.
441     /// Post: New address set. To halt contribution and/or change minter in MelonToken contract.
442     function changeMelonportAddress(address newAddress) only_melonport { melonport = newAddress; }
443 }