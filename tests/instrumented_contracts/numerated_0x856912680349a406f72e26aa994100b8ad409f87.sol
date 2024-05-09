1 pragma solidity ^0.4.15;
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
62         revert();  // Balance too low
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
73         revert(); // Balance or allowance too low
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
98         uint256 c = a * b;
99         assert(a == 0 || c / a == b);
100         return c;
101     }
102 
103     function div(uint256 a, uint256 b) internal returns (uint256) {
104         // assert(b > 0); // Solidity automatically throws when dividing by 0
105         uint256 c = a / b;
106         assert(a == b * c + a % b);
107         return c;
108     }
109 
110     function sub(uint256 a, uint256 b) internal returns (uint256) {
111         assert(b <= a);
112         return a - b;
113     }
114 
115     function add(uint256 a, uint256 b) internal returns (uint256) {
116         uint256 c = a + b;
117         assert(c >= a);
118         return c;
119     }
120 }
121 
122 contract EtherSport is StandardToken {
123     using SafeMath for uint256;
124 
125     /*
126      *  Metadata
127      */
128     string public constant name = "Ether Sport";
129     string public constant symbol = "ESC";
130     uint8 public constant decimals = 18;
131     uint256 public constant tokenUnit = 10 ** uint256(decimals);
132 
133     /*
134      *  Contract owner (Ethersport)
135      */
136     address public owner;
137 
138     /*
139      *  Hardware wallets
140      */
141     address public ethFundAddress;  // Address for ETH owned by Ethersport
142     address public escFundAddress;  // Address for ESC allocated to Ethersport
143 
144     /*
145         *  List of token purchases per address
146         *  Same as balances[], except used for individual cap calculations,
147         *  because users can transfer tokens out during sale and reset token count in balances.
148         */
149     mapping (address => uint256) public purchases;
150     mapping (uint => address) public allocationsIndex;
151     mapping (address => uint256) public allocations;
152     uint public allocationsLength;
153     mapping (string => mapping (string => uint256)) cd; //crowdsaleData;
154 
155     /*
156     *  Crowdsale parameters
157     */
158     bool public isFinalized;
159     bool public isStopped;
160     uint256 public startBlock;  // Block number when sale period begins
161     uint256 public endBlock;  // Block number when sale period ends
162     uint256 public assignedSupply;  // Total ESC tokens currently assigned
163     uint256 public constant minimumPayment = 5 * (10**14); // 0.0005 ETH
164     uint256 public constant escFund = 40 * (10**6) * tokenUnit;  // 40M ESC reserved for development and user growth fund
165 
166     /*
167     *  Events
168     */
169     event ClaimESC(address indexed _to, uint256 _value);
170 
171     modifier onlyBy(address _account){
172         require(msg.sender == _account);
173         _;
174     }
175 
176     function changeOwner(address _newOwner) onlyBy(owner) external {
177         owner = _newOwner;
178     }
179 
180     modifier respectTimeFrame() {
181         require(block.number >= startBlock);
182         require(block.number < endBlock);
183         _;
184     }
185 
186     modifier salePeriodCompleted() {
187         require(block.number >= endBlock || assignedSupply.add(escFund).add(minimumPayment) > totalSupply);
188         _;
189     }
190 
191     modifier isValidState() {
192         require(!isFinalized && !isStopped);
193         _;
194     }
195 
196     function allocate(address _escAddress, uint token) internal {
197         allocationsIndex[allocationsLength] = _escAddress;
198         allocations[_escAddress] = token;
199         allocationsLength = allocationsLength + 1;
200     }
201     /*
202      *  Constructor
203      */
204     function EtherSport(
205     address _ethFundAddress,
206     uint256 _startBlock,
207     uint256 _preIcoHeight,
208     uint256 _stage1Height,
209     uint256 _stage2Height,
210     uint256 _stage3Height,
211     uint256 _stage4Height,
212     uint256 _endBlockHeight
213     )
214     public
215     {
216         require(_ethFundAddress != 0x0);
217         require(_startBlock > block.number);
218 
219         owner = msg.sender; // Creator of contract is owner
220         isFinalized = false; // Controls pre-sale state through crowdsale state
221         isStopped   = false; // Circuit breaker (only to be used by contract owner in case of emergency)
222         ethFundAddress = _ethFundAddress;
223         totalSupply    = 100 * (10**6) * tokenUnit;  // 100M total ESC tokens
224         assignedSupply = 0;  // Set starting assigned supply to 0
225         //  Stages  |Duration| Start date           | End date             | Amount of       | Price per    | Amount of tokens | Minimum     |
226         //          |        |                      |                      | tokens for sale | token in ETH | per 1 ETH        | payment ETH |
227         //  --------|--------|----------------------|----------------------|-----------------|--------------|------------------|-------------|
228         //  Pre ICO | 1 week | 13.11.2017 12:00 UTC | 19.11.2017 12:00 UTC | 10,000,000      | 0.00050      | 2000.00          | 0.0005      |
229         //  1 stage | 1 hour | 21.11.2017 12:00 UTC | 21.11.2017 13:00 UTC | 10,000,000      | 0.00100      | 1000.00          | 0.0005      |
230         //  2 stage | 1 day  | 22.11.2017 13:00 UTC | 29.11.2017 13:00 UTC | 15,000,000      | 0.00130      | 769.23           | 0.0005      |
231         //  3 stage | 1 week | 22.11.2017 13:00 UTC | 29.11.2017 13:00 UTC | 15,000,000      | 0.00170      | 588.24           | 0.0005      |
232         //  4 stage | 3 weeks| 29.11.2017 13:00 UTC | 20.12.2017 13:00 UTC | 20,000,000      | 0.00200      | 500.00           | 0.0005      |
233         //  --------|--------|----------------------|----------------------|-----------------|--------------|------------------|-------------|
234         //                                                                 | 70,000,000      |
235         cd['preIco']['startBlock'] = _startBlock;                 cd['preIco']['endBlock'] = _startBlock + _preIcoHeight;     cd['preIco']['cap'] = 10 * 10**6 * 10**18; cd['preIco']['exRate'] = 200000;
236         cd['stage1']['startBlock'] = _startBlock + _stage1Height; cd['stage1']['endBlock'] = _startBlock + _stage2Height - 1; cd['stage1']['cap'] = 10 * 10**6 * 10**18; cd['stage1']['exRate'] = 100000;
237         cd['stage2']['startBlock'] = _startBlock + _stage2Height; cd['stage2']['endBlock'] = _startBlock + _stage3Height - 1; cd['stage2']['cap'] = 15 * 10**6 * 10**18; cd['stage2']['exRate'] = 76923;
238         cd['stage3']['startBlock'] = _startBlock + _stage3Height; cd['stage3']['endBlock'] = _startBlock + _stage4Height - 1; cd['stage3']['cap'] = 15 * 10**6 * 10**18; cd['stage3']['exRate'] = 58824;
239         cd['stage4']['startBlock'] = _startBlock + _stage4Height; cd['stage4']['endBlock'] = _startBlock + _endBlockHeight;   cd['stage4']['cap'] = 20 * 10**6 * 10**18; cd['stage4']['exRate'] = 50000;
240         startBlock = _startBlock;
241         endBlock   = _startBlock +_endBlockHeight;
242 
243         escFundAddress = 0xfA29D004fD4139B04bda5fa2633bd7324d6f6c76;
244         allocationsLength = 0;
245         //• 13% (13’000’000 ESC) will remain at EtherSport for supporting the game process;
246         allocate(escFundAddress, 0); // will remain at EtherSport for supporting the game process (remaining unassigned supply);
247         allocate(0x610a20536e7b7A361D6c919529DBc1E037E1BEcB, 5 * 10**6 * 10**18); // will remain at EtherSport for supporting the game process;
248         allocate(0x198bd6be0D747111BEBd5bD053a594FD63F3e87d, 4 * 10**6 * 10**18); // will remain at EtherSport for supporting the game process;
249         allocate(0x02401E5B98202a579F0067781d66FBd4F2700Cb6, 4 * 10**6 * 10**18); // will remain at EtherSport for supporting the game process;
250         //• 5% (5’000’000 ESC) will be allocated for the bounty campaign;
251         allocate(0x778ACEcf52520266675b09b8F5272098D8679f43, 3 * 10**6 * 10**18); // will be allocated for the bounty campaign;
252         allocate(0xdE96fdaFf4f865A1E27085426956748c5D4b8e24, 2 * 10**6 * 10**18); // will be allocated for the bounty campaign;
253         //• 5% (5’000’000 ESC) will be paid to the project founders and the team;
254         allocate(0x4E10125fc934FCADB7a30b97F9b4b642d4804e3d, 2 * 10**6 * 10**18); // will be paid to the project founders and the team;
255         allocate(0xF391B5b62Fd43401751c65aF5D1D02D850Ab6b7c, 2 * 10**6 * 10**18); // will be paid to the project founders and the team;
256         allocate(0x08474BcC5F8BB9EEe6cAc7CBA9b6fb1d20eF5AA4, 1 * 10**6 * 10**18); // will be paid to the project founders and the team;
257         //• 5% (5’000’000 ESC) will be paid to the Angel investors;
258         allocate(0x9F5818196E45ceC2d57DFc0fc0e3D7388e5de48d, 2 * 10**6 * 10**18); // will be paid to the Angel investors.
259         allocate(0x9e43667D1e3Fb460f1f2432D0FF3203364a3d284, 2 * 10**6 * 10**18); // will be paid to the Angel investors.
260         allocate(0x809040D6226FE73f245a0a16Dd685b5641540B74,  500 * 10**3 * 10**18); // will be paid to the Angel investors.
261         allocate(0xaE2542d16cc3D6d487fe87Fc0C03ad0D41e46AFf,  500 * 10**3 * 10**18); // will be paid to the Angel investors.
262         //• 1% (1’000’000 ESC) will be left in the system for building the first jackpot;
263         allocate(0xbC82DE22610c51ACe45d3BCf03b9b3cd179731b2, 1 * 10**6 * 10**18); // will be left in the system for building the first jackpot;
264         //• 1% (1’000’000 ESC) will be distributed among advisors;
265         allocate(0x302Cd6D41866ec03edF421a0CD4f4cbDFB0B67b0,  800 * 10**3 * 10**18); // will be distributed among advisors;
266         allocate(0xe190CCb2f92A0dCAc30bb4a4a92863879e5ff751,   50 * 10**3 * 10**18); // will be distributed among advisors;
267         allocate(0xfC7cf20f29f5690dF508Dd0FB99bFCB4a7d23073,  100 * 10**3 * 10**18); // will be distributed among advisors;
268         allocate(0x1DC97D37eCbf7D255BF4d461075936df2BdFd742,   50 * 10**3 * 10**18); // will be distributed among advisors;
269     }
270 
271     /// @notice Stop sale in case of emergency (i.e. circuit breaker)
272     /// @dev Only allowed to be called by the owner
273     function stopSale() onlyBy(owner) external {
274         isStopped = true;
275     }
276 
277     /// @notice Restart sale in case of an emergency stop
278     /// @dev Only allowed to be called by the owner
279     function restartSale() onlyBy(owner) external {
280         isStopped = false;
281     }
282 
283     /// @dev Fallback function can be used to buy tokens
284     function () payable public {
285         claimTokens();
286     }
287 
288     /// @notice Calculate rate based on block number
289     function calculateTokenExchangeRate() internal returns (uint256) {
290         if (cd['preIco']['startBlock'] <= block.number && block.number <= cd['preIco']['endBlock']) { return cd['preIco']['exRate']; }
291         if (cd['stage1']['startBlock'] <= block.number && block.number <= cd['stage1']['endBlock']) { return cd['stage1']['exRate']; }
292         if (cd['stage2']['startBlock'] <= block.number && block.number <= cd['stage2']['endBlock']) { return cd['stage2']['exRate']; }
293         if (cd['stage3']['startBlock'] <= block.number && block.number <= cd['stage3']['endBlock']) { return cd['stage3']['exRate']; }
294         if (cd['stage4']['startBlock'] <= block.number && block.number <= cd['stage4']['endBlock']) { return cd['stage4']['exRate']; }
295         // in case between Pre-ICO and ICO
296         return 0;
297     }
298 
299     function maximumTokensToBuy() constant internal returns (uint256) {
300         uint256 maximum = 0;
301         if (cd['preIco']['startBlock'] <= block.number) { maximum = maximum.add(cd['preIco']['cap']); }
302         if (cd['stage1']['startBlock'] <= block.number) { maximum = maximum.add(cd['stage1']['cap']); }
303         if (cd['stage2']['startBlock'] <= block.number) { maximum = maximum.add(cd['stage2']['cap']); }
304         if (cd['stage3']['startBlock'] <= block.number) { maximum = maximum.add(cd['stage3']['cap']); }
305         if (cd['stage4']['startBlock'] <= block.number) { maximum = maximum.add(cd['stage4']['cap']); }
306         return maximum.sub(assignedSupply);
307     }
308 
309     /// @notice Create `msg.value` ETH worth of ESC
310     /// @dev Only allowed to be called within the timeframe of the sale period
311     function claimTokens() respectTimeFrame isValidState payable public {
312         require(msg.value >= minimumPayment);
313 
314         uint256 tokenExchangeRate = calculateTokenExchangeRate();
315         // tokenExchangeRate == 0 mean that now not valid time to take part in crowdsale event
316         require(tokenExchangeRate > 0);
317 
318         uint256 tokens = msg.value.mul(tokenExchangeRate).div(100);
319 
320         // Check that we can sell this amount of tokens in the moment
321         require(tokens <= maximumTokensToBuy());
322 
323         // Check that we're not over totals
324         uint256 checkedSupply = assignedSupply.add(tokens);
325 
326         // Return money if we're over total token supply
327         require(checkedSupply.add(escFund) <= totalSupply);
328 
329         balances[msg.sender] = balances[msg.sender].add(tokens);
330         purchases[msg.sender] = purchases[msg.sender].add(tokens);
331 
332         assignedSupply = checkedSupply;
333         ClaimESC(msg.sender, tokens);  // Logs token creation for UI purposes
334         // As per ERC20 spec, a token contract which creates new tokens SHOULD trigger a Transfer event with the _from address
335         // set to 0x0 when tokens are created (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
336         Transfer(0x0, msg.sender, tokens);
337     }
338 
339     /// @notice Sends the ETH to ETH fund wallet and finalizes the token sale
340     function finalize() salePeriodCompleted isValidState onlyBy(owner) external {
341         // Upon successful completion of sale, send tokens to ESC fund
342         balances[escFundAddress] = balances[escFundAddress].add(escFund);
343         assignedSupply = assignedSupply.add(escFund);
344         ClaimESC(escFundAddress, escFund);   // Log tokens claimed by Ethersport ESC fund
345         Transfer(0x0, escFundAddress, escFund);
346 
347 
348         for(uint i=0;i<allocationsLength;i++)
349         {
350             balances[allocationsIndex[i]] = balances[allocationsIndex[i]].add(allocations[allocationsIndex[i]]);
351             ClaimESC(allocationsIndex[i], allocations[allocationsIndex[i]]);  // Log tokens claimed by Ethersport ESC fund
352             Transfer(0x0, allocationsIndex[i], allocations[allocationsIndex[i]]);
353         }
354 
355         // In the case where not all 70M ESC allocated to crowdfund participants
356         // is sold, send the remaining unassigned supply to ESC fund address,
357         // which will then be used to fund the user growth pool.
358         if (assignedSupply < totalSupply) {
359             uint256 unassignedSupply = totalSupply.sub(assignedSupply);
360             balances[escFundAddress] = balances[escFundAddress].add(unassignedSupply);
361             assignedSupply = assignedSupply.add(unassignedSupply);
362 
363             ClaimESC(escFundAddress, unassignedSupply);  // Log tokens claimed by Ethersport ESC fund
364             Transfer(0x0, escFundAddress, unassignedSupply);
365         }
366 
367         ethFundAddress.transfer(this.balance);
368 
369         isFinalized = true; // Finalize sale
370     }
371 }