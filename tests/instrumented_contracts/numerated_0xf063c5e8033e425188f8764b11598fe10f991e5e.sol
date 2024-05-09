1 contract StandardTokenProtocol {
2 
3     function totalSupply() constant returns (uint256 totalSupply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _recipient, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9 
10     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13 }
14 
15 
16 contract StandardToken is StandardTokenProtocol {
17 
18     modifier when_can_transfer(address _from, uint256 _value) {
19         if (balances[_from] >= _value) _;
20     }
21 
22     modifier when_can_receive(address _recipient, uint256 _value) {
23         if (balances[_recipient] + _value > balances[_recipient]) _;
24     }
25 
26     modifier when_is_allowed(address _from, address _delegate, uint256 _value) {
27         if (allowed[_from][_delegate] >= _value) _;
28     }
29 
30     function transfer(address _recipient, uint256 _value)
31         when_can_transfer(msg.sender, _value)
32         when_can_receive(_recipient, _value)
33         returns (bool o_success)
34     {
35         balances[msg.sender] -= _value;
36         balances[_recipient] += _value;
37         Transfer(msg.sender, _recipient, _value);
38         return true;
39     }
40 
41     function transferFrom(address _from, address _recipient, uint256 _value)
42         when_can_transfer(_from, _value)
43         when_can_receive(_recipient, _value)
44         when_is_allowed(_from, msg.sender, _value)
45         returns (bool o_success)
46     {
47         allowed[_from][msg.sender] -= _value;
48         balances[_from] -= _value;
49         balances[_recipient] += _value;
50         Transfer(_from, _recipient, _value);
51         return true;
52     }
53 
54     function balanceOf(address _owner) constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     function approve(address _spender, uint256 _value) returns (bool o_success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {
65         return allowed[_owner][_spender];
66     }
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70     uint256 public totalSupply;
71 
72 }
73 
74 contract GUPToken is StandardToken {
75 
76   //FIELDS
77   //CONSTANTS
78   uint public constant LOCKOUT_PERIOD = 1 years; //time after end date that illiquid GUP can be transferred
79 
80   //ASSIGNED IN INITIALIZATION
81   uint public endMintingTime; //Time in seconds no more tokens can be created
82   address public minter; //address of the account which may mint new tokens
83 
84   mapping (address => uint) public illiquidBalance; //Balance of 'Frozen funds'
85 
86   //MODIFIERS
87   //Can only be called by contribution contract.
88   modifier only_minter {
89     if (msg.sender != minter) throw;
90     _;
91   }
92 
93   // Can only be called if illiquid tokens may be transformed into liquid.
94   // This happens when `LOCKOUT_PERIOD` of time passes after `endMintingTime`.
95   modifier when_thawable {
96     if (now < endMintingTime + LOCKOUT_PERIOD) throw;
97     _;
98   }
99 
100   // Can only be called if (liquid) tokens may be transferred. Happens
101   // immediately after `endMintingTime`.
102   modifier when_transferable {
103     if (now < endMintingTime) throw;
104     _;
105   }
106 
107   // Can only be called if the `crowdfunder` is allowed to mint tokens. Any
108   // time before `endMintingTime`.
109   modifier when_mintable {
110     if (now >= endMintingTime) throw;
111     _;
112   }
113 
114   // Initialization contract assigns address of crowdfund contract and end time.
115   function GUPToken(address _minter, uint _endMintingTime) {
116     endMintingTime = _endMintingTime;
117     minter = _minter;
118   }
119 
120   // Fallback function throws when called.
121   function() {
122     throw;
123   }
124 
125   // Create new tokens when called by the crowdfund contract.
126   // Only callable before the end time.
127   function createToken(address _recipient, uint _value)
128     when_mintable
129     only_minter
130     returns (bool o_success)
131   {
132     balances[_recipient] += _value;
133     totalSupply += _value;
134     return true;
135   }
136 
137   // Create an illiquidBalance which cannot be traded until end of lockout period.
138   // Can only be called by crowdfund contract befor the end time.
139   function createIlliquidToken(address _recipient, uint _value)
140     when_mintable
141     only_minter
142     returns (bool o_success)
143   {
144     illiquidBalance[_recipient] += _value;
145     totalSupply += _value;
146     return true;
147   }
148 
149   // Make sender's illiquid balance liquid when called after lockout period.
150   function makeLiquid()
151     when_thawable
152     returns (bool o_success)
153   {
154     balances[msg.sender] += illiquidBalance[msg.sender];
155     illiquidBalance[msg.sender] = 0;
156     return true;
157   }
158 
159   // Transfer amount of tokens from sender account to recipient.
160   // Only callable after the crowd fund end date.
161   function transfer(address _recipient, uint _amount)
162     when_transferable
163     returns (bool o_success)
164   {
165     return super.transfer(_recipient, _amount);
166   }
167 
168   // Transfer amount of tokens from a specified address to a recipient.
169   // Only callable after the crowd fund end date.
170   function transferFrom(address _from, address _recipient, uint _amount)
171     when_transferable
172     returns (bool o_success)
173   {
174     return super.transferFrom(_from, _recipient, _amount);
175   }
176 }
177 
178 contract SafeMath {
179 
180   function assert(bool assertion) internal {
181     if (!assertion) throw;
182   }
183 
184   function safeMul(uint a, uint b) internal returns (uint) {
185     uint c = a * b;
186     assert(a == 0 || c / a == b);
187     return c;
188   }
189 
190   function safeDiv(uint a, uint b) internal returns (uint) {
191     assert(b > 0);
192     uint c = a / b;
193     assert(a == b * c + a % b);
194     return c;
195   }
196 
197 }
198 
199 contract Contribution is SafeMath {
200 
201   //FIELDS
202 
203   //CONSTANTS
204   //Time limits
205   uint public constant STAGE_ONE_TIME_END = 1 hours;
206   uint public constant STAGE_TWO_TIME_END = 3 days;
207   uint public constant STAGE_THREE_TIME_END = 2 weeks;
208   uint public constant STAGE_FOUR_TIME_END = 4 weeks;
209   //Prices of GUP
210   uint public constant PRICE_STAGE_ONE = 400000;
211   uint public constant PRICE_STAGE_TWO = 366000;
212   uint public constant PRICE_STAGE_THREE = 333000;
213   uint public constant PRICE_STAGE_FOUR = 300000;
214   uint public constant PRICE_BTCS = 400000;
215   //GUP Token Limits
216   uint public constant MAX_SUPPLY =        100000000000;
217   uint public constant ALLOC_ILLIQUID_TEAM = 8000000000;
218   uint public constant ALLOC_LIQUID_TEAM =  13000000000;
219   uint public constant ALLOC_BOUNTIES =      2000000000;
220   uint public constant ALLOC_NEW_USERS =    17000000000;
221   uint public constant ALLOC_CROWDSALE =    60000000000;
222   uint public constant BTCS_PORTION_MAX = 37500 * PRICE_BTCS;
223   //ASSIGNED IN INITIALIZATION
224   //Start and end times
225   uint public publicStartTime = 1490446800; //Time in seconds public crowd fund starts.
226   uint public privateStartTime = 1490432400; //Time in seconds when BTCSuisse can purchase up to 125000 ETH worth of GUP;
227   uint public publicEndTime; //Time in seconds crowdsale ends
228   //Special Addresses
229   address public btcsAddress = 0x00a88EDaA9eAd00A1d114e4820B0B0f2e3651ECE; //Address used by BTCSuisse
230   address public multisigAddress = 0x2CAfdC32aC9eC55e915716bC43037Bd2C689512E; //Address to which all ether flows.
231   address public matchpoolAddress = 0x00ce633b4789D1a16a0aD3AEC58599B76d5D669E; //Address to which ALLOC_BOUNTIES, ALLOC_LIQUID_TEAM, ALLOC_NEW_USERS, ALLOC_ILLIQUID_TEAM is sent to.
232   address public ownerAddress = 0x00ce633b4789D1a16a0aD3AEC58599B76d5D669E; //Address of the contract owner. Can halt the crowdsale.
233   //Contracts
234   GUPToken public gupToken; //External token contract hollding the GUP
235   //Running totals
236   uint public etherRaised; //Total Ether raised.
237   uint public gupSold; //Total GUP created
238   uint public btcsPortionTotal; //Total of Tokens purchased by BTC Suisse. Not to exceed BTCS_PORTION_MAX.
239   //booleans
240   bool public halted; //halts the crowd sale if true.
241 
242   //FUNCTION MODIFIERS
243 
244   //Is currently in the period after the private start time and before the public start time.
245   modifier is_pre_crowdfund_period() {
246     if (now >= publicStartTime || now < privateStartTime) throw;
247     _;
248   }
249 
250   //Is currently the crowdfund period
251   modifier is_crowdfund_period() {
252     if (now < publicStartTime || now >= publicEndTime) throw;
253     _;
254   }
255 
256   //May only be called by BTC Suisse
257   modifier only_btcs() {
258     if (msg.sender != btcsAddress) throw;
259     _;
260   }
261 
262   //May only be called by the owner address
263   modifier only_owner() {
264     if (msg.sender != ownerAddress) throw;
265     _;
266   }
267 
268   //May only be called if the crowdfund has not been halted
269   modifier is_not_halted() {
270     if (halted) throw;
271     _;
272   }
273 
274   // EVENTS
275 
276   event PreBuy(uint _amount);
277   event Buy(address indexed _recipient, uint _amount);
278 
279 
280   // FUNCTIONS
281 
282   //Initialization function. Deploys GUPToken contract assigns values, to all remaining fields, creates first entitlements in the GUP Token contract.
283   function Contribution() {
284     publicEndTime = publicStartTime + STAGE_FOUR_TIME_END;
285     gupToken = new GUPToken(this, publicEndTime);
286     gupToken.createIlliquidToken(matchpoolAddress, ALLOC_ILLIQUID_TEAM);
287     gupToken.createToken(matchpoolAddress, ALLOC_BOUNTIES);
288     gupToken.createToken(matchpoolAddress, ALLOC_LIQUID_TEAM);
289     gupToken.createToken(matchpoolAddress, ALLOC_NEW_USERS);
290   }
291 
292   //May be used by owner of contract to halt crowdsale and no longer except ether.
293   function toggleHalt(bool _halted)
294     only_owner
295   {
296     halted = _halted;
297   }
298 
299   //constant function returns the current GUP price.
300   function getPriceRate()
301     constant
302     returns (uint o_rate)
303   {
304     if (now <= publicStartTime + STAGE_ONE_TIME_END) return PRICE_STAGE_ONE;
305     if (now <= publicStartTime + STAGE_TWO_TIME_END) return PRICE_STAGE_TWO;
306     if (now <= publicStartTime + STAGE_THREE_TIME_END) return PRICE_STAGE_THREE;
307     if (now <= publicStartTime + STAGE_FOUR_TIME_END) return PRICE_STAGE_FOUR;
308     else return 0;
309   }
310 
311   // Given the rate of a purchase and the remaining tokens in this tranche, it
312   // will throw if the sale would take it past the limit of the tranche.
313   // It executes the purchase for the appropriate amount of tokens, which
314   // involves adding it to the total, minting GUP tokens and stashing the
315   // ether.
316   // Returns `amount` in scope as the number of GUP tokens that it will
317   // purchase.
318   function processPurchase(uint _rate, uint _remaining)
319     internal
320     returns (uint o_amount)
321   {
322     o_amount = safeDiv(safeMul(msg.value, _rate), 1 ether);
323     if (o_amount > _remaining) throw;
324     if (!multisigAddress.send(msg.value)) throw;
325     if (!gupToken.createToken(msg.sender, o_amount)) throw; //change to match create token
326     gupSold += o_amount;
327   }
328 
329   //Special Function can only be called by BTC Suisse and only during the pre-crowdsale period.
330   //Allows the purchase of up to 125000 Ether worth of GUP Tokens.
331   function preBuy()
332     payable
333     is_pre_crowdfund_period
334     only_btcs
335     is_not_halted
336   {
337     uint amount = processPurchase(PRICE_BTCS, BTCS_PORTION_MAX - btcsPortionTotal);
338     btcsPortionTotal += amount;
339     PreBuy(amount);
340   }
341 
342   //Default function called by sending Ether to this address with no arguments.
343   //Results in creation of new GUP Tokens if transaction would not exceed hard limit of GUP Token.
344   function()
345     payable
346     is_crowdfund_period
347     is_not_halted
348   {
349     uint amount = processPurchase(getPriceRate(), ALLOC_CROWDSALE - gupSold);
350     Buy(msg.sender, amount);
351   }
352 
353   //failsafe drain
354   function drain()
355     only_owner
356   {
357     if (!ownerAddress.send(this.balance)) throw;
358   }
359 }