1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable contract - base contract with an owner
5  */
6 contract Ownable {
7   
8   address public owner;
9   address public newOwner;
10 
11   event OwnershipTransferred(address indexed _from, address indexed _to);
12   
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     assert(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param _newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address _newOwner) public onlyOwner {
34     assert(_newOwner != address(0));      
35     newOwner = _newOwner;
36   }
37 
38   /**
39    * @dev Accept transferOwnership.
40    */
41   function acceptOwnership() public {
42     if (msg.sender == newOwner) {
43       emit OwnershipTransferred(owner, newOwner);
44       owner = newOwner;
45     }
46   }
47 }
48 
49 
50 /**
51  * @title SDADI - Interface
52  */
53 interface SDADI  {	
54   function AddToken(address token) external;
55   function DelToken(address token) external;
56 }
57 
58 
59 /**
60  * @title DAppDEXI - Interface 
61  */
62 interface DAppDEXI {
63 
64     function updateAgent(address _agent, bool _status) external;
65 
66     function setAccountType(address user_, uint256 type_) external;
67     function getAccountType(address user_) external view returns(uint256);
68     function setFeeType(uint256 type_ , uint256 feeMake_, uint256 feeTake_) external;
69     function getFeeMake(uint256 type_ ) external view returns(uint256);
70     function getFeeTake(uint256 type_ ) external view returns(uint256);
71     function changeFeeAccount(address feeAccount_) external;
72     
73     function setWhitelistTokens(address token) external;
74     function setWhitelistTokens(address token, bool active, uint256 timestamp, bytes32 typeERC) external;
75     function depositToken(address token, uint amount) external;
76     function tokenFallback(address owner, uint256 amount, bytes data) external returns (bool success);
77 
78     function withdraw(uint amount) external;
79     function withdrawToken(address token, uint amount) external;
80 
81     function balanceOf(address token, address user) external view returns (uint);
82 
83     function order(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce) external;
84     function trade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) external;    
85     function cancelOrder(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) external;
86     function testTrade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) external view returns(bool);
87     function availableVolume(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) external view returns(uint);
88     function amountFilled(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user) external view returns(uint);
89 }
90 
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 interface ERC20I {
97 
98   function balanceOf(address _owner) external view returns (uint256);
99 
100   function totalSupply() external view returns (uint256);
101   function transfer(address _to, uint256 _value) external returns (bool success);
102   
103   function allowance(address _owner, address _spender) external view returns (uint256);
104   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
105   function approve(address _spender, uint256 _value) external returns (bool success);
106   
107   event Transfer(address indexed from, address indexed to, uint256 value);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 contract SafeMath {
116 
117     /**
118     * @dev Subtracts two numbers, reverts on overflow.
119     */
120     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
121         assert(y <= x);
122         uint256 z = x - y;
123         return z;
124     }
125 
126     /**
127     * @dev Adds two numbers, reverts on overflow.
128     */
129     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
130         uint256 z = x + y;
131         assert(z >= x);
132         return z;
133     }
134 	
135 	/**
136     * @dev Integer division of two numbers, reverts on division by zero.
137     */
138     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
139         uint256 z = x / y;
140         return z;
141     }
142     
143     /**
144     * @dev Multiplies two numbers, reverts on overflow.
145     */	
146     function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {    
147         if (x == 0) {
148             return 0;
149         }
150     
151         uint256 z = x * y;
152         assert(z / x == y);
153         return z;
154     }
155 
156     /**
157     * @dev Returns the integer percentage of the number.
158     */
159     function safePerc(uint256 x, uint256 y) internal pure returns (uint256) {
160         if (x == 0) {
161             return 0;
162         }
163         
164         uint256 z = x * y;
165         assert(z / x == y);    
166         z = z / 10000; // percent to hundredths
167         return z;
168     }
169 
170     /**
171     * @dev Returns the minimum value of two numbers.
172     */	
173     function min(uint256 x, uint256 y) internal pure returns (uint256) {
174         uint256 z = x <= y ? x : y;
175         return z;
176     }
177 
178     /**
179     * @dev Returns the maximum value of two numbers.
180     */
181     function max(uint256 x, uint256 y) internal pure returns (uint256) {
182         uint256 z = x >= y ? x : y;
183         return z;
184     }
185 }
186 
187 
188 /**
189  * @title Agent contract - base contract with an agent
190  */
191 contract Agent is Ownable {
192 
193   address public defAgent;
194 
195   mapping(address => bool) public Agents;
196   
197   constructor() public {    
198     Agents[msg.sender] = true;
199   }
200   
201   modifier onlyAgent() {
202     assert(Agents[msg.sender]);
203     _;
204   }
205   
206   function updateAgent(address _agent, bool _status) public onlyOwner {
207     assert(_agent != address(0));
208     Agents[_agent] = _status;
209   }  
210 }
211 
212 
213 /**
214  * @title DAppsDEX - Decentralized exchange for DApps
215  */
216 contract DAppDEX is DAppDEXI, SafeMath, Agent {
217     
218     address public feeAccount;
219     mapping (address => mapping (address => uint)) public tokens;
220     mapping (address => mapping (bytes32 => bool)) public orders;
221     mapping (address => mapping (bytes32 => uint)) public orderFills;
222 
223     uint public feeListing = 100; // 1.00%
224 
225     struct whitelistToken {
226         bool active;
227         uint256 timestamp;
228     }
229     
230     struct Fee {
231         uint256 feeMake;
232         uint256 feeTake;
233     }
234     
235     mapping (address => whitelistToken) public whitelistTokens;
236     mapping (address => uint256) public accountTypes;
237     mapping (uint256 => Fee) public feeTypes;
238   
239     event Deposit(address token, address user, uint amount, uint balance);
240     event PayFeeListing(address token, address user, uint amount, uint balance);
241     event Withdraw(address token, address user, uint amount, uint balance);
242     event Order(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user);
243     event Cancel(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, bytes32 hash);
244     event Trade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, address user, address recipient, bytes32 hash, uint256 timestamp);
245     event WhitelistTokens(address token, bool active, uint256 timestamp, bytes32 typeERC);
246   
247     constructor (address feeAccount_) public {
248         feeAccount = feeAccount_;
249         feeTypes[0] = Fee(1000000000000000, 2000000000000000);
250         whitelistTokens[0] = whitelistToken(true, 1);
251         emit WhitelistTokens(0, true, 1, 0x0);
252     }
253 
254     function setFeeListing(uint _feeListing) external onlyAgent {
255         feeListing = _feeListing;
256     }
257     
258     function setAccountType(address user_, uint256 type_) external onlyAgent {
259         accountTypes[user_] = type_;
260     }
261 
262     function getAccountType(address user_) external view returns(uint256) {
263         return accountTypes[user_];
264     }
265   
266     function setFeeType(uint256 type_ , uint256 feeMake_, uint256 feeTake_) external onlyAgent {
267         feeTypes[type_] = Fee(feeMake_,feeTake_);
268     }
269 
270     function getFeeMake(uint256 type_ ) external view returns(uint256) {
271         return (feeTypes[type_].feeMake);
272     }
273     
274     function getFeeTake(uint256 type_ ) external view returns(uint256) {
275         return (feeTypes[type_].feeTake);
276     }
277     
278     function changeFeeAccount(address feeAccount_) external onlyAgent {
279         require(feeAccount_ != address(0));
280         feeAccount = feeAccount_;
281     }
282 
283     function setWhitelistTokens(address token) external onlyOwner {
284         whitelistTokens[token].active = true;
285         whitelistTokens[token].timestamp = now;
286         SDADI(feeAccount).AddToken(token);
287         emit WhitelistTokens(token, true, now, "ERC20");
288     }    
289     
290     function setWhitelistTokens(address token, bool active, uint256 timestamp, bytes32 typeERC) external onlyAgent {
291         if (active) {
292             uint fee = safePerc(ERC20I(token).totalSupply(), feeListing);
293             require(fee > 0);
294             require(tokens[token][feeAccount] >= fee);
295             SDADI(feeAccount).AddToken(token);
296         } else {
297             SDADI(feeAccount).DelToken(token);
298         }
299         whitelistTokens[token].active = active;
300         whitelistTokens[token].timestamp = timestamp;
301         emit WhitelistTokens(token, active, timestamp, typeERC);
302     }
303     
304     /**
305     * deposit ETH
306     */
307     function() public payable {
308         require(msg.value > 0);
309         deposit(msg.sender);
310     }
311   
312     /**
313     * Make deposit.
314     *
315     * @param receiver The Ethereum address who make deposit
316     *
317     */
318     function deposit(address receiver) private {
319         tokens[0][receiver] = safeAdd(tokens[0][receiver], msg.value);
320         emit Deposit(0, receiver, msg.value, tokens[0][receiver]);
321     }
322   
323     /**
324     * Deposit token.
325     *
326     * @param token Token address
327     * @param amount Deposit amount
328     *
329     */
330     function depositToken(address token, uint amount) external {
331         require(token != address(0));
332         if (whitelistTokens[token].active) {
333             require(whitelistTokens[token].timestamp <= now);
334             require(ERC20I(token).transferFrom(msg.sender, this, amount));
335             tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
336             emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
337         } else {
338             require(ERC20I(token).transferFrom(msg.sender, this, amount));
339             tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], amount);
340             emit PayFeeListing(token, msg.sender, amount, tokens[msg.sender][feeAccount]);
341         }
342         
343     }
344 
345     /**
346     * tokenFallback ERC223.
347     *
348     * @param owner owner token
349     * @param amount Deposit amount
350     * @param data payload  
351     *
352     */
353     function tokenFallback(address owner, uint256 amount, bytes data) external returns (bool success) {      
354 
355         if (data.length == 0) {
356             assert(whitelistTokens[msg.sender].active && whitelistTokens[msg.sender].timestamp <= now);            
357             tokens[msg.sender][owner] = safeAdd(tokens[msg.sender][owner], amount);
358             emit Deposit(msg.sender, owner, amount, tokens[msg.sender][owner]);
359             return true;
360         } else {
361             tokens[msg.sender][feeAccount] = safeAdd(tokens[msg.sender][feeAccount], amount);
362             emit PayFeeListing(msg.sender, owner, amount, tokens[msg.sender][feeAccount]);
363             return true;
364         }
365     }
366 
367     /**
368     * Withdraw deposit.
369     *
370     * @param amount Withdraw amount
371     *
372     */
373     function withdraw(uint amount) external {
374         require(tokens[0][msg.sender] >= amount);
375         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
376         msg.sender.transfer(amount);
377         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
378     }  
379     
380     /**
381     * Withdraw token.
382     *
383     * @param token Token address
384     * @param amount Withdraw amount
385     *
386     */
387     function withdrawToken(address token, uint amount) external {
388         require(token != address(0));
389         require(tokens[token][msg.sender] >= amount);
390         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
391         require(ERC20I(token).transfer(msg.sender, amount));
392         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
393     }
394   
395     function balanceOf(address token, address user) external view returns (uint) {
396         return tokens[token][user];
397     }
398   
399     function order(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce) external {
400         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender));
401         orders[msg.sender][hash] = true;
402         emit Order(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender);
403     }
404   
405     function trade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) external {
406         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user));
407         if (!(
408             (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
409             block.timestamp <= expires &&
410             safeAdd(orderFills[user][hash], amount) <= amountBuy
411         )) revert();
412         tradeBalances(tokenBuy, amountBuy, tokenSell, amountSell, user, amount);
413         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
414         emit Trade(tokenBuy, amount, tokenSell, amountSell * amount / amountBuy, user, msg.sender, hash, block.timestamp);
415     }
416 
417     function tradeBalances(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, address user, uint amount) private {
418         uint feeMakeXfer = safeMul(amount, feeTypes[accountTypes[user]].feeMake) / (10**18);
419         uint feeTakeXfer = safeMul(amount, feeTypes[accountTypes[msg.sender]].feeTake) / (10**18);
420         tokens[tokenBuy][msg.sender] = safeSub(tokens[tokenBuy][msg.sender], safeAdd(amount, feeTakeXfer));
421         tokens[tokenBuy][user] = safeAdd(tokens[tokenBuy][user], safeSub(amount, feeMakeXfer));
422         tokens[tokenBuy][feeAccount] = safeAdd(tokens[tokenBuy][feeAccount], safeAdd(feeMakeXfer, feeTakeXfer));
423         tokens[tokenSell][user] = safeSub(tokens[tokenSell][user], safeMul(amountSell, amount) / amountBuy);
424         tokens[tokenSell][msg.sender] = safeAdd(tokens[tokenSell][msg.sender], safeMul(amountSell, amount) / amountBuy);
425     }
426   
427     function cancelOrder(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) external {
428         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender));
429         if (!(orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender)) revert();
430         orderFills[msg.sender][hash] = amountBuy;
431         emit Cancel(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender, v, r, s, hash);
432     }
433   
434     function testTrade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) external view returns(bool) {
435         if (!(
436             tokens[tokenBuy][sender] >= amount &&
437             availableVolume(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user, v, r, s) >= amount
438         )) return false;
439         return true;
440     }
441 
442     function availableVolume(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public view returns(uint) {
443         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user));
444         if (!(
445             (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
446             block.timestamp <= expires
447         )) return 0;
448         uint available1 = safeSub(amountBuy, orderFills[user][hash]);
449         uint available2 = safeMul(tokens[tokenSell][user], amountBuy) / amountSell;
450         if (available1<available2) return available1;
451         return available2;
452     }
453 
454     function amountFilled(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user) external view returns(uint) {
455         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user));
456         return orderFills[user][hash];
457     }
458 }