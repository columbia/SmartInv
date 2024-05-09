1 pragma solidity ^0.4.24;
2 /**
3  * @title Ownable contract - base contract with an owner
4  */
5 contract Ownable {
6   
7   address public owner;
8   address public newOwner;
9 
10   event OwnershipTransferred(address indexed _from, address indexed _to);
11   
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   constructor() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     assert(msg.sender == owner);
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param _newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address _newOwner) public onlyOwner {
33     assert(_newOwner != address(0));      
34     newOwner = _newOwner;
35   }
36 
37   /**
38    * @dev Accept transferOwnership.
39    */
40   function acceptOwnership() public {
41     if (msg.sender == newOwner) {
42       emit OwnershipTransferred(owner, newOwner);
43       owner = newOwner;
44     }
45   }
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 interface ERC20I {
53 
54   function balanceOf(address _owner) external view returns (uint256);
55 
56   function totalSupply() external view returns (uint256);
57   function transfer(address _to, uint256 _value) external returns (bool success);
58   
59   function allowance(address _owner, address _spender) external view returns (uint256);
60   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
61   function approve(address _spender, uint256 _value) external returns (bool success);
62   
63   event Transfer(address indexed from, address indexed to, uint256 value);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 contract SafeMath {
71 
72     /**
73     * @dev Subtracts two numbers, reverts on overflow.
74     */
75     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
76         assert(y <= x);
77         uint256 z = x - y;
78         return z;
79     }
80 
81     /**
82     * @dev Adds two numbers, reverts on overflow.
83     */
84     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
85         uint256 z = x + y;
86         assert(z >= x);
87         return z;
88     }
89 	
90 	/**
91     * @dev Integer division of two numbers, reverts on division by zero.
92     */
93     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
94         uint256 z = x / y;
95         return z;
96     }
97     
98     /**
99     * @dev Multiplies two numbers, reverts on overflow.
100     */	
101     function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {    
102         if (x == 0) {
103             return 0;
104         }
105     
106         uint256 z = x * y;
107         assert(z / x == y);
108         return z;
109     }
110 
111     /**
112     * @dev Returns the integer percentage of the number.
113     */
114     function safePerc(uint256 x, uint256 y) internal pure returns (uint256) {
115         if (x == 0) {
116             return 0;
117         }
118         
119         uint256 z = x * y;
120         assert(z / x == y);    
121         z = z / 10000; // percent to hundredths
122         return z;
123     }
124 
125     /**
126     * @dev Returns the minimum value of two numbers.
127     */	
128     function min(uint256 x, uint256 y) internal pure returns (uint256) {
129         uint256 z = x <= y ? x : y;
130         return z;
131     }
132 
133     /**
134     * @dev Returns the maximum value of two numbers.
135     */
136     function max(uint256 x, uint256 y) internal pure returns (uint256) {
137         uint256 z = x >= y ? x : y;
138         return z;
139     }
140 }
141 
142 
143 
144 
145 
146 
147 /**
148  * @title Agent contract - base contract with an agent
149  */
150 contract Agent is Ownable {
151 
152   address public defAgent;
153 
154   mapping(address => bool) public Agents;
155   
156   constructor() public {
157     defAgent = msg.sender;
158     Agents[msg.sender] = true;
159   }
160   
161   modifier onlyAgent() {
162     assert(Agents[msg.sender]);
163     _;
164   }
165   
166   function updateAgent(address _agent, bool _status) public onlyOwner {
167     assert(_agent != address(0));
168     Agents[_agent] = _status;
169   }  
170 }
171 
172 
173 /**
174  * @title PlayMarket 2.0 Exchange
175  */
176 contract PEX is SafeMath, Agent {
177     address public feeAccount;
178     mapping (address => mapping (address => uint)) public tokens; 
179     mapping (address => mapping (bytes32 => bool)) public orders;
180     mapping (address => mapping (bytes32 => uint)) public orderFills;  
181   
182     struct whitelistToken {
183         bool active;
184         uint256 timestamp;
185     }
186     
187     struct Fee {
188         uint256 feeMake;
189         uint256 feeTake;
190     }
191     
192     mapping (address => whitelistToken) public whitelistTokens;
193     mapping (address => uint256) public accountTypes;
194     mapping (uint256 => Fee) public feeTypes;
195   
196     event Deposit(address token, address user, uint amount, uint balance);
197     event Withdraw(address token, address user, uint amount, uint balance);
198     event Order(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user);
199     event Cancel(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, bytes32 hash);
200     event Trade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, address user, address recipient, bytes32 hash, uint256 timestamp);
201     event WhitelistTokens(address token, bool active, uint256 timestamp);
202   
203     modifier onlyWhitelistTokens(address token, uint256 timestamp) {
204         assert(whitelistTokens[token].active && whitelistTokens[token].timestamp <= timestamp);
205         _;
206     }
207   
208     constructor (address feeAccount_, uint feeMake_, uint feeTake_) public {
209         feeAccount = feeAccount_;
210         feeTypes[0] = Fee(feeMake_, feeTake_);
211         whitelistTokens[0] = whitelistToken(true, 1);
212         emit WhitelistTokens(0, true, 1);
213     }
214     
215     function setAccountType(address user_, uint256 type_) external onlyAgent {
216         accountTypes[user_] = type_;
217     }
218 
219     function getAccountType(address user_) external view returns(uint256) {
220         return accountTypes[user_];
221     }
222   
223     function setFeeType(uint256 type_ , uint256 feeMake_, uint256 feeTake_) external onlyAgent {
224         feeTypes[type_] = Fee(feeMake_,feeTake_);
225     }
226     
227     function getFeeMake(uint256 type_ ) external view returns(uint256) {
228         return (feeTypes[type_].feeMake);
229     }
230     
231     function getFeeTake(uint256 type_ ) external view returns(uint256) {
232         return (feeTypes[type_].feeTake);
233     }
234     
235     function changeFeeAccount(address feeAccount_) external onlyAgent {
236         require(feeAccount_ != address(0));
237         feeAccount = feeAccount_;
238     }
239     
240     function setWhitelistTokens(address token, bool active, uint256 timestamp) external onlyAgent {
241         whitelistTokens[token].active = active;
242         whitelistTokens[token].timestamp = timestamp;
243         emit WhitelistTokens(token, active, timestamp);
244     }
245     
246     /**
247     * deposit ETH
248     */
249     function() public payable {
250         require(msg.value > 0);
251         deposit(msg.sender);
252     }
253   
254     /**
255     * Make deposit.
256     *
257     * @param receiver The Ethereum address who make deposit
258     *
259     */
260     function deposit(address receiver) private {
261         tokens[0][receiver] = safeAdd(tokens[0][receiver], msg.value);
262         emit Deposit(0, receiver, msg.value, tokens[0][receiver]);
263     }
264   
265     /**
266     * Withdraw deposit.
267     *
268     * @param amount Withdraw amount
269     *
270     */
271     function withdraw(uint amount) external {
272         require(tokens[0][msg.sender] >= amount);
273         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
274         msg.sender.transfer(amount);
275         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
276     }
277   
278     /**
279     * Deposit token.
280     *
281     * @param token Token address
282     * @param amount Deposit amount
283     *
284     */
285     function depositToken(address token, uint amount) external onlyWhitelistTokens(token, block.timestamp) {
286         require(token != address(0));
287         require(ERC20I(token).transferFrom(msg.sender, this, amount));
288         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
289         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
290     }
291 
292     /**
293     * tokenFallback ERC223.
294     *
295     * @param owner owner token
296     * @param amount Deposit amount
297     * @param data payload  
298     *
299     */
300     function tokenFallback(address owner, uint256 amount, bytes data) external onlyWhitelistTokens(msg.sender, block.timestamp) returns (bool success) {
301         require(data.length == 0);
302         tokens[msg.sender][owner] = safeAdd(tokens[msg.sender][owner], amount);
303         emit Deposit(msg.sender, owner, amount, tokens[msg.sender][owner]);
304         return true;
305     }
306     
307     /**
308     * Withdraw token.
309     *
310     * @param token Token address
311     * @param amount Withdraw amount
312     *
313     */
314     function withdrawToken(address token, uint amount) external {
315         require(token != address(0));
316         require(tokens[token][msg.sender] >= amount);
317         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
318         require(ERC20I(token).transfer(msg.sender, amount));
319         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
320     }
321   
322     function balanceOf(address token, address user) external view returns (uint) {
323         return tokens[token][user];
324     }
325   
326     function order(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce) external {
327         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender));
328         orders[msg.sender][hash] = true;
329         emit Order(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender);
330     }
331   
332     function trade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) external {
333         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user));
334         if (!(
335             (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
336             block.timestamp <= expires &&
337             safeAdd(orderFills[user][hash], amount) <= amountBuy
338         )) revert();
339         tradeBalances(tokenBuy, amountBuy, tokenSell, amountSell, user, amount);
340         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
341         emit Trade(tokenBuy, amount, tokenSell, amountSell * amount / amountBuy, user, msg.sender, hash, block.timestamp);
342     }
343 
344     function tradeBalances(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, address user, uint amount) private {
345         uint feeMakeXfer = safeMul(amount, feeTypes[accountTypes[user]].feeMake) / (10**18);
346         uint feeTakeXfer = safeMul(amount, feeTypes[accountTypes[msg.sender]].feeTake) / (10**18);
347         tokens[tokenBuy][msg.sender] = safeSub(tokens[tokenBuy][msg.sender], safeAdd(amount, feeTakeXfer));
348         tokens[tokenBuy][user] = safeAdd(tokens[tokenBuy][user], safeSub(amount, feeMakeXfer));
349         tokens[tokenBuy][feeAccount] = safeAdd(tokens[tokenBuy][feeAccount], safeAdd(feeMakeXfer, feeTakeXfer));
350         tokens[tokenSell][user] = safeSub(tokens[tokenSell][user], safeMul(amountSell, amount) / amountBuy);
351         tokens[tokenSell][msg.sender] = safeAdd(tokens[tokenSell][msg.sender], safeMul(amountSell, amount) / amountBuy);
352     }
353   
354     function cancelOrder(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) external {
355         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender));
356         if (!(orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender)) revert();
357         orderFills[msg.sender][hash] = amountBuy;
358         emit Cancel(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender, v, r, s, hash);
359     }
360   
361     function testTrade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) external view returns(bool) {
362         if (!(
363             tokens[tokenBuy][sender] >= amount &&
364             availableVolume(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user, v, r, s) >= amount
365         )) return false;
366         return true;
367     }
368 
369     function availableVolume(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public view returns(uint) {
370         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user));
371         if (!(
372             (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
373             block.timestamp <= expires
374         )) return 0;
375         uint available1 = safeSub(amountBuy, orderFills[user][hash]);
376         uint available2 = safeMul(tokens[tokenSell][user], amountBuy) / amountSell;
377         if (available1<available2) return available1;
378         return available2;
379     }
380 
381     function amountFilled(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user) external view returns(uint) {
382         bytes32 hash = keccak256(abi.encodePacked(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user));
383         return orderFills[user][hash];
384     }
385 }