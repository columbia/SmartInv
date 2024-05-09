1 pragma solidity ^0.4.19;
2 
3 
4 contract SafeMath {
5     function safeMul(uint256 a, uint256 b) internal returns (uint256) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 
22     //  function assert(bool assertion) internal {
23     //    if (!assertion) throw;
24     //  }
25 }
26 
27 
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/issues/20
30 contract ERC20Interface {
31     // Get the total token supply
32     function totalSupply() public constant returns (uint256 totalSupply);
33 
34     // Get the account balance of another account with address _owner
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36 
37     // Send _value amount of tokens to address _to
38     function transfer(address _to, uint256 _value) public returns (bool success);
39 
40     // Send _value amount of tokens from address _from to address _to
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42 
43     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
44     // If this function is called again it overwrites the current allowance with _value.
45     // this function is required for some DEX functionality
46     function approve(address _spender, uint256 _value) public returns (bool success);
47 
48     // Returns the amount which _spender is still allowed to withdraw from _owner
49     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
50 
51     // Triggered when tokens are transferred.
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53 
54     // Triggered whenever approve(address _spender, uint256 _value) is called.
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 }
57 
58 
59 contract Etx is ERC20Interface {
60     uint256 public expirationBlock;
61     function isActive(address _owner) public returns (bool activated);
62 }
63 
64 
65 contract Ethex is SafeMath {
66     address public admin; //the admin address
67     address public feeAccount; //the account that will receive fees
68     address public etxAddress;
69 
70     uint256 public makeFee; //percentage times (1 ether)
71     uint256 public takeFee; //percentage times (1 ether)
72     uint256 public lastFreeBlock;
73 
74     mapping (bytes32 => uint256) public sellOrderBalances; //a hash of available order balances holds a number of tokens
75     mapping (bytes32 => uint256) public buyOrderBalances; //a hash of available order balances. holds a number of eth
76 
77     event MakeBuyOrder(bytes32 orderHash, address indexed token, uint256 tokenAmount, uint256 weiAmount, address indexed buyer);
78 
79     event MakeSellOrder(bytes32 orderHash, address indexed token, uint256 tokenAmount, uint256 weiAmount, address indexed seller);
80 
81     event CancelBuyOrder(bytes32 orderHash, address indexed token, uint256 tokenAmount, uint256 weiAmount, address indexed buyer);
82 
83     event CancelSellOrder(bytes32 orderHash, address indexed token, uint256 tokenAmount, uint256 weiAmount, address indexed seller);
84 
85     event TakeBuyOrder(bytes32 orderHash, address indexed token, uint256 tokenAmount, uint256 weiAmount, uint256 totalTransactionTokens, address indexed buyer, address indexed seller);
86 
87     event TakeSellOrder(bytes32 orderHash, address indexed token, uint256 tokenAmount, uint256 weiAmount, uint256 totalTransactionWei, address indexed buyer, address indexed seller);
88 
89     function Ethex(address admin_, address feeAccount_, uint256 makeFee_, uint256 takeFee_, address etxAddress_, uint256 _lastFreeBlock) public {
90         admin = admin_;
91         feeAccount = feeAccount_;
92         makeFee = makeFee_;
93         takeFee = takeFee_;
94         etxAddress = etxAddress_;
95         lastFreeBlock = _lastFreeBlock;
96     }
97 
98     function() public {
99         revert();
100     }
101 
102     function changeAdmin(address admin_) public {
103         require(msg.sender == admin);
104         admin = admin_;
105     }
106 
107     function changeETXAddress(address etxAddress_) public {
108         require(msg.sender == admin);
109         require(block.number > Etx(etxAddress).expirationBlock());
110         etxAddress = etxAddress_;
111     }
112 
113     function changeLastFreeBlock(uint256 _lastFreeBlock) public {
114         require(msg.sender == admin);
115         require(_lastFreeBlock > block.number + 100); //announce at least 100 blocks ahead
116         lastFreeBlock = _lastFreeBlock;
117     }
118 
119     function changeFeeAccount(address feeAccount_) public {
120         require(msg.sender == admin);
121         feeAccount = feeAccount_;
122     }
123 
124     function changeMakeFee(uint256 makeFee_) public {
125         require(msg.sender == admin);
126         require(makeFee_ < makeFee);
127         makeFee = makeFee_;
128     }
129 
130     function changeTakeFee(uint256 takeFee_) public {
131         require(msg.sender == admin);
132         require(takeFee_ < takeFee);
133         takeFee = takeFee_;
134     }
135 
136     function feeFromTotalCostForAccount(uint256 totalCost, uint256 feeAmount, address account) public constant returns (uint256) {
137         if (Etx(etxAddress).isActive(account)) {
138             // No fee for active addr.
139             return 0;
140         }
141 
142         if (block.number <= lastFreeBlock)
143         {
144             return 0;
145         }
146 
147         return feeFromTotalCost(totalCost, feeAmount);
148     }
149 
150     function feeFromTotalCost(uint256 totalCost, uint256 feeAmount) public constant returns (uint256) {
151 
152         uint256 cost = safeMul(totalCost, (1 ether)) / safeAdd((1 ether), feeAmount);
153 
154         // Calculate ceil(cost).
155         uint256 remainder = safeMul(totalCost, (1 ether)) % safeAdd((1 ether), feeAmount);
156         if (remainder != 0) {
157             cost = safeAdd(cost, 1);
158         }
159 
160         uint256 fee = safeSub(totalCost, cost);
161         return fee;
162     }
163 
164     function calculateFeeForAccount(uint256 cost, uint256 feeAmount, address account) public constant returns (uint256) {
165         if (Etx(etxAddress).isActive(account)) {
166             // No fee for vested addr.
167             return 0;
168         }
169 
170         if (block.number <= lastFreeBlock)
171         {
172             return 0;
173         }
174 
175         return calculateFee(cost, feeAmount);
176     }
177 
178     function calculateFee(uint256 cost, uint256 feeAmount) public constant returns (uint256) {
179 
180         uint256 fee = safeMul(cost, feeAmount) / (1 ether);
181         return fee;
182     }
183 
184     // Makes an offer to trade tokenAmount of ERC20 token, token, for weiAmount of wei.
185     function makeSellOrder(address token, uint256 tokenAmount, uint256 weiAmount) public {
186         require(tokenAmount != 0);
187         require(weiAmount != 0);
188 
189         bytes32 h = sha256(token, tokenAmount, weiAmount, msg.sender);
190 
191 
192         // Update balance.
193         sellOrderBalances[h] = safeAdd(sellOrderBalances[h], tokenAmount);
194 
195         // Check allowance.  -- Done after updating balance bc it makes a call to an untrusted contract.
196         require(tokenAmount <= ERC20Interface(token).allowance(msg.sender, this));
197 
198         // Grab the token.
199         if (!ERC20Interface(token).transferFrom(msg.sender, this, tokenAmount)) {
200             revert();
201         }
202 
203 
204         MakeSellOrder(h, token, tokenAmount, weiAmount, msg.sender);
205     }
206 
207     // Makes an offer to trade msg.value wei for tokenAmount of token (an ERC20 token).
208     function makeBuyOrder(address token, uint256 tokenAmount) public payable {
209         require(tokenAmount != 0);
210         require(msg.value != 0);
211 
212         uint256 fee = feeFromTotalCost(msg.value, makeFee);
213         uint256 valueNoFee = safeSub(msg.value, fee);
214         bytes32 h = sha256(token, tokenAmount, valueNoFee, msg.sender);
215 
216         //put ether in the buyOrderBalances map
217         buyOrderBalances[h] = safeAdd(buyOrderBalances[h], msg.value);
218 
219         // Notify all clients.
220         MakeBuyOrder(h, token, tokenAmount, valueNoFee, msg.sender);
221     }
222 
223 
224     // Cancels all previous offers by msg.sender to trade tokenAmount of tokens for weiAmount of wei.
225     function cancelAllSellOrders(address token, uint256 tokenAmount, uint256 weiAmount) public {
226         bytes32 h = sha256(token, tokenAmount, weiAmount, msg.sender);
227         uint256 remain = sellOrderBalances[h];
228         delete sellOrderBalances[h];
229 
230         ERC20Interface(token).transfer(msg.sender, remain);
231 
232         CancelSellOrder(h, token, tokenAmount, weiAmount, msg.sender);
233     }
234 
235     // Cancels any previous offers to trade weiAmount of wei for tokenAmount of tokens. Refunds the wei to sender.
236     function cancelAllBuyOrders(address token, uint256 tokenAmount, uint256 weiAmount) public {
237         bytes32 h = sha256(token, tokenAmount, weiAmount, msg.sender);
238         uint256 remain = buyOrderBalances[h];
239         delete buyOrderBalances[h];
240 
241         if (!msg.sender.send(remain)) {
242             revert();
243         }
244 
245         CancelBuyOrder(h, token, tokenAmount, weiAmount, msg.sender);
246     }
247 
248     // Take some (or all) of the ether (minus fees) in the buyOrderBalances hash in exchange for totalTokens tokens.
249     function takeBuyOrder(address token, uint256 tokenAmount, uint256 weiAmount, uint256 totalTokens, address buyer) public {
250         require(tokenAmount != 0);
251         require(weiAmount != 0);
252         require(totalTokens != 0);
253 
254         bytes32 h = sha256(token, tokenAmount, weiAmount, buyer);
255 
256         // How many wei for the amount of tokens being sold?
257         uint256 transactionWeiAmountNoFee = safeMul(totalTokens, weiAmount) / tokenAmount;
258 
259         // Does the buyer (maker) have enough money in the contract?
260         uint256 unvestedMakeFee = calculateFee(transactionWeiAmountNoFee, makeFee);
261         uint256 totalTransactionWeiAmount = safeAdd(transactionWeiAmountNoFee, unvestedMakeFee);
262         require(buyOrderBalances[h] >= totalTransactionWeiAmount);
263 
264 
265         // Calculate the actual vested fees.
266         uint256 currentTakeFee = calculateFeeForAccount(transactionWeiAmountNoFee, takeFee, msg.sender);
267         uint256 currentMakeFee = calculateFeeForAccount(transactionWeiAmountNoFee, makeFee, buyer);
268 
269         // Proceed with transferring balances.
270 
271         // Update our internal accounting.
272         buyOrderBalances[h] = safeSub(buyOrderBalances[h], totalTransactionWeiAmount);
273 
274 
275         // Did the seller send enough tokens?  -- This check is here bc it calls to an untrusted contract.
276         require(ERC20Interface(token).allowance(msg.sender, this) >= totalTokens);
277 
278         // Send buyer their tokens and any fee refund.
279         if (currentMakeFee < unvestedMakeFee) {// the buyer got a fee discount. Send the refund.
280             uint256 refundAmount = safeSub(unvestedMakeFee, currentMakeFee);
281             if (!buyer.send(refundAmount)) {
282                 revert();
283             }
284         }
285         if (!ERC20Interface(token).transferFrom(msg.sender, buyer, totalTokens)) {
286             revert();
287         }
288 
289         // Grab our fee.
290         if (safeAdd(currentTakeFee, currentMakeFee) > 0) {
291             if (!feeAccount.send(safeAdd(currentTakeFee, currentMakeFee))) {
292                 revert();
293             }
294         }
295 
296         // Send seller the proceeds.
297         if (!msg.sender.send(safeSub(transactionWeiAmountNoFee, currentTakeFee))) {
298             revert();
299         }
300 
301         TakeBuyOrder(h, token, tokenAmount, weiAmount, totalTokens, buyer, msg.sender);
302     }
303 
304 
305     function takeSellOrder(address token, uint256 tokenAmount, uint256 weiAmount, address seller) public payable {
306 
307         require(tokenAmount != 0);
308         require(weiAmount != 0);
309 
310         bytes32 h = sha256(token, tokenAmount, weiAmount, seller);
311 
312         // Check that the contract has enough token to satisfy this order.
313         uint256 currentTakeFee = feeFromTotalCostForAccount(msg.value, takeFee, msg.sender);
314         uint256 transactionWeiAmountNoFee = safeSub(msg.value, currentTakeFee);
315         uint256 totalTokens = safeMul(transactionWeiAmountNoFee, tokenAmount) / weiAmount;
316         require(sellOrderBalances[h] >= totalTokens);
317 
318         // Calculate total vested fee.
319         uint256 currentMakeFee = calculateFeeForAccount(transactionWeiAmountNoFee, makeFee, seller);
320         uint256 totalFee = safeAdd(currentMakeFee, currentTakeFee);
321 
322         uint256 makerProceedsAfterFee = safeSub(transactionWeiAmountNoFee, currentMakeFee);
323 
324         // Transfer.
325 
326         // Update internal accounting.
327         sellOrderBalances[h] = safeSub(sellOrderBalances[h], totalTokens);
328 
329         // Send buyer the tokens.
330         if (!ERC20Interface(token).transfer(msg.sender, totalTokens)) {
331             revert();
332         }
333 
334         // Take our fee.
335         if (totalFee > 0) {
336             if (!feeAccount.send(totalFee)) {
337                 revert();
338             }
339         }
340 
341         // Send seller the proceeds.
342         if (!seller.send(makerProceedsAfterFee)) {
343             revert();
344         }
345 
346         TakeSellOrder(h, token, tokenAmount, weiAmount, transactionWeiAmountNoFee, msg.sender, seller);
347     }
348 }