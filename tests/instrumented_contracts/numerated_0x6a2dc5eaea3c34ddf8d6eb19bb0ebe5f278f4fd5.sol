1 pragma solidity 0.4.16;
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
97     function mul(uint256 a, uint256 b) internal returns (uint256) {
98       uint256 c = a * b;
99       assert(a == 0 || c / a == b);
100       return c;
101     }
102 
103     function div(uint256 a, uint256 b) internal returns (uint256) {
104       // assert(b > 0); // Solidity automatically throws when dividing by 0
105       uint256 c = a / b;
106       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107       return c;
108     }
109 
110     function sub(uint256 a, uint256 b) internal returns (uint256) {
111       assert(b <= a);
112       return a - b;
113     }
114 
115     function add(uint256 a, uint256 b) internal returns (uint256) {
116       uint256 c = a + b;
117       assert(c >= a);
118       return c;
119     }
120 }
121 
122 contract ShitToken is StandardToken {
123 
124     using SafeMath for uint256;
125 
126     /*
127     *  Metadata
128     */
129     string public constant name = "Shit Utility Token";
130     string public constant symbol = "SHIT";
131     uint8 public constant decimals = 18;
132     uint256 public constant tokenUnit = 10 ** uint256(decimals);
133 
134     /*
135     *  Contract owner (Shit International)
136     */
137     address public owner;
138 
139     /*
140     *  Hardware wallets
141     */
142     address public ethFundAddress;  // Address for ETH owned by Shit International
143     address public shitFundAddress;  // Address for SHIT allocated to Shit International
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
166     uint256 public assignedSupply;  // Total SHIT tokens currently assigned
167     uint256 public tokenExchangeRate;  // Units of SHIT per ETH
168     uint256 public baseTokenCapPerAddress;  // Base user cap in SHIT tokens
169     uint256 public constant baseEthCapPerAddress = 1000000 ether;  // Base user cap in ETH
170     uint256 public constant blocksInFirstCapPeriod = 1;  // Block length for first cap period
171     uint256 public constant blocksInSecondCapPeriod = 1;  // Block length for second cap period
172     uint256 public constant gasLimitInWei = 51000000000 wei; //  Gas price limit during individual cap period 
173     uint256 public constant shitFund = 100 * (10**6) * tokenUnit;  // 100M SHIT reserved for development and user growth fund 
174     uint256 public constant minCap = 1 * tokenUnit;  // 100M min cap to be sold during sale
175 
176     /*
177     *  Events
178     */
179     event RefundSent(address indexed _to, uint256 _value);
180     event ClaimSHIT(address indexed _to, uint256 _value);
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
191     modifier minCapReached() {
192         require(assignedSupply >= minCap);
193         _;
194     }
195 
196     modifier minCapNotReached() {
197         require(assignedSupply < minCap);
198         _;
199     }
200 
201     modifier respectTimeFrame() {
202         require(block.number >= startBlock && block.number < endBlock);
203         _;
204     }
205 
206     modifier salePeriodCompleted() {
207         require(block.number >= endBlock || assignedSupply.add(shitFund) == totalSupply);
208         _;
209     }
210 
211     modifier isValidState() {
212         require(!isFinalized && !isStopped);
213         _;
214     }
215 
216     /*
217     *  Constructor
218     */
219     function ShitToken(
220         address _ethFundAddress,
221         address _shitFundAddress,
222         uint256 _startBlock,
223         uint256 _endBlock,
224         uint256 _tokenExchangeRate) 
225         public 
226     {
227         require(_shitFundAddress != 0x0);
228         require(_ethFundAddress != 0x0);
229         require(_startBlock < _endBlock && _startBlock > block.number);
230 
231         owner = msg.sender; // Creator of contract is owner
232         isFinalized = false; // Controls pre-sale state through crowdsale state
233         isStopped = false;  // Circuit breaker (only to be used by contract owner in case of emergency)
234         ethFundAddress = _ethFundAddress;
235         shitFundAddress = _shitFundAddress;
236         startBlock = _startBlock;
237         endBlock = _endBlock;
238         tokenExchangeRate = _tokenExchangeRate;
239         baseTokenCapPerAddress = baseEthCapPerAddress.mul(tokenExchangeRate);
240         firstCapEndingBlock = startBlock.add(blocksInFirstCapPeriod);
241         secondCapEndingBlock = firstCapEndingBlock.add(blocksInSecondCapPeriod);
242         totalSupply = 1000 * (10**6) * tokenUnit;  // 1B total SHIT tokens
243         assignedSupply = 0;  // Set starting assigned supply to 0
244     }
245 
246     /// @notice Stop sale in case of emergency (i.e. circuit breaker)
247     /// @dev Only allowed to be called by the owner
248     function stopSale() onlyBy(owner) external {
249         isStopped = true;
250     }
251 
252     /// @notice Restart sale in case of an emergency stop
253     /// @dev Only allowed to be called by the owner
254     function restartSale() onlyBy(owner) external {
255         isStopped = false;
256     }
257 
258     /// @dev Fallback function can be used to buy tokens
259     function () payable public {
260         claimTokens();
261     }
262 
263     /// @notice Create `msg.value` ETH worth of SHIT
264     /// @dev Only allowed to be called within the timeframe of the sale period
265     function claimTokens() respectTimeFrame isValidState payable public {
266         require(msg.value > 0);
267 
268         uint256 tokens = msg.value.mul(tokenExchangeRate);
269 
270         require(isWithinCap(tokens));
271 
272         // Check that we're not over totals
273         uint256 checkedSupply = assignedSupply.add(tokens);
274 
275         // Return money if we're over total token supply
276         require(checkedSupply.add(shitFund) <= totalSupply); 
277 
278         balances[msg.sender] = balances[msg.sender].add(tokens);
279         purchases[msg.sender] = purchases[msg.sender].add(tokens);
280 
281         assignedSupply = checkedSupply;
282         ClaimSHIT(msg.sender, tokens);  // Logs token creation for UI purposes
283         // As per ERC20 spec, a token contract which creates new tokens SHOULD trigger a Transfer event with the _from address
284         // set to 0x0 when tokens are created (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
285         Transfer(0x0, msg.sender, tokens);
286     }
287 
288     /// @dev Checks if transaction meets individual cap requirements
289     function isWithinCap(uint256 tokens) internal view returns (bool) {
290         // Return true if we've passed the cap period
291         if (block.number >= secondCapEndingBlock) {
292             return true;
293         }
294 
295         // Ensure user is under gas limit
296         require(tx.gasprice <= gasLimitInWei);
297         
298         // Ensure user is not purchasing more tokens than allowed
299         if (block.number < firstCapEndingBlock) {
300             return purchases[msg.sender].add(tokens) <= baseTokenCapPerAddress;
301         } else {
302             return purchases[msg.sender].add(tokens) <= baseTokenCapPerAddress.mul(4);
303         }
304     }
305 
306 
307     /// @notice Updates registration status of an address for sale participation
308     /// @param target Address that will be registered or deregistered
309     /// @param isRegistered New registration status of address
310     function changeRegistrationStatus(address target, bool isRegistered) public onlyBy(owner) {
311         registered[target] = isRegistered;
312     }
313 
314     /// @notice Updates registration status for multiple addresses for participation
315     /// @param targets Addresses that will be registered or deregistered
316     /// @param isRegistered New registration status of addresses
317     function changeRegistrationStatuses(address[] targets, bool isRegistered) public onlyBy(owner) {
318         for (uint i = 0; i < targets.length; i++) {
319             changeRegistrationStatus(targets[i], isRegistered);
320         }
321     }
322 
323     /// @notice Sends the ETH to ETH fund wallet and finalizes the token sale
324     function finalize() minCapReached salePeriodCompleted isValidState onlyBy(owner) external {
325         // Upon successful completion of sale, send tokens to SHIT fund
326         balances[shitFundAddress] = balances[shitFundAddress].add(shitFund);
327         assignedSupply = assignedSupply.add(shitFund);
328         ClaimSHIT(shitFundAddress, shitFund);   // Log tokens claimed by SHIT International SHIT fund
329         Transfer(0x0, shitFundAddress, shitFund);
330         
331         // In the case where not all 100M Shit allocated to crowdfund participants
332         // is sold, send the remaining unassigned supply to Shit fund address,
333         // which will then be used to fund the user growth pool.
334         if (assignedSupply < totalSupply) {
335             uint256 unassignedSupply = totalSupply.sub(assignedSupply);
336             balances[shitFundAddress] = balances[shitFundAddress].add(unassignedSupply);
337             assignedSupply = assignedSupply.add(unassignedSupply);
338 
339             ClaimSHIT(shitFundAddress, unassignedSupply);  // Log tokens claimed by Shit International SHIT fund
340             Transfer(0x0, shitFundAddress, unassignedSupply);
341         }
342 
343         ethFundAddress.transfer(this.balance);
344 
345         isFinalized = true; // Finalize sale
346     }
347 
348     /// @notice Allows contributors to recover their ETH in the case of a failed token sale
349     /// @dev Only allowed to be called once sale period is over IF the min cap is not reached
350     /// @return bool True if refund successfully sent, false otherwise
351     function refund() minCapNotReached salePeriodCompleted isValidState external {
352         require(msg.sender != shitFundAddress);  // Shit International not entitled to a refund
353 
354         uint256 shitVal = balances[msg.sender];
355         require(shitVal > 0); // Prevent refund if sender Shit balance is 0
356 
357         balances[msg.sender] = balances[msg.sender].sub(shitVal);
358         assignedSupply = assignedSupply.sub(shitVal); // Adjust assigned supply to account for refunded amount
359         
360         uint256 ethVal = shitVal.div(tokenExchangeRate); // Covert Shit to ETH
361 
362         msg.sender.transfer(ethVal);
363         
364         RefundSent(msg.sender, ethVal);  // Log successful refund 
365     }
366 
367     /*
368         NOTE: We explicitly do not define a fallback function, in order to prevent 
369         receiving Ether for no reason. As noted in Solidity documentation, contracts 
370         that receive Ether directly (without a function call, i.e. using send or transfer)
371         but do not define a fallback function throw an exception, sending back the Ether (this was different before Solidity v0.4.0).
372     */
373 }