1 contract Ownable {
2     address public owner;
3 
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8 
9     constructor() public {
10         owner = msg.sender; 
11     }
12 
13     /**
14         @dev Transfers the ownership of the contract.
15 
16         @param _owner Address of the new owner
17     */
18     function setOwner(address _owner) public onlyOwner returns (bool) {
19         require(_owner != address(0));
20         owner = _owner;
21         return true;
22     } 
23 }
24 
25 contract RpSafeMath {
26     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
27       uint256 z = x + y;
28       assert((z >= x) && (z >= y));
29       return z;
30     }
31 
32     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
33       assert(x >= y);
34       uint256 z = x - y;
35       return z;
36     }
37 
38     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
39       uint256 z = x * y;
40       assert((x == 0)||(z/x == y));
41       return z;
42     }
43 
44     function min(uint256 a, uint256 b) internal returns(uint256) {
45         if (a < b) { 
46           return a;
47         } else { 
48           return b; 
49         }
50     }
51     
52     function max(uint256 a, uint256 b) internal returns(uint256) {
53         if (a > b) { 
54           return a;
55         } else { 
56           return b; 
57         }
58     }
59 }
60 
61 contract HasWorkers is Ownable {
62     mapping(address => uint256) private workerToIndex;    
63     address[] private workers;
64 
65     event AddedWorker(address _worker);
66     event RemovedWorker(address _worker);
67 
68     constructor() public {
69         workers.length++;
70     }
71 
72     modifier onlyWorker() {
73         require(isWorker(msg.sender));
74         _;
75     }
76 
77     modifier workerOrOwner() {
78         require(isWorker(msg.sender) || msg.sender == owner);
79         _;
80     }
81 
82     function isWorker(address _worker) public view returns (bool) {
83         return workerToIndex[_worker] != 0;
84     }
85 
86     function allWorkers() public view returns (address[] memory result) {
87         result = new address[](workers.length - 1);
88         for (uint256 i = 1; i < workers.length; i++) {
89             result[i - 1] = workers[i];
90         }
91     }
92 
93     function addWorker(address _worker) public onlyOwner returns (bool) {
94         require(!isWorker(_worker));
95         uint256 index = workers.push(_worker) - 1;
96         workerToIndex[_worker] = index;
97         emit AddedWorker(_worker);
98         return true;
99     }
100 
101     function removeWorker(address _worker) public onlyOwner returns (bool) {
102         require(isWorker(_worker));
103         uint256 index = workerToIndex[_worker];
104         address lastWorker = workers[workers.length - 1];
105         workerToIndex[lastWorker] = index;
106         workers[index] = lastWorker;
107         workers.length--;
108         delete workerToIndex[_worker];
109         emit RemovedWorker(_worker);
110         return true;
111     }
112 }
113 
114 contract Token {
115     function transfer(address _to, uint _value) returns (bool success);
116     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
117     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
118     function approve(address _spender, uint256 _value) returns (bool success);
119     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
120     function balanceOf(address tokenOwner) public constant returns (uint balance);
121 }
122 
123 
124 /*
125     @notice Receives ETH or Tokens and routes them to a list of accounts or to a cold wallet.
126 */
127 contract Balancer is RpSafeMath, Ownable, HasWorkers {
128     address[] public accounts;
129     address public coldWallet;
130 
131     uint256 public limitEth;
132     mapping(address => uint256) public limitToken;
133 
134     bool public paused;
135 
136     constructor() public {
137         coldWallet = msg.sender;
138     }
139 
140     /*
141         @return All the "hotwallet" accounts, it must have at least one.
142     */
143     function allAccounts() public view returns (address[]) {
144         return accounts;
145     }
146 
147     /*
148         @notice Pauses the balancer, if the Balancer is paused all ETH/tokens
149             will be realyed to the coldwallet.
150 
151         @dev Any worker can pause the contract
152     */
153     function pause() public workerOrOwner returns (bool) {
154         paused = true;
155         return true;
156     }
157 
158     /*
159         @notice Unpauses the balancer.
160 
161         @dev Only the owner can unpause
162     */
163     function unpause() public onlyOwner returns (bool) {
164         paused = false;
165         return true;
166     }
167 
168     /*
169         @notice Sets the total max amount in ETH for the accounts to hold,
170             any exceeding funds will be sent to the coldWallet.
171         
172         @param limit Max amount in wei
173     */
174     function setLimitEth(uint256 limit) public onlyOwner returns (bool) {
175         limitEth = limit;
176         return true;
177     }
178 
179     /*
180         @notice Sets the total max amount in token for the accounts to hold,
181             any exceeding funds will be sent to the coldWallet.
182         
183         @param token Token to set the limit
184         @param limit Max amount in wei
185     */
186     function setLimitToken(Token token, uint256 limit) public onlyOwner returns (bool) {
187         limitToken[token] = limit;
188         return true;
189     }
190 
191     /*
192         @notice Adds an account to the "hotwallet" group
193 
194         @param account Address of the account
195     */
196     function addAccount(address account) public onlyOwner returns (bool) {
197         accounts.push(account);
198         return true;
199     }
200 
201     /*
202         @notice Removes an account
203 
204         @dev This method iterates over the accounts array, if number of accounts
205             is too big this method will fail. Use carefully.
206 
207         @param account Account to remove
208     */
209     function removeAccountSearch(address account) public onlyOwner returns (bool) {
210         for(uint256 index = 0; index < accounts.length; index++) {
211             if (accounts[index] == account) {
212                 return removeAccount(index, account);
213             }
214         }
215 
216         revert();
217     }
218 
219     /*
220         @notice Removes an account without searching for the index.
221 
222         @param index Index of the account, must match the account index.
223         @param account Account to remove
224     */
225     function removeAccount(uint256 index, address account) public onlyOwner returns (bool) {
226         require(accounts[index] == account);
227         accounts[index] = accounts[accounts.length - 1];
228         accounts.length -= 1;
229         return true;
230     }
231 
232     /*
233         @notice Changes the coldwallet, exceeding funds will be sent here
234 
235         @param wallet New coldwallet address
236     */
237     function setColdWallet(address wallet) public onlyOwner returns (bool) {
238         coldWallet = wallet;
239         return true;
240     }
241 
242     /*
243         @notice Executes any transaction
244     */
245     function executeTransaction(address to, uint256 value, bytes data) public onlyOwner returns (bool) {
246         return to.call.value(value)(data);
247     }
248 
249     /*
250         @notice Loads the ETH balances of all the accounts
251     */
252     function loadEthBalances() public view returns (uint256[] memory, uint256 total) {
253         uint256[] memory result = new uint256[](accounts.length);
254         uint256 balance;
255         for (uint256 i = 0; i < accounts.length; i++) {
256             balance = accounts[i].balance;
257             result[i] = balance;
258             total += balance;
259         }
260         return (result, total);
261     }
262 
263     /*
264         @notice Loads the token balance of all the accounts
265     */
266     function loadTokenBalances(Token token) public view returns (uint256[] memory, uint256 total) {
267         uint256[] memory result = new uint256[](accounts.length);
268         uint256 balance;
269         for (uint256 i = 0; i < accounts.length; i++) {
270             balance = token.balanceOf(accounts[i]);
271             result[i] = balance;
272             total += balance;
273         }
274         return (result, total);
275     }
276 
277     /*
278         @notice Calculates the optimal per-wallet balance target
279 
280         @param target The global target
281         @param balances The balance of each account
282 
283         @return nTarget The target per account
284     */
285     function getTargetPerWallet(uint256 target, uint256[] memory balances) internal pure returns (uint256 nTarget) {
286         uint256 d = balances.length;
287         uint256 oTarget = target / balances.length;
288         uint256 t;
289 
290         for (uint256 i = 0; i < balances.length; i++) {
291             if (balances[i] > oTarget) {
292                 d--;
293                 t += (balances[i] - oTarget);
294             }
295         }
296 
297         nTarget = oTarget - (t / d);
298     }
299 
300     /*
301         @notice Forawards the ETH to the defined accounts, if the limit is exceeded
302             sends the extra ETH to the coldwallet.
303 
304         @dev If gas is not enought the ETH is temporary stored in the contract
305     */
306     function() public payable {
307         if (gasleft() > 2400) {
308             if (paused) {
309                 coldWallet.transfer(address(this).balance);
310             } else {
311                 uint256[] memory balances;
312                 uint256 total;
313                 
314                 (balances, total) = loadEthBalances();
315 
316                 uint256 value = address(this).balance;
317                 uint256 targetTotal = min(limitEth, total + value);
318 
319                 if (targetTotal > total) {
320                     uint256 targetPerHotwallet = getTargetPerWallet(targetTotal, balances);
321 
322                     for (uint256 i = 0; i < balances.length; i++) {                        
323                         if (balances[i] < targetPerHotwallet) {
324                             accounts[i].transfer(targetPerHotwallet - balances[i]);
325                         }
326                     }
327                 }
328 
329                 uint256 toColdWallet = address(this).balance;
330                 if (toColdWallet != 0) {
331                     coldWallet.transfer(toColdWallet);
332                 }
333             }
334         }            
335     }
336 
337     /*
338         @notice Forawards the tokens to the defined accounts, if the limit is exceeded
339             sends the extra tokens to the coldwallet.
340 
341         @param token Token to forward
342     */
343     function handleTokens(Token token) public returns (bool) {
344         if (paused) {
345             token.transfer(coldWallet, token.balanceOf(this));
346         } else {
347             uint256[] memory balances;
348             uint256 total;
349             
350             (balances, total) = loadTokenBalances(token);
351 
352             uint256 value = token.balanceOf(address(this));
353             uint256 targetTotal = min(limitToken[token], total + value);
354 
355             if (targetTotal > total) {
356                 uint256 targetPerHotwallet = getTargetPerWallet(targetTotal, balances);
357 
358                 for (uint256 i = 0; i < balances.length; i++) {
359                     if (balances[i] < targetPerHotwallet) {
360                         token.transfer(accounts[i], targetPerHotwallet - balances[i]);
361                     }
362                 }
363             }
364 
365             uint256 toColdWallet = token.balanceOf(address(this));
366             if (toColdWallet != 0) {
367                 token.transfer(coldWallet, toColdWallet);
368             }
369         }
370     }
371 }