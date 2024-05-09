1 pragma solidity 0.4.17;
2 
3 contract Token {
4 
5     /* Total amount of tokens */
6     uint256 public totalSupply;
7 
8     /*
9      * Events
10      */
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 
14     /*
15      * Public functions
16      */
17 
18     /// @notice send `value` token to `to` from `msg.sender`
19     /// @param to The address of the recipient
20     /// @param value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address to, uint value) public returns (bool);
23 
24     /// @notice send `value` token to `to` from `from` on the condition it is approved by `from`
25     /// @param from The address of the sender
26     /// @param to The address of the recipient
27     /// @param value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address from, address to, uint value) public returns (bool);
30 
31     /// @notice `msg.sender` approves `spender` to spend `value` tokens
32     /// @param spender The address of the account able to transfer the tokens
33     /// @param value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address spender, uint value) public returns (bool);
36 
37     /// @param owner The address from which the balance will be retrieved
38     /// @return The balance
39     function balanceOf(address owner) public constant returns (uint);
40 
41     /// @param owner The address of the account owning tokens
42     /// @param spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address owner, address spender) public constant returns (uint);
45 }
46 
47 contract StandardToken is Token {
48     /*
49      *  Storage
50     */
51     mapping (address => uint) balances;
52     mapping (address => mapping (address => uint)) allowances;
53 
54     /*
55      *  Public functions
56     */
57 
58     function transfer(address to, uint value) public returns (bool) {
59         // Do not allow transfer to 0x0 or the token contract itself
60         require((to != 0x0) && (to != address(this)));
61         if (balances[msg.sender] < value)
62             revert();  // Balance too low
63         balances[msg.sender] -= value;
64         balances[to] += value;
65         Transfer(msg.sender, to, value);
66         return true;
67     }
68 
69     function transferFrom(address from, address to, uint value) public returns (bool) {
70         // Do not allow transfer to 0x0 or the token contract itself
71         require((to != 0x0) && (to != address(this)));
72         if (balances[from] < value || allowances[from][msg.sender] < value)
73             revert(); // Balance or allowance too low
74         balances[to] += value;
75         balances[from] -= value;
76         allowances[from][msg.sender] -= value;
77         Transfer(from, to, value);
78         return true;
79     }
80 
81     function approve(address spender, uint value) public returns (bool) {
82         allowances[msg.sender][spender] = value;
83         Approval(msg.sender, spender, value);
84         return true;
85     }
86 
87     function allowance(address owner, address spender) public constant returns (uint) {
88         return allowances[owner][spender];
89     }
90 
91     function balanceOf(address owner) public constant returns (uint) {
92         return balances[owner];
93     }
94 }
95 
96 library SafeMath {
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98       uint256 c = a * b;
99       assert(a == 0 || c / a == b);
100       return c;
101     }
102 
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104       // assert(b > 0); // Solidity automatically throws when dividing by 0
105       uint256 c = a / b;
106       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107       return c;
108     }
109 
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111       assert(b <= a);
112       return a - b;
113     }
114 
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116       uint256 c = a + b;
117       assert(c >= a);
118       return c;
119     }
120 }
121 
122 contract GMToken is StandardToken {
123 
124     using SafeMath for uint256;
125 
126     /*
127     *  Metadata
128     */
129     string public constant name = "Global Messaging Token";
130     string public constant symbol = "GMT";
131     uint8 public constant decimals = 18;
132     uint256 public constant tokenUnit = 10 ** uint256(decimals);
133 
134     /*
135     *  Contract owner (Radical App International)
136     */
137     address public owner;
138 
139     /*
140     *  Hardware wallets
141     */
142     address public ethFundAddress;  // Address for ETH owned by Radical App International
143     address public gmtFundAddress;  // Address for GMT allocated to Radical App International
144 
145     /*
146     *  List of registered participants
147     */
148     mapping (address => bool) public registered;
149 
150     /*
151     *  List of token purchases per address
152     *  Same as balances[], except used for individual cap calculations, 
153     *  because users can transfer tokens out during sale and reset token count in balances.
154     */
155     mapping (address => uint) public purchases;
156 
157     /*
158     *  Crowdsale parameters
159     */
160     bool public isFinalized;
161     bool public isStopped;
162     uint256 public startBlock;  // Block number when sale period begins
163     uint256 public endBlock;  // Block number when sale period ends
164     uint256 public firstCapEndingBlock;  // Block number when first individual user cap period ends
165     uint256 public secondCapEndingBlock;  // Block number when second individual user cap period ends
166     uint256 public assignedSupply;  // Total GMT tokens currently assigned
167     uint256 public tokenExchangeRate;  // Units of GMT per ETH
168     uint256 public baseTokenCapPerAddress;  // Base user cap in GMT tokens
169     uint256 public constant baseEthCapPerAddress = 7 ether;  // Base user cap in ETH
170     uint256 public constant blocksInFirstCapPeriod = 2105;  // Block length for first cap period
171     uint256 public constant blocksInSecondCapPeriod = 1052;  // Block length for second cap period
172     uint256 public constant gasLimitInWei = 51000000000 wei; //  Gas price limit during individual cap period 
173     uint256 public constant gmtFund = 500 * (10**6) * tokenUnit;  // 500M GMT reserved for development and user growth fund 
174     uint256 public constant minCap = 100 * (10**6) * tokenUnit;  // 100M min cap to be sold during sale
175 
176     /*
177     *  Events
178     */
179     event RefundSent(address indexed _to, uint256 _value);
180     event ClaimGMT(address indexed _to, uint256 _value);
181 
182     modifier onlyBy(address _account){
183         require(msg.sender == _account);  
184         _;
185     }
186 
187     function changeOwner(address _newOwner) onlyBy(owner) external {
188         owner = _newOwner;
189     }
190 
191     modifier registeredUser() {
192         require(registered[msg.sender] == true);  
193         _;
194     }
195 
196     modifier minCapReached() {
197         require(assignedSupply >= minCap);
198         _;
199     }
200 
201     modifier minCapNotReached() {
202         require(assignedSupply < minCap);
203         _;
204     }
205 
206     modifier respectTimeFrame() {
207         require(block.number >= startBlock && block.number < endBlock);
208         _;
209     }
210 
211     modifier salePeriodCompleted() {
212         require(block.number >= endBlock || assignedSupply.add(gmtFund) == totalSupply);
213         _;
214     }
215 
216     modifier isValidState() {
217         require(!isFinalized && !isStopped);
218         _;
219     }
220 
221     /*
222     *  Constructor
223     */
224     function GMToken(
225         address _ethFundAddress,
226         address _gmtFundAddress,
227         uint256 _startBlock,
228         uint256 _endBlock,
229         uint256 _tokenExchangeRate) 
230         public 
231     {
232         require(_gmtFundAddress != 0x0);
233         require(_ethFundAddress != 0x0);
234         require(_startBlock < _endBlock && _startBlock > block.number);
235 
236         owner = msg.sender; // Creator of contract is owner
237         isFinalized = false; // Controls pre-sale state through crowdsale state
238         isStopped = false;  // Circuit breaker (only to be used by contract owner in case of emergency)
239         ethFundAddress = _ethFundAddress;
240         gmtFundAddress = _gmtFundAddress;
241         startBlock = _startBlock;
242         endBlock = _endBlock;
243         tokenExchangeRate = _tokenExchangeRate;
244         baseTokenCapPerAddress = baseEthCapPerAddress.mul(tokenExchangeRate);
245         firstCapEndingBlock = startBlock.add(blocksInFirstCapPeriod);
246         secondCapEndingBlock = firstCapEndingBlock.add(blocksInSecondCapPeriod);
247         totalSupply = 1000 * (10**6) * tokenUnit;  // 1B total GMT tokens
248         assignedSupply = 0;  // Set starting assigned supply to 0
249     }
250 
251     /// @notice Stop sale in case of emergency (i.e. circuit breaker)
252     /// @dev Only allowed to be called by the owner
253     function stopSale() onlyBy(owner) external {
254         isStopped = true;
255     }
256 
257     /// @notice Restart sale in case of an emergency stop
258     /// @dev Only allowed to be called by the owner
259     function restartSale() onlyBy(owner) external {
260         isStopped = false;
261     }
262 
263     /// @dev Fallback function can be used to buy tokens
264     function () payable public {
265         claimTokens();
266     }
267 
268     /// @notice Create `msg.value` ETH worth of GMT
269     /// @dev Only allowed to be called within the timeframe of the sale period
270     function claimTokens() respectTimeFrame registeredUser isValidState payable public {
271         require(msg.value > 0);
272 
273         uint256 tokens = msg.value.mul(tokenExchangeRate);
274 
275         require(isWithinCap(tokens));
276 
277         // Check that we're not over totals
278         uint256 checkedSupply = assignedSupply.add(tokens);
279 
280         // Return money if we're over total token supply
281         require(checkedSupply.add(gmtFund) <= totalSupply); 
282 
283         balances[msg.sender] = balances[msg.sender].add(tokens);
284         purchases[msg.sender] = purchases[msg.sender].add(tokens);
285 
286         assignedSupply = checkedSupply;
287         ClaimGMT(msg.sender, tokens);  // Logs token creation for UI purposes
288         // As per ERC20 spec, a token contract which creates new tokens SHOULD trigger a Transfer event with the _from address
289         // set to 0x0 when tokens are created (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
290         Transfer(0x0, msg.sender, tokens);
291     }
292 
293     /// @dev Checks if transaction meets individual cap requirements
294     function isWithinCap(uint256 tokens) internal view returns (bool) {
295         // Return true if we've passed the cap period
296         if (block.number >= secondCapEndingBlock) {
297             return true;
298         }
299 
300         // Ensure user is under gas limit
301         require(tx.gasprice <= gasLimitInWei);
302         
303         // Ensure user is not purchasing more tokens than allowed
304         if (block.number < firstCapEndingBlock) {
305             return purchases[msg.sender].add(tokens) <= baseTokenCapPerAddress;
306         } else {
307             return purchases[msg.sender].add(tokens) <= baseTokenCapPerAddress.mul(4);
308         }
309     }
310 
311 
312     /// @notice Updates registration status of an address for sale participation
313     /// @param target Address that will be registered or deregistered
314     /// @param isRegistered New registration status of address
315     function changeRegistrationStatus(address target, bool isRegistered) public onlyBy(owner) {
316         registered[target] = isRegistered;
317     }
318 
319     /// @notice Updates registration status for multiple addresses for participation
320     /// @param targets Addresses that will be registered or deregistered
321     /// @param isRegistered New registration status of addresses
322     function changeRegistrationStatuses(address[] targets, bool isRegistered) public onlyBy(owner) {
323         for (uint i = 0; i < targets.length; i++) {
324             changeRegistrationStatus(targets[i], isRegistered);
325         }
326     }
327 
328     /// @notice Sends the ETH to ETH fund wallet and finalizes the token sale
329     function finalize() minCapReached salePeriodCompleted isValidState onlyBy(owner) external {
330         // Upon successful completion of sale, send tokens to GMT fund
331         balances[gmtFundAddress] = balances[gmtFundAddress].add(gmtFund);
332         assignedSupply = assignedSupply.add(gmtFund);
333         ClaimGMT(gmtFundAddress, gmtFund);   // Log tokens claimed by Radical App International GMT fund
334         Transfer(0x0, gmtFundAddress, gmtFund);
335         
336         // In the case where not all 500M GMT allocated to crowdfund participants
337         // is sold, send the remaining unassigned supply to GMT fund address,
338         // which will then be used to fund the user growth pool.
339         if (assignedSupply < totalSupply) {
340             uint256 unassignedSupply = totalSupply.sub(assignedSupply);
341             balances[gmtFundAddress] = balances[gmtFundAddress].add(unassignedSupply);
342             assignedSupply = assignedSupply.add(unassignedSupply);
343 
344             ClaimGMT(gmtFundAddress, unassignedSupply);  // Log tokens claimed by Radical App International GMT fund
345             Transfer(0x0, gmtFundAddress, unassignedSupply);
346         }
347 
348         ethFundAddress.transfer(this.balance);
349 
350         isFinalized = true; // Finalize sale
351     }
352 
353     /// @notice Allows contributors to recover their ETH in the case of a failed token sale
354     /// @dev Only allowed to be called once sale period is over IF the min cap is not reached
355     /// @return bool True if refund successfully sent, false otherwise
356     function refund() minCapNotReached salePeriodCompleted registeredUser isValidState external {
357         require(msg.sender != gmtFundAddress);  // Radical App International not entitled to a refund
358 
359         uint256 gmtVal = balances[msg.sender];
360         require(gmtVal > 0); // Prevent refund if sender GMT balance is 0
361 
362         balances[msg.sender] = balances[msg.sender].sub(gmtVal);
363         assignedSupply = assignedSupply.sub(gmtVal); // Adjust assigned supply to account for refunded amount
364         
365         uint256 ethVal = gmtVal.div(tokenExchangeRate); // Covert GMT to ETH
366 
367         msg.sender.transfer(ethVal);
368         
369         RefundSent(msg.sender, ethVal);  // Log successful refund 
370     }
371 
372     /*
373         NOTE: We explicitly do not define a fallback function, in order to prevent 
374         receiving Ether for no reason. As noted in Solidity documentation, contracts 
375         that receive Ether directly (without a function call, i.e. using send or transfer)
376         but do not define a fallback function throw an exception, sending back the Ether (this was different before Solidity v0.4.0).
377     */
378 }