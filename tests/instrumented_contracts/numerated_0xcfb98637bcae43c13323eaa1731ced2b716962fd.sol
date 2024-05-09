1 pragma solidity ^0.4.11;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
7         uint256 z = x + y;
8         assert((z >= x) && (z >= y));
9         return z;
10     }
11 
12     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
13         assert(x >= y);
14         uint256 z = x - y;
15         return z;
16     }
17 
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19         uint256 z = x * y;
20         assert((x == 0)||(z/x == y));
21         return z;
22     }
23 }
24 
25 contract Token {
26     uint256 public totalSupply;
27 
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 /*  ERC 20 token */
39 contract StandardToken is Token, SafeMath {
40 
41     mapping (address => uint256) balances;
42     mapping (address => mapping (address => uint256)) allowed;
43 
44     modifier onlyPayloadSize(uint numwords) {
45         assert(msg.data.length == numwords * 32 + 4);
46         _;
47     }
48 
49     function transfer(address _to, uint256 _value)
50     returns (bool success)
51     {
52         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
53             balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
54             balances[_to] = safeAdd(balances[_to], _value);
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else {
58             return false;
59         }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value)
63     returns (bool success)
64     {
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
66             balances[_to] = safeAdd(balances[_to], _value);
67             balances[_from] = safeSubtract(balances[_from], _value);
68             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
69             Transfer(_from, _to, _value);
70             return true;
71         } else {
72             return false;
73         }
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value)
81     onlyPayloadSize(2)
82     returns (bool success)
83     {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender)
90     constant
91     onlyPayloadSize(2)
92     returns (uint256 remaining)
93     {
94         return allowed[_owner][_spender];
95     }
96 }
97 
98 /* Taking ideas from BAT token */
99 contract NEToken is StandardToken {
100 
101     // Token metadata
102     string public constant name = "Nimiq Network Interim Token";
103     string public constant symbol = "NET";
104     uint256 public constant decimals = 18;
105     string public version = "0.8";
106 
107     // Deposit address of Multisig account controlled by the creators
108     address public ethFundDeposit;
109 
110     // Fundraising parameters
111     enum ContractState { Fundraising, Finalized, Redeeming, Paused }
112     ContractState public state;           // Current state of the contract
113     ContractState private savedState;     // State of the contract before pause
114 
115     uint256 public fundingStartBlock;        // These two blocks need to be chosen to comply with the
116     uint256 public fundingEndBlock;          // start date and 28 day duration requirements
117     uint256 public exchangeRateChangesBlock; // block number that triggers the exchange rate change
118 
119     uint256 public constant TOKEN_FIRST_EXCHANGE_RATE = 175; // 175 NETs per 1 ETH
120     uint256 public constant TOKEN_SECOND_EXCHANGE_RATE = 125; // 125 NETs per 1 ETH
121     uint256 public constant TOKEN_CREATION_CAP = 10.5 * (10**6) * 10**decimals; // 10.5 million NETs
122     uint256 public constant ETH_RECEIVED_CAP = 60 * (10**3) * 10**decimals; // 60 000 ETH
123     uint256 public constant ETH_RECEIVED_MIN = 5 * (10**3) * 10**decimals; // 5 000 ETH
124     uint256 public constant TOKEN_MIN = 1 * 10**decimals; // 1 NET
125 
126     // We need to keep track of how much ether have been contributed, since we have a cap for ETH too
127     uint256 public totalReceivedEth = 0;
128 
129     // Since we have different exchange rates at different stages, we need to keep track
130     // of how much ether each contributed in case that we need to issue a refund
131     mapping (address => uint256) private ethBalances;
132 
133     // Events used for logging
134     event LogRefund(address indexed _to, uint256 _value);
135     event LogCreateNET(address indexed _to, uint256 _value);
136     event LogRedeemNET(address indexed _to, uint256 _value, bytes32 _nimiqAddress);
137 
138     modifier isFinalized() {
139         require(state == ContractState.Finalized);
140         _;
141     }
142 
143     modifier isFundraising() {
144         require(state == ContractState.Fundraising);
145         _;
146     }
147 
148     modifier isRedeeming() {
149         require(state == ContractState.Redeeming);
150         _;
151     }
152 
153     modifier isPaused() {
154         require(state == ContractState.Paused);
155         _;
156     }
157 
158     modifier notPaused() {
159         require(state != ContractState.Paused);
160         _;
161     }
162 
163     modifier isFundraisingIgnorePaused() {
164         require(state == ContractState.Fundraising || (state == ContractState.Paused && savedState == ContractState.Fundraising));
165         _;
166     }
167 
168     modifier onlyOwner() {
169         require(msg.sender == ethFundDeposit);
170         _;
171     }
172 
173     modifier minimumReached() {
174         require(totalReceivedEth >= ETH_RECEIVED_MIN);
175         _;
176     }
177 
178     // Constructor
179     function NEToken(
180     address _ethFundDeposit,
181     uint256 _fundingStartBlock,
182     uint256 _fundingEndBlock,
183     uint256 _exchangeRateChangesBlock)
184     {
185         // Check that the parameters make sense
186         require(block.number <= _fundingStartBlock); // The start of the fundraising should happen in the future
187         require(_fundingStartBlock <= _exchangeRateChangesBlock); // The exchange rate change should happen after the start of the fundraising
188         require(_exchangeRateChangesBlock <= _fundingEndBlock); // And the end of the fundraising should happen after the exchange rate change
189 
190         // Contract state
191         state = ContractState.Fundraising;
192         savedState = ContractState.Fundraising;
193 
194         ethFundDeposit = _ethFundDeposit;
195         fundingStartBlock = _fundingStartBlock;
196         fundingEndBlock = _fundingEndBlock;
197         exchangeRateChangesBlock = _exchangeRateChangesBlock;
198         totalSupply = 0;
199     }
200 
201     // Overridden method to check for end of fundraising before allowing transfer of tokens
202     function transfer(address _to, uint256 _value)
203     isFinalized // Only allow token transfer after the fundraising has ended
204     onlyPayloadSize(2)
205     returns (bool success)
206     {
207         return super.transfer(_to, _value);
208     }
209 
210 
211     // Overridden method to check for end of fundraising before allowing transfer of tokens
212     function transferFrom(address _from, address _to, uint256 _value)
213     isFinalized // Only allow token transfer after the fundraising has ended
214     onlyPayloadSize(3)
215     returns (bool success)
216     {
217         return super.transferFrom(_from, _to, _value);
218     }
219 
220 
221     /// @dev Accepts ether and creates new NET tokens
222     function createTokens()
223     payable
224     external
225     isFundraising
226     {
227         require(block.number >= fundingStartBlock);
228         require(block.number <= fundingEndBlock);
229         require(msg.value > 0);
230 
231         // First we check the ETH cap, as it's easier to calculate, return
232         // the contribution if the cap has been reached already
233         uint256 checkedReceivedEth = safeAdd(totalReceivedEth, msg.value);
234         require(checkedReceivedEth <= ETH_RECEIVED_CAP);
235 
236         // If all is fine with the ETH cap, we continue to check the
237         // minimum amount of tokens and the cap for how many tokens
238         // have been generated so far
239         uint256 tokens = safeMult(msg.value, getCurrentTokenPrice());
240         require(tokens >= TOKEN_MIN);
241         uint256 checkedSupply = safeAdd(totalSupply, tokens);
242         require(checkedSupply <= TOKEN_CREATION_CAP);
243 
244         // Only when all the checks have passed, then we update the state (ethBalances,
245         // totalReceivedEth, totalSupply, and balances) of the contract
246         ethBalances[msg.sender] = safeAdd(ethBalances[msg.sender], msg.value);
247         totalReceivedEth = checkedReceivedEth;
248         totalSupply = checkedSupply;
249         balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
250 
251         // Log the creation of this tokens
252         LogCreateNET(msg.sender, tokens);
253     }
254 
255 
256     /// @dev Returns the current token price
257     function getCurrentTokenPrice()
258     private
259     constant
260     returns (uint256 currentPrice)
261     {
262         if (block.number < exchangeRateChangesBlock) {
263             return TOKEN_FIRST_EXCHANGE_RATE;
264         } else {
265             return TOKEN_SECOND_EXCHANGE_RATE;
266         }
267     }
268 
269 
270     /// @dev Redeems NETs and records the Nimiq address of the sender
271     function redeemTokens(bytes32 nimiqAddress)
272     external
273     isRedeeming
274     {
275         uint256 netVal = balances[msg.sender];
276         require(netVal >= TOKEN_MIN); // At least TOKEN_MIN tokens have to be redeemed
277 
278         // Move the tokens of the caller to Nimiq's address
279         if (!super.transfer(ethFundDeposit, netVal)) throw;
280 
281         // Log the redeeming of this tokens
282         LogRedeemNET(msg.sender, netVal, nimiqAddress);
283     }
284 
285 
286     /// @dev Allows to transfer ether from the contract as soon as the minimum is reached
287     function retrieveEth(uint256 _value)
288     external
289     minimumReached
290     onlyOwner
291     {
292         require(_value <= this.balance);
293 
294         // send the eth to Nimiq Creators
295         ethFundDeposit.transfer(_value);
296     }
297 
298 
299     /// @dev Ends the fundraising period and sends the ETH to the Multisig wallet
300     function finalize()
301     external
302     isFundraising
303     minimumReached
304     onlyOwner // Only the owner of the ethFundDeposit address can finalize the contract
305     {
306         require(block.number > fundingEndBlock || totalSupply >= TOKEN_CREATION_CAP || totalReceivedEth >= ETH_RECEIVED_CAP); // Only allow to finalize the contract before the ending block if we already reached any of the two caps
307 
308         // Move the contract to Finalized state
309         state = ContractState.Finalized;
310         savedState = ContractState.Finalized;
311 
312         // Send the ETH to Nimiq Creators
313         ethFundDeposit.transfer(this.balance);
314     }
315 
316 
317     /// @dev Starts the redeeming period
318     function startRedeeming()
319     external
320     isFinalized // The redeeming period can only be started after the contract is finalized
321     onlyOwner   // Only the owner of the ethFundDeposit address can start the redeeming period
322     {
323         // Move the contract to Redeeming state
324         state = ContractState.Redeeming;
325         savedState = ContractState.Redeeming;
326     }
327 
328 
329     /// @dev Pauses the contract
330     function pause()
331     external
332     notPaused   // Prevent the contract getting stuck in the Paused state
333     onlyOwner   // Only the owner of the ethFundDeposit address can pause the contract
334     {
335         // Move the contract to Paused state
336         savedState = state;
337         state = ContractState.Paused;
338     }
339 
340 
341     /// @dev Proceeds with the contract
342     function proceed()
343     external
344     isPaused
345     onlyOwner   // Only the owner of the ethFundDeposit address can proceed with the contract
346     {
347         // Move the contract to the previous state
348         state = savedState;
349     }
350 
351 
352     /// @dev Allows contributors to recover their ether in case the minimum funding goal is not reached
353     function refund()
354     external
355     isFundraisingIgnorePaused // Refunding is only possible in the fundraising phase (no matter if paused) by definition
356     {
357         require(block.number > fundingEndBlock); // Prevents refund until fundraising period is over
358         require(totalReceivedEth < ETH_RECEIVED_MIN);  // No refunds if the minimum has been reached
359 
360         uint256 netVal = balances[msg.sender];
361         require(netVal > 0);
362         uint256 ethVal = ethBalances[msg.sender];
363         require(ethVal > 0);
364 
365         // Update the state only after all the checks have passed
366         balances[msg.sender] = 0;
367         ethBalances[msg.sender] = 0;
368         totalSupply = safeSubtract(totalSupply, netVal); // Extra safe
369 
370         // Log this refund
371         LogRefund(msg.sender, ethVal);
372 
373         // Send the contributions only after we have updated all the balances
374         // If you're using a contract, make sure it works with .transfer() gas limits
375         msg.sender.transfer(ethVal);
376     }
377 }