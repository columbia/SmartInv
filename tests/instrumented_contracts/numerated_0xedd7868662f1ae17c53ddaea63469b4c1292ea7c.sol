1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     bytes32 public standard;
5     bytes32 public name;
6     bytes32 public symbol;
7     uint256 public totalSupply;
8     uint8 public decimals;
9     bool public allowTransactions;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16 }
17 
18 contract NescrowExchangeService {
19 
20     address owner = msg.sender;
21 
22     uint256 public feeRateMin = 200;//100/200 = max 0.5%
23     uint256 public takerFeeRate = 0;
24     uint256 public makerFeeRate = 0;
25     address public feeAddress;
26 
27     mapping (address => bool) public admins;
28     mapping (bytes32 => bool) public traded;
29     mapping (bytes32 => uint256) public orderFills;
30     mapping (bytes32 => bool) public withdrawn;
31     mapping (bytes32 => bool) public transfers;
32     mapping (address => mapping (address => uint256)) public balances;
33     mapping (address => uint256) public tradesLocked;
34     mapping (address => uint256) public disableFees;
35     mapping (address => uint256) public tokenDecimals;
36     mapping (address => bool) public tokenRegistered;
37 
38     event Deposit(address token, address user, uint256 amount, uint256 balance);
39     event Withdraw(address token, address user, uint256 amount, uint256 balance);
40     event TradesLock(address user);
41     event TradesUnlock(address user);
42 
43     modifier onlyOwner {
44         assert(msg.sender == owner);
45         _;
46     }
47 
48     modifier onlyAdmin {
49         require(msg.sender == owner || admins[msg.sender]);
50         _;
51     }
52 
53     function setOwner(address newOwner) public onlyOwner {
54         owner = newOwner;
55     }
56 
57     function getOwner() public view returns (address out) {
58         return owner;
59     }
60 
61     function setAdmin(address admin, bool isAdmin) public onlyOwner {
62         admins[admin] = isAdmin;
63     }
64 
65     function deposit() public payable {
66         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
67         require(msg.value > 0);
68         increaseBalance(msg.sender, address(0), amount);
69         emit Deposit(address(0), msg.sender, amount, balances[address(0)][msg.sender]);
70     }
71 
72     function depositToken(address token, uint256 amount) public {
73         require(amount > 0);
74         require(Token(token).transferFrom(msg.sender, this, toTokenAmount(token, amount)));
75         increaseBalance(msg.sender, token, amount);
76         emit Deposit(token, msg.sender, amount, balances[token][msg.sender]);
77     }
78 
79     function sendTips() public payable {
80         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
81         require(msg.value > 0);
82         increaseBalance(feeAddress, address(0), amount);
83     }
84 
85     function sendTipsToken(address token, uint256 amount) public {
86         require(amount > 0);
87         require(Token(token).transferFrom(msg.sender, this, toTokenAmount(token, amount)));
88         increaseBalance(feeAddress, token, amount);
89     }
90 
91     function transferTips(address token, uint256 amount, address fromUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
92         public onlyAdmin {
93 
94         require(amount > 0);
95 
96         bytes32 hash = keccak256(abi.encodePacked(this, token, amount, fromUser, nonce));
97         require(!transfers[hash]);
98         transfers[hash] = true;
99 
100         address signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s);
101         require(fromUser == signer);
102 
103         require(reduceBalance(fromUser, token, amount));
104         increaseBalance(feeAddress, token, amount);
105     }
106 
107     function transfer(address token, uint256 amount, address fromUser, address toUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
108         public onlyAdmin {
109 
110         require(amount > 0);
111 
112         bytes32 hash = keccak256(abi.encodePacked(this, token, amount, fromUser, toUser, nonce));
113         require(!transfers[hash]);
114         transfers[hash] = true;
115 
116         address signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s);
117         require(fromUser == signer);
118 
119         require(reduceBalance(fromUser, token, amount));
120         increaseBalance(toUser, token, amount);
121     }
122 
123     function withdrawAdmin(address token, uint256 amount, address user, uint nonce, uint8 v, bytes32 r, bytes32 s)
124         public onlyAdmin {
125 
126         require(amount > 0);
127 
128         bytes32 hash = keccak256(abi.encodePacked(this, token, amount, user, nonce));
129         require(!withdrawn[hash]);
130         withdrawn[hash] = true;
131 
132         address signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s);
133         require(user == signer);
134 
135         require(reduceBalance(user, token, amount));
136         if (token == address(0)) {
137             require(user.send(toTokenAmount(address(0), amount)));
138         } else {
139             require(Token(token).transfer(user, toTokenAmount(token, amount)));
140         }
141         emit Withdraw(token, user, amount, balances[token][user]);
142     }
143 
144     function withdraw(address token, uint256 amount) public {
145 
146         require(amount > 0);
147         require(tradesLocked[msg.sender] > block.number);
148         require(reduceBalance(msg.sender, token, amount));
149 
150         if (token == address(0)) {
151             require(msg.sender.send(toTokenAmount(address(0), amount)));
152         } else {
153             require(Token(token).transfer(msg.sender, toTokenAmount(token, amount)));
154         }
155         emit Withdraw(token, msg.sender, amount, balances[token][msg.sender]);
156     }
157 
158     function reduceBalance(address user, address token, uint256 amount) private returns(bool) {
159         if (balances[token][user] < amount) return false;
160         balances[token][user] = safeSub(balances[token][user], amount);
161         return true;
162     }
163 
164     function increaseBalance(address user, address token, uint256 amount) private returns(bool) {
165         balances[token][user] = safeAdd(balances[token][user], amount);
166         return true;
167     }
168 
169     function toTokenAmount(address token, uint256 amount) private view returns (uint256) {
170 
171         require(tokenRegistered[token]);
172         uint256 decimals = token == address(0)
173             ? 18
174             : tokenDecimals[token];
175 
176         if (decimals == 8) {
177             return amount;
178         }
179 
180         if (decimals > 8) {
181             return safeMul(amount, 10**(decimals - 8));
182         } else {
183             return safeDiv(amount, 10**(8 - decimals));
184         }
185     }
186 
187     function setTakerFeeRate(uint256 feeRate) public onlyAdmin {
188         require(feeRate == 0 || feeRate >= feeRateMin);
189         takerFeeRate = feeRate;
190     }
191 
192     function setMakerFeeRate(uint256 feeRate) public onlyAdmin {
193         require(feeRate == 0 || feeRate >= feeRateMin);
194         makerFeeRate = feeRate;
195     }
196 
197     function setFeeAddress(address _feeAddress) public onlyAdmin {
198         require(_feeAddress != address(0));
199         feeAddress = _feeAddress;
200     }
201 
202     function setDisableFees(address user, uint256 timestamp) public onlyAdmin {
203         require(timestamp > block.timestamp);
204         disableFees[user] = timestamp;
205     }
206 
207     function invalidateOrder(address user, uint256 timestamp) public onlyAdmin {
208         require(timestamp > block.timestamp);
209         disableFees[user] = timestamp;
210     }
211 
212     function setTokenDecimals(address token, uint256 decimals) public onlyAdmin {
213         require(!tokenRegistered[token]);
214         tokenRegistered[token] = true;
215         tokenDecimals[token] = decimals;
216     }
217 
218     function tradesLock(address user) public {
219         require(user == msg.sender);
220         tradesLocked[user] = block.number + 20000;
221         emit TradesLock(user);
222     }
223 
224     function tradesUnlock(address user) public {
225         require(user == msg.sender);
226         tradesLocked[user] = 0;
227         emit TradesUnlock(user);
228     }
229 
230     function isUserMakerFeeEnabled(address user) private view returns(bool) {
231         return makerFeeRate > 0 && disableFees[user] < block.timestamp;
232     }
233 
234     function isUserTakerFeeEnabled(address user) private view returns(bool) {
235         return takerFeeRate > 0 && disableFees[user] < block.timestamp;
236     }
237 
238     function trade(
239         uint256[6] amounts,
240         address[4] addresses,
241         uint8[2] v,
242         bytes32[4] rs
243     ) public onlyAdmin {
244         /**
245             amounts: offerAmount, wantAmount, offerAmountToFill, blockExpires, nonce, nonceTrade
246             addresses: maker, taker, offerToken, wantToken
247         */
248         require(tradesLocked[addresses[0]] < block.number);
249         require(block.timestamp <= amounts[3]);
250         bytes32 orderHash = keccak256(abi.encodePacked(this, addresses[2], addresses[3], addresses[0], amounts[0], amounts[1], amounts[3], amounts[4]));
251 
252         require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)), v[0], rs[0], rs[1]) == addresses[0]);
253 
254         bytes32 tradeHash = keccak256(abi.encodePacked(orderHash, amounts[2], addresses[1], amounts[5]));
255         require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", tradeHash)), v[1], rs[2], rs[3]) == addresses[1]);
256 
257         require(!traded[tradeHash]);
258         traded[tradeHash] = true;
259 
260         require(safeSub(amounts[0], orderFills[orderHash]) >= amounts[2]);
261 
262         uint256 wantAmountToTake = safeDiv(safeMul(amounts[2], amounts[1]), amounts[0]);
263         require(wantAmountToTake > 0);
264 
265         require(reduceBalance(addresses[0], addresses[2], amounts[2]));
266         require(reduceBalance(addresses[1], addresses[3], safeDiv(safeMul(amounts[2], amounts[1]), amounts[0])));
267 
268         if (isUserMakerFeeEnabled(addresses[0])) {
269             increaseBalance(addresses[0], addresses[3], safeSub(wantAmountToTake, safeDiv(wantAmountToTake, makerFeeRate)));
270             increaseBalance(feeAddress, addresses[3], safeDiv(wantAmountToTake, makerFeeRate));
271         } else {
272             increaseBalance(addresses[0], addresses[3], wantAmountToTake);
273         }
274 
275         if (isUserTakerFeeEnabled(addresses[1])) {
276             increaseBalance(addresses[1], addresses[2], safeSub(amounts[2], safeDiv(amounts[2], takerFeeRate)));
277             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[2], takerFeeRate));
278         } else {
279             increaseBalance(addresses[1], addresses[2], amounts[2]);
280         }
281 
282         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[2]);
283     }
284 
285     function tradeWithTips(
286         uint256[9] amounts,
287         address[4] addresses,
288         uint8[2] v,
289         bytes32[4] rs
290     ) public onlyAdmin {
291         /**
292             amounts: offerAmount, wantAmount, offerAmountToFill, blockExpires, nonce, nonceTrade, makerTips, takerTips, p2p
293             addresses: maker, taker, offerToken, wantToken
294         */
295         require(tradesLocked[addresses[0]] < block.number);
296         require(block.timestamp <= amounts[3]);
297 
298         bytes32 orderHash;
299         if (amounts[8] == 0) {
300             orderHash = amounts[6] > 0
301                 ? keccak256(abi.encodePacked(this, addresses[2], addresses[3], addresses[0], amounts[0], amounts[1], amounts[3], amounts[4], amounts[6]))
302                 : keccak256(abi.encodePacked(this, addresses[2], addresses[3], addresses[0], amounts[0], amounts[1], amounts[3], amounts[4]));
303         } else {
304             orderHash = amounts[6] > 0
305                 ? keccak256(abi.encodePacked(this, addresses[2], addresses[3], addresses[0], addresses[1], amounts[0], amounts[1], amounts[3], amounts[4], amounts[6]))
306                 : keccak256(abi.encodePacked(this, addresses[2], addresses[3], addresses[0], addresses[1], amounts[0], amounts[1], amounts[3], amounts[4]));
307         }
308 
309         require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)), v[0], rs[0], rs[1]) == addresses[0]);
310 
311         bytes32 tradeHash = amounts[7] > 0
312             ? keccak256(abi.encodePacked(orderHash, amounts[2], addresses[1], amounts[5], amounts[7]))
313             : keccak256(abi.encodePacked(orderHash, amounts[2], addresses[1], amounts[5]));
314         require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", tradeHash)), v[1], rs[2], rs[3]) == addresses[1]);
315 
316         require(!traded[tradeHash]);
317         traded[tradeHash] = true;
318 
319         require(safeSub(amounts[0], orderFills[orderHash]) >= amounts[2]);
320 
321         uint256 wantAmountToTake = safeDiv(safeMul(amounts[2], amounts[1]), amounts[0]);
322         require(wantAmountToTake > 0);
323 
324         require(reduceBalance(addresses[0], addresses[2], amounts[2]));
325         require(reduceBalance(addresses[1], addresses[3], safeDiv(safeMul(amounts[2], amounts[1]), amounts[0])));
326 
327         if (amounts[6] > 0 && !isUserMakerFeeEnabled(addresses[0])) {
328             increaseBalance(addresses[0], addresses[3], safeSub(wantAmountToTake, safeDiv(wantAmountToTake, amounts[6])));
329             increaseBalance(feeAddress, addresses[3], safeDiv(wantAmountToTake, amounts[6]));
330         } else if (amounts[6] == 0 && isUserMakerFeeEnabled(addresses[0])) {
331             increaseBalance(addresses[0], addresses[3], safeSub(wantAmountToTake, safeDiv(wantAmountToTake, makerFeeRate)));
332             increaseBalance(feeAddress, addresses[3], safeDiv(wantAmountToTake, makerFeeRate));
333         } else if (amounts[6] > 0 && isUserMakerFeeEnabled(addresses[0])) {
334             increaseBalance(addresses[0], addresses[3], safeSub(wantAmountToTake, safeAdd(safeDiv(wantAmountToTake, amounts[6]), safeDiv(wantAmountToTake, makerFeeRate))));
335             increaseBalance(feeAddress, addresses[3], safeAdd(safeDiv(wantAmountToTake, amounts[6]), safeDiv(wantAmountToTake, makerFeeRate)));
336         } else {
337             increaseBalance(addresses[0], addresses[3], wantAmountToTake);
338         }
339 
340         if (amounts[7] > 0 && !isUserTakerFeeEnabled(addresses[1])) {
341             increaseBalance(addresses[1], addresses[2], safeSub(amounts[2], safeDiv(amounts[2], amounts[7])));
342             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[2], amounts[7]));
343         } else if (amounts[7] == 0 && isUserTakerFeeEnabled(addresses[1])) {
344             increaseBalance(addresses[1], addresses[2], safeSub(amounts[2], safeDiv(amounts[2], takerFeeRate)));
345             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[2], takerFeeRate));
346         } else if (amounts[7] > 0 && isUserTakerFeeEnabled(addresses[1])) {
347             increaseBalance(addresses[1], addresses[2], safeSub(amounts[2], safeAdd(safeDiv(amounts[2], amounts[7]), safeDiv(amounts[2], takerFeeRate))));
348             increaseBalance(feeAddress, addresses[2], safeAdd(safeDiv(amounts[2], amounts[7]), safeDiv(amounts[2], takerFeeRate)));
349         } else {
350             increaseBalance(addresses[1], addresses[2], amounts[2]);
351         }
352 
353         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[2]);
354     }
355 
356     function() external payable {
357         revert();
358     }
359 
360     function safeMul(uint a, uint b) internal pure returns (uint) {
361         uint c = a * b;
362         assert(a == 0 || c / a == b);
363         return c;
364     }
365 
366     function safeSub(uint a, uint b) internal pure returns (uint) {
367         assert(b <= a);
368         return a - b;
369     }
370 
371     function safeAdd(uint a, uint b) internal pure returns (uint) {
372         uint c = a + b;
373         assert(c>=a && c>=b);
374         return c;
375     }
376 
377     function safeDiv(uint a, uint b) internal pure returns (uint) {
378         assert(b > 0);
379         uint c = a / b;
380         assert(a == b * c + a % b);
381         return c;
382     }
383 
384 }